# Relato de Extensão — Mercado Pontos (IA para Devs)

> **Status: COMPLETO, aguardando os dados pessoais do autor.** Todo o
> conteúdo que podia ser apurado a partir do projeto já está escrito e
> conferido contra o sistema real. Os poucos trechos marcados com
> `[AJUSTAR: ...]` que restam dependem exclusivamente do autor — estão
> listados no final, em "Próximos passos deste documento".

> **Nota sobre origem do conteúdo (transparência metodológica):** este
> documento foi redigido com apoio do Claude Code (IA). Cada tipo de conteúdo
> está marcado quanto à origem:
> - **Estatísticas com citação numerada/link** (ex: "88,3% dos brasileiros...")
>   vêm de pesquisa real publicada por terceiros — fonte completa na seção
>   **Fontes**, ao final.
> - **Respostas de diagnóstico** (Parte I, seção 2) são as **respostas reais
>   do próprio autor**, dadas diretamente à IA durante o desenvolvimento
>   (2026-09-16) — não foram inventadas.
> - **Texto corrido sem citação** (enquadramento, objetivos, relato pessoal)
>   foi **redigido pela IA** a partir dos dados reais acima e do histórico
>   real de desenvolvimento (commits, decisões, bugs encontrados) — **precisa
>   de revisão e ajuste de voz pelo autor antes da entrega**, especialmente
>   o relato em primeira pessoa da Parte III, que deve soar como a voz dele,
>   não da IA.
> - **`[AJUSTAR: ...]`** marca lacunas que só o autor pode preencher (datas,
>   links, decisões finais).

> **Nota sobre a comunidade consultada**: esta atividade de extensão foi
> realizada **individualmente**, sem uma comunidade externa disponível para
> consulta. O "diagnóstico" da Parte I reflete a experiência e opinião reais
> do próprio autor como consumidor, coletadas em conversa direta com a IA
> durante o desenvolvimento — não uma pesquisa com terceiros. Isso é
> declarado abertamente no texto abaixo, em vez de fabricar respostas de
> pessoas que não foram consultadas.

## I - Diagnóstico e Teorização

### 1. Identificação das partes envolvidas e parceiros

Esta atividade de extensão foi realizada de forma **individual**, sem uma
comunidade externa ou instituição parceira disponível para consulta. A parte
envolvida é o próprio autor, na dupla condição de **desenvolvedor da
solução** e **consumidor final** do tipo de problema que ela resolve —
alguém que compra em supermercado regularmente e vivencia na prática a
situação-problema descrita a seguir.

Perfil do autor/participante:
- **Quantidade de participantes:** 1 (o próprio autor)
- **Faixa etária, escolaridade e perfil socioeconômico:** `[AJUSTAR: autor preenche com seus próprios dados]`
- **Localização:** `[AJUSTAR: cidade/estado do autor]`

### 2. Situação-problema identificada

Na ausência de uma comunidade externa, o diagnóstico foi feito a partir da
experiência real do próprio autor como consumidor, coletada em conversa
direta com a IA durante o desenvolvimento (2026-09-16), respondendo às
mesmas perguntas que seriam feitas a uma comunidade: (a) o que faz com a
nota fiscal depois de pagar a compra; (b) sua experiência com programas de
pontos/fidelidade de supermercado; (c) se usaria uma ferramenta simples de
pontos baseada na nota fiscal; (d) seu nível de familiaridade com IA
aplicada a tarefas do dia a dia.

Respostas reais do autor:
- **Nota fiscal:** joga fora / nem repara — a nota não tem nenhum uso depois
  da compra.
- **Fidelidade:** nunca usou nem conhece nenhum programa de pontos de
  supermercado.
- **Interesse na ferramenta:** usaria com frequência se existisse.
- **Familiaridade com IA:** tinha uma ideia geral de como uma IA generativa
  consegue interpretar texto bagunçado antes deste trabalho, mas não uma
  experiência prática aplicada a esse tipo de tarefa.

