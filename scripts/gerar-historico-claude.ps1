<#
    Gera um historico legivel (Markdown) de TODAS as sessoes do Claude Code
    deste projeto, a partir dos transcripts locais (.jsonl) guardados em
    ~/.claude/projects/. Usado como evidencia do processo de desenvolvimento
    assistido por IA para o trabalho de extensao de IA para Devs.

    Reexecute este script a qualquer momento (inclusive em dias diferentes,
    apos continuar a sessao) para regenerar o historico completo e atualizado
    antes da entrega final.
#>
param(
    # Localiza as pastas de transcripts sem depender de um caminho fixo. O
    # Claude Code separa as sessoes por caminho do projeto, e este projeto ja
    # mudou de pasta uma vez - entao existe mais de uma pasta de transcripts, e
    # todas precisam entrar. Pegar so a primeira descartaria o historico
    # anterior a mudanca, que e a maior parte do trabalho.
    [string[]]$ProjectDirs = @(Get-ChildItem (Join-Path $env:USERPROFILE ".claude\projects") -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "*Trabalho-2" } | Select-Object -ExpandProperty FullName),
    [string]$OutPath = "docs\historico-conversa-claude-code.md"
)

<#
    O projeto fica dentro de uma pasta sincronizada cujo nome identifica o
    empregador do autor, entao esse nome apareceria em cada caminho de arquivo
    citado no historico. Como este documento e anexado ao trabalho e o
    repositorio e publico, os identificadores sao trocados por marcadores
    neutros antes de gravar.

    Os termos a ocultar sao deduzidos do caminho real em tempo de execucao, e
    nao escritos aqui - senao o proprio script passaria a expor o nome.
#>
$RaizProjeto = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$PastaSincronizada = ($RaizProjeto -split '\\' | Where-Object { $_ -like "* - *" } | Select-Object -First 1)
if (-not $PastaSincronizada) {
    <#
        O projeto saiu da pasta sincronizada, mas os transcripts antigos citam
        o caminho antigo em cada comando - a ocultacao continua necessaria.
        A pasta em si continua no perfil do usuario, entao o nome vem de la.
    #>
    $PastaSincronizada = Get-ChildItem $env:USERPROFILE -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "OneDrive - *" } | Select-Object -First 1 -ExpandProperty Name
}
$NomeOculto = if ($PastaSincronizada) { ($PastaSincronizada -split ' - ', 2)[1] } else { $null }

function Sanitizar($texto) {
    if ($null -eq $texto) { return "" }

    # Caminho completo do projeto, nas formas Windows e Git Bash.
    $texto = $texto.Replace($RaizProjeto, '<PROJETO>')
    $texto = $texto.Replace(($RaizProjeto -replace '\\', '/'), '<PROJETO>')
    foreach ($dir in $ProjectDirs) { $texto = $texto.Replace($dir, '<TRANSCRIPTS>') }

    foreach ($v in $script:VariantesNome) {
        $texto = $texto -replace ('(?i)\b' + [regex]::Escape($v)), '<EMPRESA>'
    }
    return $texto
}

<#
    O resumo das ferramentas trunca comandos longos, entao o nome pode aparecer
    cortado no fim. Como o corte e sempre no fim, basta cobrir os prefixos do
    nome INTEIRO, do mais longo para o mais curto - prefixo por palavra
    isolada mutilaria palavras comuns do texto (ex.: "conseguem").
#>
$script:VariantesNome = @()
if ($NomeOculto) {
    $bases = @($NomeOculto, ($NomeOculto -replace '\s+', '-'))
    foreach ($base in $bases) {
        for ($i = $base.Length; $i -ge 3; $i--) {
            $script:VariantesNome += $base.Substring(0, $i).TrimEnd(' ', '-')
        }
    }

    <#
        Um comando pode tambem citar o nome comecando no meio dele - por
        exemplo uma busca pelas palavras do meio - e ai nenhum prefixo do nome
        inteiro pega. Entao cada palavra do nome vira um novo ponto de partida.
        (De novo sem exemplo literal aqui, pelo mesmo motivo do bloco acima.)

        Para nao mutilar palavras comuns que por acaso facam parte do nome, um
        trecho so entra se comecar numa palavra de pelo menos 4 letras e for
        longo o bastante para alcancar a palavra seguinte - ou seja, nunca uma
        palavra isolada.
    #>
    $MinimoAlemDaPalavra = 2  # espaco + 1 letra da palavra seguinte
    $palavras = $NomeOculto -split '\s+'
    for ($p = 1; $p -lt $palavras.Count; $p++) {
        if ($palavras[$p].Length -lt 4) { continue }
        $resto = ($palavras[$p..($palavras.Count - 1)]) -join ' '
        $minimo = $palavras[$p].Length + $MinimoAlemDaPalavra
        for ($i = $resto.Length; $i -ge $minimo; $i--) {
            $trecho = $resto.Substring(0, $i).TrimEnd(' ', '-')
            if ($trecho.Length -lt $minimo) { continue }
            $script:VariantesNome += $trecho
            $script:VariantesNome += ($trecho -replace '\s+', '-')
        }
    }

    $script:VariantesNome = $script:VariantesNome | Select-Object -Unique | Sort-Object { $_.Length } -Descending
}