**Dado real de mercado para contextualizar** (não substitui as respostas da
comunidade, mas embasa a relevância do tema) — **fonte: pesquisa da
Associação Brasileira das Empresas do Mercado de Fidelização (Abemf),
2025/2026, ver seção Fontes ao final [1][2][3]**: **88,3% dos brasileiros
participam de pelo menos um programa de fidelidade**, e **66% participam
especificamente de programas de fidelidade em supermercados físicos** —
porém supermercados aparecem apenas em 4º lugar em preferência (30,4%),
atrás de companhias aéreas, postos de combustível e instituições
financeiras. Isso sugere espaço real para melhorar a experiência de
fidelidade no varejo alimentar. O setor de programas de fidelidade no Brasil
faturou R$ 6,3 bilhões só no 1º trimestre de 2026, crescimento de 11,2% em
relação ao mesmo período de 2025, com 306,2 milhões de assinantes ativos.
*(Dados obtidos via busca na web pela IA em 2026-09-12 — conferir os links
antes da entrega, pois pesquisas de mercado podem ser revisadas.)*

Situação-problema resumida: *consumidores descartam notas fiscais de
supermercado sem nenhum benefício, ao mesmo tempo em que a adesão a
programas de fidelidade no varejo alimentar é proporcionalmente menor do que
em outros setores — e há baixo conhecimento sobre como ferramentas de IA
generativa poderiam simplificar e popularizar esse tipo de programa para
redes menores, que não têm orçamento para um CRM de fidelidade caro.*

### 3. Demanda sociocomunitária e motivação acadêmica

A ausência de um jeito simples de transformar a nota fiscal em benefício
real impacta o bolso do consumidor e a capacidade de redes menores de
competir com grandes players que já têm programas de fidelidade
estabelecidos. No caso do autor, essa dor é concreta: nunca usou nem
conhece programas de fidelidade de supermercado, mas afirma que usaria uma
ferramenta assim com frequência — evidência de que a barreira não é falta
de interesse, e sim a ausência de uma opção simples o suficiente para valer
a pena.

Os conteúdos estudados na disciplina de Inteligência Artificial para Devs —
sobre como IA generativa pode estruturar dados não estruturados (como o
texto livre de uma nota fiscal) sem depender de OCR/parsers rígidos —
motivaram o desenvolvimento de uma solução técnica concreta: um programa de
fidelidade ("Mercado Pontos") construído em Salesforce, no qual o cliente
cola o texto da sua nota fiscal, uma IA (Einstein Prompt Builder) extrai e
categoriza os itens automaticamente, pontos são calculados e podem ser
trocados por produtos — democratizando, com recursos nativos e sem custo de
API externa, um tipo de solução que hoje só grandes redes conseguem bancar.

### 4. Objetivos a serem alcançados em relação à situação-problema identificada

**Objetivo 1:** Desenvolver e publicar um site funcional (Experience Cloud)
onde o cliente envia o texto da nota fiscal e recebe pontos calculados
automaticamente por IA, até `[AJUSTAR: data de entrega]`.

**Objetivo 2:** Ampliar o conhecimento prático do próprio autor sobre
aplicações reais de IA generativa em desenvolvimento de software, medido
pela quantidade de decisões de arquitetura de IA efetivamente tomadas e
documentadas (ex: escolha entre Prompt Builder e Agentforce, tratamento de
limitações reais de plataforma) ao longo da construção da solução, até o
encerramento da atividade.

---

## II - Planejamento para Desenvolvimento do Projeto

> Nota sobre origem: o cronograma abaixo usa as datas reais dos commits do
> repositório git do projeto como evidência objetiva de quando cada etapa
> foi executada (não são datas estimadas). O texto de cada ação foi
> redigido pela IA a partir desse histórico real, em conversa com o autor.

### 1. Plano de trabalho com cronograma das atividades

**Objetivo 1:** Desenvolver e publicar um site funcional (Experience Cloud)
onde o cliente envia o texto da nota fiscal e recebe pontos calculados
automaticamente, até `[AJUSTAR: data de entrega]`. Execução real: de
06/09/2026 a 16/09/2026 (datas comprovadas pelos commits do repositório).

**Ação 1 — Definição da arquitetura e modelo de dados** (06/09/2026)
Como fazer: levantamento das ferramentas de IA nativas disponíveis no
Salesforce (Prompt Builder, Agentforce) já licenciadas no org, escolha da
stack (Apex + LWC + Experience Cloud), modelagem dos objetos
`NotaFiscal__c`, `ItemNotaFiscal__c`, `ProdutoResgate__c`, `Resgate__c`.
Para quem: o próprio autor. Onde: ambiente de desenvolvimento Salesforce
(org `doacao-org`, Developer Edition), com apoio do assistente de IA
Claude Code para pair-programming.