function Truncate($text, $max) {
    if ($null -eq $text) { return "" }
    $text = $text -replace "\r?\n", " "
    if ($text.Length -gt $max) { return $text.Substring(0, $max) + "..." }
    return $text
}

function Resumo-ToolUse($block) {
    $name = $block.name
    $input = $block.input
    switch ($name) {
        "Bash" { return "``$($name)``: " + (Truncate $input.command 220) }
        "PowerShell" { return "``$($name)``: " + (Truncate $input.command 220) }
        "Write" { return "``$($name)``: $($input.file_path)" }
        "Edit" { return "``$($name)``: $($input.file_path)" }
        "Read" { return "``$($name)``: $($input.file_path)" }
        "Glob" { return "``$($name)``: $($input.pattern)" }
        "Grep" { return "``$($name)``: $($input.pattern)" }
        "AskUserQuestion" {
            $perguntas = ($input.questions | ForEach-Object { $_.question }) -join " / "
            return "``$($name)``: " + (Truncate $perguntas 250)
        }
        default { return "``$($name)``" }
    }
}

function Processar-Arquivo($caminho, $saida) {
    $linhas = Get-Content -Path $caminho -Encoding UTF8
    foreach ($linha in $linhas) {
        if ([string]::IsNullOrWhiteSpace($linha)) { continue }
        try {
            $obj = $linha | ConvertFrom-Json -ErrorAction Stop
        } catch {
            continue
        }

        if ($obj.type -eq "user" -and $obj.message.role -eq "user") {
            $content = $obj.message.content
            if ($content -is [string]) {
                $texto = $content.Trim()
                if ($texto -and $texto -notmatch "^<system-reminder>") {
                    $saida.Add("## Usuario")
                    $saida.Add("")
                    $saida.Add($texto)
                    $saida.Add("")
                }
            } elseif ($content) {
                foreach ($bloco in $content) {
                    if ($bloco.type -eq "text") {
                        $texto = $bloco.text -replace "(?s)<system-reminder>.*?</system-reminder>", ""
                        $texto = $texto.Trim()
                        if ($texto) {
                            $saida.Add("## Usuario")
                            $saida.Add("")
                            $saida.Add($texto)
                            $saida.Add("")
                        }
                    }
                }
            }
        }
        elseif ($obj.type -eq "assistant" -and $obj.message.role -eq "assistant") {
            $content = $obj.message.content
            if ($content) {
                foreach ($bloco in $content) {
                    if ($bloco.type -eq "text" -and $bloco.text.Trim()) {
                        $saida.Add("**Claude:** " + $bloco.text.Trim())
                        $saida.Add("")
                    }
                    elseif ($bloco.type -eq "tool_use") {
                        $saida.Add("- " + (Resumo-ToolUse $bloco))
                    }
                }
            }
        }
    }
}

if (-not $ProjectDirs) {
    throw "Nenhuma pasta de transcripts encontrada em $env:USERPROFILE\.claude\projects (esperado algo terminando em 'Trabalho-2')."
}

$arquivos = Get-ChildItem -Path $ProjectDirs -Filter "*.jsonl" | Sort-Object LastWriteTime
$saida = New-Object System.Collections.Generic.List[string]

$saida.Add("# Historico da conversa com Claude Code - Trabalho Mercado Pontos")
$saida.Add("")
$saida.Add("Gerado automaticamente a partir dos transcripts locais das sessoes do Claude")
$saida.Add("Code (arquivos `.jsonl` guardados em `~/.claude/projects/`), como evidencia do")
$saida.Add("processo de desenvolvimento assistido por IA para o trabalho de extensao de")
$saida.Add("Inteligencia Artificial para Devs.")
$saida.Add("")
$saida.Add("Sessoes incluidas: " + (($arquivos | ForEach-Object { $_.Name }) -join ", "))
$saida.Add("")
$saida.Add("---")
$saida.Add("")

foreach ($arquivo in $arquivos) {
    Processar-Arquivo $arquivo.FullName $saida
}

$saida = $saida | ForEach-Object { Sanitizar $_ }
$saida | Out-File -FilePath $OutPath -Encoding utf8
Write-Host "Gerado: $OutPath ($($saida.Count) linhas, $($arquivos.Count) sessao(oes))"