**Ação 2 — Lógica de negócio e interface (LWC)** (06/09/2026)
Como fazer: implementação dos serviços Apex de processamento de nota
fiscal e resgate de pontos, com testes automatizados, e dos componentes de
interface (`enviarNotaFiscal`, `extratoPontos`, `catalogoResgate`).
Cobertura de testes medida ao final do projeto (16/09/2026, execução real
da suíte): `NotaFiscalProcessingService` 98%, `RegistrarNotaFiscalAction`
97%, `ResgateService` 96%, `MercadoPontosController` 91%,
`ProcessarNotaFiscalQueueable` 89% — 25 testes das classes deste projeto,
todos passando.

**Ação 3 — Autodiagnóstico** (16/09/2026)
Como fazer: na ausência de uma comunidade externa disponível, o autor
respondeu diretamente, em conversa com a IA, às mesmas perguntas que
seriam feitas a uma comunidade — hábitos de compra, uso de programas de
fidelidade e familiaridade com IA (ver respostas completas na Parte I).
Para quem: o próprio autor. Onde: durante a sessão de desenvolvimento.

**Ação 4 — Integração de IA generativa** (12 a 13/09/2026)
Como fazer: tentativa de extração de dados da nota fiscal via Einstein
Prompt Builder chamado por Apex; ao esbarrar em um bug de plataforma na
ativação do template (documentado na Parte III), pivot para usar o
Agentforce como camada conversacional de IA, com uma ação Apex
determinística (`RegistrarNotaFiscalAction`) para persistência dos dados.

**Ação 5 — Publicação do site Experience Cloud** (14/09/2026)
Como fazer: criação do site "Mercado Pontos" (template Build Your Own
LWR), configuração de self-registration e permissões de acesso
(profiles), publicação e teste real por um usuário de fora do ambiente de
desenvolvimento.

**Ação 6 — Refinamento a partir do uso real** (14 a 16/09/2026)
Como fazer: correção de problemas encontrados apenas durante o uso real do
site publicado (formatação de valores, imagens do catálogo, idioma da
tela de login), adição de melhorias de experiência (catálogo responsivo,
tela de checkout de resgate com confirmação, formulário de endereço de
entrega, cabeçalho do site). Detalhes completos na Parte III.

**Ação 7 — Verificação final e fechamento** (16/09/2026)
Como fazer: execução completa da suíte de testes automatizados para
confirmar que o sistema continuava íntegro ao final (o que revelou e
corrigiu uma regressão real de `MIXED_DML_OPERATION` nos testes de usuário
de portal), auditoria dos templates de e-mail do site para garantir que
nenhuma identidade de terceiros vazasse nas mensagens enviadas aos
clientes, e consolidação da documentação e das evidências do processo.

### 2. Envolvimento do público participante

Por se tratar de uma atividade individual, sem comunidade externa, o
"público participante" é o próprio autor, nos dois papéis já descritos: ele
forneceu o diagnóstico real (Parte I) e também testou pessoalmente o site
publicado de ponta a ponta (cadastro, login, envio de nota, resgate com
QR code) na condição de usuário final da própria solução.

Registros de evidência desse uso real estão listados na Parte III, seção
"Evidências das atividades realizadas" (item 5): prints do site publicado
sendo usado pelo autor — cadastro, envio de nota, extrato de pontos e
resgate com QR code.

### 3. Avaliação dos resultados alcançados

**Objetivo 1** (site funcional publicado): avaliado objetivamente — o site
está publicado e ao vivo (status `Live`, confirmado via consulta ao objeto
`Network` do Salesforce e por acesso real à URL pública, que responde
normalmente), testado com um fluxo real de ponta a ponta
(cadastro → envio de nota → crédito de pontos → resgate com QR code de
retirada), com o código versionado em git (repositório local, commits
diários entre 06/09/2026 e 16/09/2026) e a suíte de testes automatizados
passando integralmente
(94 testes executados no org, 100% de aprovação; cobertura global do org em
87%).

**Objetivo 2** (conhecimento prático de IA generativa): avaliado pelas
decisões de arquitetura de IA efetivamente tomadas e documentadas ao longo
do projeto — entre elas, a escolha inicial do Prompt Builder, a
identificação de um bug real de plataforma nele, o pivot para Agentforce,
a identificação de um segundo bug real no Agentforce, e a decisão final de
usar IA generativa apenas na camada conversacional (Agentforce) enquanto o
registro de dados permanece determinístico — todas descritas em detalhe na
Parte III.

## III - Encerramento do Projeto

### 1. Relato da experiência individual no desenvolvimento da atividade

**1. Contextualização**

> `[AJUSTAR: rascunho em primeira pessoa gerado pela IA a partir dos fatos
> reais do desenvolvimento — revisar e ajustar pra sua própria voz antes de
> entregar.]`

Desenvolvi este trabalho sozinho, sem uma comunidade externa disponível
para consulta, o que me levou a usar minha própria experiência como
consumidor como ponto de partida: nunca usei nem conheço programas de
fidelidade de supermercado, mas sei que usaria um com frequência se
existisse algo simples o suficiente. Essa dor pessoal foi o que motivou a
escolha do tema.

Escolhi construir a solução inteira em Salesforce, plataforma com a qual já
tinha familiaridade de um trabalho anterior, e decidi usar o máximo
possível dos recursos de IA generativa já licenciados no org (Prompt
Builder, Agentforce) em vez de depender de uma chave de API externa que eu
não tinha. Essa escolha acabou sendo o coração da experiência: entender IA
generativa "para Devs" não como uma chamada de API isolada, mas como uma
peça que precisa se encaixar — com sucesso ou com limitações reais — dentro
de uma plataforma inteira, com suas próprias regras de segurança,
metadados e bugs.

Passei o desenvolvimento inteiro em par com um assistente de IA (Claude
Code), o que tornou o próprio processo de construção um exemplo prático dos
conteúdos da disciplina: usei IA para gerar código, mas também para
pesquisar documentação real, investigar bugs de plataforma com evidência
(queries SOQL, logs de deploy, issues públicas) em vez de tentativa e erro,
e tomar decisões de arquitetura junto comigo quando o caminho planejado não
funcionava.

**2. Metodologia**

O desenvolvimento foi feito em pareceria com um assistente de IA (Claude
Code), com todo o histórico de decisões, prompts e ações registrado (ver
`docs/historico-conversa-claude-code.md`, gerado por
`scripts/gerar-historico-claude.ps1`). O projeto foi versionado em git
desde o primeiro commit, com mensagens descrevendo cada etapa e cada
problema real encontrado.

**3. Resultados e Discussão**

O resultado técnico é um site publicado e funcional (Experience Cloud,
Apex, LWC, Agentforce) que resolve a situação-problema identificada. Mas
o valor mais interessante deste trabalho, para uma disciplina de
Inteligência Artificial para Devs, está nas **dificuldades reais
enfrentadas e como foram investigadas e contornadas** — a maioria delas
bugs de plataforma genuínos, não erros de configuração:

1. **Metadata inválido**: campos `MasterDetail` e `LongTextArea` não
   aceitam a tag `required` no Metadata API.
2. **FLS (Field-Level Security) de campos opcionais**: campos custom
   criados via Metadata API não ganham permissão de leitura automática no
   profile Admin nem em profiles de portal — só campos obrigatórios ficam
   implicitamente visíveis. Descoberto porque consultas SOQL simples
   devolviam erro de "coluna inexistente" mesmo logado como
   administrador do sistema.
3. **Bug real do Einstein Prompt Builder**: o template de extração de
   dados funcionava perfeitamente no modo Preview, mas nunca podia ser
   chamado via Apex (`ConnectApi.EinsteinLLM`), sempre retornando "No
   active template version" — mesmo após deploy com status Published,
   recriação do template do zero e troca de modelo (GPT-5 Mini, Claude
   via Bedrock). Investigação (incluindo pesquisa de uma issue pública no
   GitHub do Salesforce CLI) revelou que é um bug conhecido: o schema do
   `GenAiPromptTemplate` mudou de número de versão inteiro para um hash,
   e o deploy via Metadata API não consegue apontar esse ponteiro
   corretamente.
4. **Pivot de arquitetura**: diante do bug acima, a extração de dados da
   nota fiscal foi movida do Prompt Builder isolado para uma conversa com
   um Agent do Agentforce, que interpreta o texto e chama uma ação Apex
   determinística — uma decisão de engenharia tomada em tempo real diante
   de uma limitação de plataforma, não o plano original.
5. **Segundo bug de IA generativa, agora no Agentforce**: mesmo com o
   Agent configurado corretamente (ação anexada, variáveis mapeadas,
   versão comitada e agente ativado), o Trace do Agent Builder sempre
   mostrava "Available Actions: 0 Actions" — a ação nunca era
   efetivamente chamada. Confirmado via metadata que nenhum
   `GenAiFunction` correspondente havia sido realmente criado no org,
   apesar da UI mostrar tudo configurado. Mesma categoria de bug do item
   3: interface mostra "pronto", backend não reflete isso.
6. **"Portal account owner must have a role"**: erro real do Salesforce
   ao tentar vincular uma Account a um usuário de self-registration — a
   Account precisa que seu dono (owner) tenha um Role atribuído,
   descoberto tanto em testes automatizados quanto em produção real (via
   e-mail de erro do próprio Salesforce ao tentar se cadastrar no site).
7. **Erro de mixed-DML na própria tela de administração do Salesforce**:
   a tela padrão "Login & Registration" do Experience Builder,
   ironicamente, falhava ao salvar com o erro clássico de Apex "DML
   operation on setup object is not permitted after you have updated a
   non-setup object" — contornado atualizando o registro
   `NetworkSelfRegistration` diretamente pela API de dados. A mesma
   restrição de plataforma voltou a aparecer na verificação final do
   projeto, desta vez nos testes automatizados: o `@TestSetup` dos testes
   de usuário de portal criava um `UserRole` (objeto de setup) e uma
   `Account` (objeto comum) na mesma transação, derrubando 5 testes com o
   mesmo erro. Corrigido isolando o DML dos objetos de setup dentro de um
   bloco `System.runAs`, contorno padrão previsto pela plataforma.
8. **CSP bloqueando imagens externas**: imagens do catálogo de produtos
   não carregavam porque o domínio usado não estava na lista de CSP
   Trusted Sites do site — resolvido adicionando o domínio via metadata.
   O mesmo cuidado foi necessário ao trocar, no fim do projeto, as imagens
   de marcação de lugar por fotografias reais dos produtos (banco de
   imagens livre Pixabay): sem liberar `cdn.pixabay.com` no CSP, o
   catálogo voltaria a aparecer sem imagem alguma. As fotos escolhidas são
   genéricas e sem marcas visíveis, para não introduzir identidade de
   terceiros no site — mesmo critério aplicado aos e-mails (item 11).
9. **Formatação de valores monetários**: um campo de valor com
   `formatter="currency"` interpretava "137.40" como 13740 (tratando o
   ponto como separador de milhar, não decimal) — trocado por um campo de
   texto com normalização manual, mais tolerante ao formato brasileiro.
10. **Leitura de imagem no Agentforce não disponível neste org**: a
    Salesforce documenta publicamente que o Agentforce suporta entrada
    multimodal (imagem, PDF), citando leitura de recibo/nota fiscal como
    caso de uso — o que seria uma evolução natural deste projeto (enviar a
    foto da nota em vez de colar o texto). Na prática, o chat de teste do
    Agent Builder deste org (Developer Edition) só oferece entrada de
    áudio, sem nenhum ícone de anexar imagem — indicando que esse recurso
    provavelmente depende de Data Cloud efetivamente configurado (não
    basta ter a licença, que este org já tem), algo fora do escopo deste
    trabalho. Documentado como uma limitação real e consciente, não uma
    tentativa malsucedida às cegas.
11. **E-mails do site vazando identidade de outro projeto**: os e-mails
    padrão do Salesforce (boas-vindas, nova senha) são **templates
    compartilhados por todos os sites do mesmo org** — incluindo o do
    outro trabalho acadêmico (Sistemas de Informação e Sociedade) que usa
    este mesmo org. A assinatura padrão usa `{!Organization.Name}`, que
    mostrava o nome da organização real do org (não relacionado a nenhum
    dos dois projetos). Editar os templates diretamente resolve os dois
    sites de uma vez (trocado por uma assinatura genérica, "Salesforce")
    sem precisar duplicar templates por site — mas exigiu identificar,
    consultando os templates via SOQL (a Metadata API não consegue nem
    recuperar esses templates de sistema, só a API de dados consegue),
    quais dos 11 templates realmente usavam esse campo (só 2 usavam; os
    outros 9 já usam `{!Community_Name}`, que é seguro). O
    compartilhamento foi comprovado de forma objetiva consultando o objeto
    `Network`: os dois sites do org (`Mercado Pontos` e o do outro
    trabalho) apontam para exatamente os **mesmos três Ids de template**
    de boas-vindas, troca e recuperação de senha — ou seja, não é uma
    suposição, é a configuração real da plataforma. Uma auditoria final
    varrendo os 42 templates do org confirmou que os três efetivamente
    usados pelos sites ficaram limpos, e que as ocorrências restantes de
    `{!Organization.Name}` estão apenas em templates de exemplo padrão do
    Salesforce, não referenciados por nenhum dos dois sites. Também
    identificado que o **idioma padrão do org inteiro** está em inglês
    (`en_US`), o que faz novos usuários que se autocadastram no site
    herdarem inglês por padrão, mesmo o site estando configurado em
    português — corrigido usuário por usuário conforme aparecem, já que
    mudar o padrão do org afetaria os dois projetos.

Essas descobertas mostram na prática algo central pra disciplina: **usar
IA generativa em produção não é só "chamar uma API"** — envolve lidar com
imaturidade de plataforma, debugar com evidência real (queries, logs de
deploy, pesquisa de issues públicas) em vez de tentativa e erro cego, e
tomar decisões de arquitetura (como o pivot Prompt Builder → Agentforce)
quando a solução ideal esbarra em uma limitação real.

> `[AJUSTAR: rascunho em primeira pessoa gerado pela IA — revisar e ajustar
> pra sua própria voz antes de entregar.]`

O mais desafiador não foi escrever código — foi aceitar, mais de uma vez,
que uma funcionalidade que deveria funcionar "do jeito que a documentação
da Salesforce descreve" simplesmente não funcionava naquele org, e que a
solução não era insistir mais, e sim investigar com evidência real por que
não funcionava, documentar isso, e decidir um caminho alternativo. Isso
aconteceu duas vezes com peças de IA generativa (Prompt Builder e depois
Agentforce) e outras tantas com recursos "comuns" do Salesforce (FLS,
mixed-DML, templates de e-mail compartilhados entre sites). Aprendi, na
prática, que trabalhar com IA em produção — e com plataformas de nuvem em
geral — exige tanto saber construir quanto saber debugar e decidir quando
mudar de estratégia.

Resultados conforme a Seção 3 da Parte II: alcançados. O site está
publicado, testado de ponta a ponta por mim mesmo, e o conhecimento prático
sobre IA generativa aplicada a desenvolvimento se traduziu em decisões de
arquitetura reais, documentadas neste relatório.

### 2. Evidências das atividades realizadas

As evidências abaixo documentam tanto o **produto final** (o site
funcionando) quanto o **processo de construção** — este último especialmente
relevante para uma disciplina de Inteligência Artificial para Devs, já que o
desenvolvimento inteiro foi feito em par com uma IA.

**1. Site publicado e no ar** —
https://orgfarm-375b864f55-dev-ed.develop.my.site.com/mercadopontos
É a entrega principal do Objetivo 1: um site Experience Cloud público, com
cadastro próprio, onde o cliente envia o texto da nota fiscal, acumula
pontos e os troca por produtos. Status `Live` confirmado por consulta ao
objeto `Network` do Salesforce.

**2. Histórico completo da conversa de desenvolvimento com a IA** —
`docs/historico-conversa-claude-code.md`
Transcrição de todas as sessões de trabalho com o assistente de IA (Claude
Code), gerada automaticamente pelo script
`scripts/gerar-historico-claude.ps1` a partir dos registros locais da
ferramenta. É a evidência mais direta do processo: mostra as decisões de
arquitetura sendo tomadas, os bugs sendo investigados com evidência real
(consultas, logs, pesquisa de documentação) e os momentos em que o plano
original precisou mudar. Documenta o objeto de estudo da disciplina — o uso
de IA no desenvolvimento — pelo próprio ato de tê-lo usado.

**3. Repositório git do projeto** — repositório **local**, não publicado em
servidor remoto. Reúne cerca de 30 commits entre 06/09/2026 e 16/09/2026, com
mensagens descritivas que registram cada etapa e cada problema real
encontrado (por exemplo, os commits que documentam o pivot do Prompt
Builder para o Agentforce e a correção dos templates de e-mail). Serve como
linha do tempo objetiva do trabalho — as datas do cronograma da Parte II
vêm dele.

**4. Suíte de testes automatizados** — execução real em 16/09/2026: 94
testes no org, 100% de aprovação, cobertura global de 87%. Das classes
deste projeto: `NotaFiscalProcessingService` 98%,
`RegistrarNotaFiscalAction` 97%, `ResgateService` 96%,
`MercadoPontosController` 91%, `ProcessarNotaFiscalQueueable` 89%.
Evidencia que a lógica de negócio (cálculo de pontos, bloqueio de nota
duplicada, validação de CPF, controle de saldo e estoque) está de fato
verificada, e não apenas "funcionando na tela".

**5. Registros visuais do sistema** (prints a anexar — ver lista na seção
"Próximos passos deste documento"): demonstram o modelo de dados, o código,
a configuração da IA e o sistema em uso real pelo autor.

---

## Próximos passos deste documento

Tudo o que podia ser resolvido de forma automática já foi (cronograma a
partir das datas reais dos commits, números reais de cobertura de testes,
auditoria dos e-mails, contextualização das evidências). Restam **apenas os
itens que dependem do autor**:

**1. Preencher os dados pessoais** marcados como `[AJUSTAR]` na Parte I,
seção 1: faixa etária, escolaridade e perfil socioeconômico, e
cidade/estado.

**2. Preencher a data de entrega** nos dois pontos marcados `[AJUSTAR]`
(Parte I, Objetivo 1; e Parte II, seção 1).

**3. Revisar o texto em primeira pessoa da Parte III** (Contextualização e
o parágrafo de impressões finais) — foi redigido pela IA a partir dos fatos
reais do desenvolvimento, mas precisa soar com a sua própria voz antes da
entrega. Os fatos estão corretos; o que pode mudar é o jeito de contar.

**4. Tirar e anexar os prints** (item 5 das Evidências). Sugestão de lista,
cobrindo cada parte do que foi construído:
- *Modelo de dados*: Setup → Object Manager, mostrando os objetos
  `NotaFiscal__c`, `ItemNotaFiscal__c`, `ProdutoResgate__c` e `Resgate__c`.
- *Código e testes*: a lista de classes Apex e a tela de resultado da
  execução dos testes com a cobertura.
- *Componentes de interface*: a lista de componentes LWC do projeto.
- *IA generativa*: o Agent Builder (Agentforce) com o agente
  `Mercado_Pontos_Assistente`, e uma conversa de teste em que ele
  interpreta o texto de uma nota fiscal — esta é a evidência visual mais
  importante para a disciplina.
- *Sistema em uso*: Home do site, tela de cadastro, envio de uma nota,
  extrato de pontos, catálogo, checkout do resgate, tela de confirmação com
  o QR code, e o e-mail de confirmação recebido na caixa de entrada.

**5. Decidir se o repositório git será publicado** (GitHub, por exemplo).
Hoje ele é local, e o relatório está escrito dessa forma na seção de
Evidências. Se optar por publicar, basta trocar aquela frase pelo link.

## Fontes

Buscadas pela IA (Claude Code) via pesquisa na web em 2026-09-12, para
embasar a seção "Situação-problema" com dados reais de mercado:

1. [88% dos brasileiros utilizam programas de fidelidade, diz pesquisa da Abemf](https://www.panrotas.com.br/mercado/pesquisas-e-estatisticas/2025/10/88-dos-brasileiros-utilizam-programas-de-fidelidade-diz-pesquisa-da-abemf_222537.html) — Panrotas
2. [Sete em cada dez brasileiros já aderiram a programas de fidelidade em supermercados](https://www.superhiper.com.br/sete-em-cada-dez-brasileiros-ja-aderiram-a-programas-de-fidelidade-em-supermercados/) — SuperHiper
3. [88% dos brasileiros utilizam programas de fidelidade, segundo pesquisa](https://www.apras.org.br/noticias/88-dos-brasileiros-utilizam-programas-de-fidelidade-segundo-pesquisa/) — APRAS

Buscadas em 2026-09-16, para embasar duas decisões de design reais do projeto:

4. [Dúvidas Frequentes — Pão de Açúcar (retirada de prêmio físico em loja, não entrega)](https://www.paodeacucar.com/duvidas-frequentes/7/7.22/como-funciona-o-pagstix) — motivou a mudança do resgate de "entrega por Correios" para "retirada em loja com QR code" (item de Resultados e Discussão).
5. [Turn Images & PDFs Into AI-Powered Insights With Agentforce — Salesforce Admins](https://admin.salesforce.com/blog/2025/turn-images-pdfs-into-ai-powered-insights-with-agentforce) — confirma que leitura de imagem/recibo é um recurso real do Agentforce (não disponível neste org especificamente, ver item 10 de Resultados e Discussão).
