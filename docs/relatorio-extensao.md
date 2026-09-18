# Relato de Extensão — Mercado Pontos (IA para Devs)

> **Nota sobre a elaboração deste relato:** coerente com o tema da
> disciplina, este documento foi redigido com apoio de um assistente de IA
> (Claude Code), a partir dos dados reais do projeto — commits, decisões de
> arquitetura, testes e problemas encontrados — e revisado pelo autor. As
> estatísticas de mercado vêm de pesquisas publicadas por terceiros, com as
> fontes listadas ao final. As respostas do diagnóstico (Parte I, seção 2)
> são as respostas reais do próprio autor.
>
> A atividade foi realizada **individualmente**, sem uma comunidade externa
> disponível para consulta. Por isso, o diagnóstico reflete a experiência
> real do autor como consumidor, e isso é declarado abertamente ao longo do
> texto, em vez de atribuir respostas a pessoas que não foram consultadas.

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
- **Faixa etária:** 32 anos
- **Escolaridade:** ensino superior incompleto (graduação em andamento, na
  modalidade a distância)
- **Perfil socioeconômico:** adulto economicamente ativo, empregado na área
  de tecnologia, com atuação em desenvolvimento de sistemas, que concilia o
  trabalho com a graduação a distância. Como consumidor, faz compras de
  supermercado com regularidade — o que o coloca diretamente no público da
  solução desenvolvida.
- **Localização:** Uberlândia/MG

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

**Dado real de mercado para contextualizar** (não substitui o diagnóstico do
autor, mas embasa a relevância do tema) — **fonte: pesquisa da
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
*(Dados levantados por pesquisa na web em 12/09/2026, com os links
conferidos em 17/09/2026.)*

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
envia o texto da sua nota fiscal, acumula pontos e os troca por produtos,
contando com um assistente de IA generativa (Agentforce) capaz de
interpretar o texto da nota — identificando estabelecimento, itens e
categorias — e sugerir produtos para resgate. A proposta é democratizar,
com recursos nativos da plataforma e sem custo de API externa, um tipo de
solução que hoje só grandes redes conseguem bancar.

### 4. Objetivos a serem alcançados em relação à situação-problema identificada

**Objetivo 1:** Desenvolver e publicar um site funcional (Experience Cloud)
onde o cliente envia o texto da nota fiscal, recebe pontos automaticamente
e os troca por produtos, apoiado por um assistente de IA generativa que
interpreta a nota, até 17/09/2026.

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
onde o cliente envia o texto da nota fiscal, recebe pontos automaticamente
e os troca por produtos, apoiado por um assistente de IA generativa que
interpreta a nota, até 17/09/2026. Execução real: de 06/09/2026 a
17/09/2026 (datas comprovadas pelos commits do repositório).

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
tela de checkout de resgate com confirmação, cabeçalho do site). Nessa
etapa, o resgate chegou a ter um formulário de endereço para entrega pelos
Correios, substituído em seguida por **retirada na loja com QR code e
validação de CPF/RG** — decisão tomada após pesquisar como funcionam os
grandes programas de fidelidade de supermercado no Brasil (fonte [4]).
Detalhes completos na Parte III.

**Ação 7 — Verificação final e fechamento** (16/09/2026)
Como fazer: execução completa da suíte de testes automatizados para
confirmar que o sistema continuava íntegro ao final (o que revelou e
corrigiu uma regressão real de `MIXED_DML_OPERATION` nos testes de usuário
de portal), auditoria dos templates de e-mail do site para garantir que
nenhuma identidade de terceiros vazasse nas mensagens enviadas aos
clientes, e consolidação da documentação e das evidências do processo.

**Ação 8 — Registro em vídeo e entrega** (17/09/2026)
Como fazer: gravação de um vídeo com o sistema publicado em uso real (envio
de nota, crédito de pontos e resgate com QR code), captura dos registros
visuais e fechamento deste relato. Para quem: o autor, como usuário final.
Onde: site publicado.

### 2. Envolvimento do público participante

Por se tratar de uma atividade individual, sem comunidade externa, o
"público participante" é o próprio autor, nos dois papéis já descritos: ele
forneceu o diagnóstico real (Parte I) e também testou pessoalmente o site
publicado de ponta a ponta (cadastro, login, envio de nota, resgate com
QR code) na condição de usuário final da própria solução.

Registros de evidência desse uso real estão listados na Parte III, seção
"Evidências das atividades realizadas": os prints do site publicado sendo
usado pelo autor — login, envio de nota, catálogo e confirmação do resgate
com QR code (item 5) — e o vídeo com o fluxo completo em uso real
(item 6).

### 3. Avaliação dos resultados alcançados

**Objetivo 1** (site funcional publicado): avaliado objetivamente — o site
está publicado e ao vivo (status `Live`, confirmado via consulta ao objeto
`Network` do Salesforce e por acesso real à URL pública, que responde
normalmente), testado com um fluxo real de ponta a ponta
(cadastro → envio de nota → crédito de pontos → resgate com QR code de
retirada), com o código versionado em git (repositório público em
https://github.com/rafaelfcreis/mercado-pontos, commits diários entre
06/09/2026 e 16/09/2026) e a suíte de testes automatizados passando
integralmente (94 testes executados no org, 100% de aprovação; cobertura
global do org em 88%).

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

*Levantamento de dados.* Sem uma comunidade externa, fiz um
autodiagnóstico: respondi às mesmas quatro perguntas que faria a um grupo
de consumidores (o que faço com a nota fiscal, se uso programas de
fidelidade, se usaria a ferramenta e o quanto conhecia de IA aplicada) —
respostas na Parte I. Complementei com pesquisa de dados de mercado sobre
programas de fidelidade no Brasil (fontes [1] a [3]) e com a pesquisa de
como um programa real de supermercado entrega os prêmios (fonte [4]), que
mudou o desenho do resgate.

*Desenvolvimento em par com IA.* Todo o sistema foi construído em sessões
com um assistente de IA (Claude Code): a IA propunha e implementava o
código, pesquisava documentação e investigava erros; eu tomava as decisões,
testava no site publicado e trazia de volta o que não funcionava. O
histórico completo dessas sessões está em
`docs/historico-conversa-claude-code.md`, e cada etapa foi versionada em git
com mensagens que explicam o que mudou e por quê.

*Implementação.* A solução roda inteira em Salesforce:
- **Modelo de dados:** objetos para a nota fiscal e seus itens, para o
  catálogo de produtos e para os resgates, além de um campo de saldo de
  pontos no cadastro do cliente. A chave de acesso da nota é única, o que
  impede que a mesma nota seja pontuada duas vezes.
- **Regras de negócio (Apex):** o processamento da nota credita 1 ponto por
  real gasto; o resgate verifica saldo e estoque, valida o CPF pelo dígito
  verificador, debita os pontos e gera um código de retirada de 8
  caracteres, exibido também como QR code para apresentar no caixa.
- **Interface (LWC):** componentes para enviar a nota, ver o extrato,
  navegar no catálogo com checkout e exibir o cabeçalho com o saldo,
  publicados num site Experience Cloud com cadastro próprio de clientes.
- **IA generativa:** a primeira tentativa usou o Einstein Prompt Builder
  para extrair os dados da nota; diante de um bug da plataforma, a IA foi
  levada para um agente do Agentforce ("Mercado Pontos Assistente"), que
  interpreta o texto da nota, identifica os itens e categorias e sugere
  produtos para resgate. O registro dos pontos ficou num caminho
  determinístico, pelo formulário do site, que não depende da IA para
  funcionar.

*Validação.* Usei três formas de verificação: testes automatizados (94
testes, 100% de aprovação, cobertura de 88% no org), o uso real do site
publicado por mim como cliente — que revelou vários problemas que os testes
não pegavam — e o registro dessas interações em prints e vídeo.

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

12. **E-mail de confirmação do resgate: enviado pela aplicação, mas não
    entregue ao destinatário**. O resgate grava o pedido, debita os pontos,
    gera o código de retirada e dispara um e-mail de confirmação. A
    aplicação cumpre sua parte: uma execução de diagnóstico em Apex mostrou
    que `Messaging.sendEmail` retorna sucesso, sem exceção, e o contato não
    registra nenhum *bounce*. Ainda assim, a mensagem nunca chegou à caixa
    de entrada. A investigação revelou duas causas distintas, ambas
    corrigidas no código: (a) o campo `Name` do objeto `Resgate__c` é
    auto-numérico, e o Apex **não preenche campos auto-numéricos no objeto
    em memória depois do `insert`** — o e-mail saía com "Resgate null
    confirmado" no assunto; (b) sem remetente explícito, a plataforma usa o
    e-mail do **usuário logado** como remetente, o que, num site de
    comunidade, faz a mensagem sair do endereço do próprio cliente para ele
    mesmo — um padrão que provedores como o Gmail tratam como tentativa de
    falsificação. Mesmo após as correções, a entrega não foi obtida, o que
    é coerente com a limitação de fundo: o org é um **Developer Edition**,
    sem domínio próprio autenticado (SPF/DKIM) para assinar as mensagens, e
    com teto de apenas **15 e-mails por dia** via Apex. Conclusão honesta:
    o envio é responsabilidade da aplicação e está correto; a **entrega**
    depende de infraestrutura de reputação de domínio que este ambiente não
    tem. Registra-se como limitação real, não como funcionalidade entregue.
    Um efeito colateral revelador é que o tratamento de erro do envio
    descartava a exceção silenciosamente — foi justamente esse silêncio que
    escondeu o problema por vários dias, um lembrete prático de que engolir
    exceção sem deixar rastro transforma uma falha visível em um mistério.

Essas descobertas mostram na prática algo central pra disciplina: **usar
IA generativa em produção não é só "chamar uma API"** — envolve lidar com
imaturidade de plataforma, debugar com evidência real (queries, logs de
deploy, pesquisa de issues públicas) em vez de tentativa e erro cego, e
tomar decisões de arquitetura (como o pivot Prompt Builder → Agentforce)
quando a solução ideal esbarra em uma limitação real.

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

**3. Repositório git do projeto** — **https://github.com/rafaelfcreis/mercado-pontos**
(público, acessível sem necessidade de conta).
Reúne mais de 40 commits entre 06/09/2026 e 17/09/2026, com
mensagens descritivas que registram cada etapa e cada problema real
encontrado (por exemplo, os commits que documentam o pivot do Prompt
Builder para o Agentforce e a correção dos templates de e-mail). Serve como
linha do tempo objetiva do trabalho — as datas do cronograma da Parte II
vêm dele.

**4. Suíte de testes automatizados** — execução real em 16/09/2026: 94
testes no org, 100% de aprovação, cobertura global de 88%. Das classes
deste projeto: `NotaFiscalProcessingService` 98%,
`RegistrarNotaFiscalAction` 97%, `ResgateService` 96%,
`MercadoPontosController` 91%, `ProcessarNotaFiscalQueueable` 89%.
Evidencia que a lógica de negócio (cálculo de pontos, bloqueio de nota
duplicada, validação de CPF, controle de saldo e estoque) está de fato
verificada, e não apenas "funcionando na tela".

**5. Registros visuais do sistema** — pasta `docs/evidencias/`. Demonstram o
sistema publicado em uso real pelo autor. Já capturados:
- `01-site-tela-de-login.png` — tela de login do site, com o cadastro
  próprio de clientes.
- `02-home-enviar-nota-fiscal-com-saldo.png` — página inicial com o
  formulário de envio da nota fiscal e o cabeçalho exibindo o saldo de
  pontos acumulado.
- `03-catalogo-de-resgate-com-imagens.png` — catálogo de resgate mostrando
  produtos, custo em pontos e saldo disponível.
- `04-confirmacao-de-resgate-com-qr-code.png` — tela de confirmação após um
  resgate real feito pelo autor no site publicado: o QR code de retirada, o
  código escrito equivalente (`L52NCU8Y`) e o saldo já debitado (de 149 para
  129 pontos, referentes ao produto de 20 pontos). É a evidência de que o
  fluxo completo — envio da nota, acúmulo de pontos e troca — funciona ponta
  a ponta em uso real, e não apenas nos testes automatizados.

**6. Vídeo de demonstração do sistema** —
https://drive.google.com/file/d/10h48TLGHwYjhBSTfGlDnCNIs91_OCWWE/view?usp=sharing
(arquivo `trabalho2.mp4`, disponível no Google Drive por ter tamanho acima
do limite de upload), gravado
pelo autor em 17/09/2026, com o site publicado em uso real. O vídeo percorre
o fluxo completo do cliente: com a conta já logada, o autor envia o texto de
uma nota fiscal (valor de R$ 137,40, que gerou 137 pontos creditados no
saldo), abre o catálogo e resgata o "Kit Café da Manhã" (80 pontos),
recebendo o QR code e o código de retirada na tela de confirmação. Os
registros gravados no Salesforce durante a gravação — a nota processada e o
resgate com o código gerado — confirmam que o que aparece no vídeo é o
sistema real funcionando, e não uma simulação. Complementa os prints 01 a 04
mostrando a sequência em movimento, do envio da nota até a troca.

---

## Fontes

Buscadas pela IA (Claude Code) via pesquisa na web em 2026-09-12, para
embasar a seção "Situação-problema" com dados reais de mercado:

1. [88% dos brasileiros utilizam programas de fidelidade, diz pesquisa da Abemf](https://www.panrotas.com.br/mercado/pesquisas-e-estatisticas/2025/10/88-dos-brasileiros-utilizam-programas-de-fidelidade-diz-pesquisa-da-abemf_222537.html) — Panrotas
2. [Sete em cada dez brasileiros já aderiram a programas de fidelidade em supermercados](https://www.superhiper.com.br/sete-em-cada-dez-brasileiros-ja-aderiram-a-programas-de-fidelidade-em-supermercados/) — SuperHiper
3. [88% dos brasileiros utilizam programas de fidelidade, segundo pesquisa](https://www.apras.org.br/noticias/88-dos-brasileiros-utilizam-programas-de-fidelidade-segundo-pesquisa/) — APRAS

Buscadas em 2026-09-16, para embasar duas decisões de design reais do projeto:

4. [Dúvidas Frequentes — Pão de Açúcar (retirada de prêmio físico em loja, não entrega)](https://www.paodeacucar.com/duvidas-frequentes/7/7.22/como-funciona-o-pagstix) — motivou a mudança do resgate de "entrega por Correios" para "retirada em loja com QR code" (item de Resultados e Discussão).
5. [Turn Images & PDFs Into AI-Powered Insights With Agentforce — Salesforce Admins](https://admin.salesforce.com/blog/2025/turn-images-pdfs-into-ai-powered-insights-with-agentforce) — confirma que leitura de imagem/recibo é um recurso real do Agentforce (não disponível neste org especificamente, ver item 10 de Resultados e Discussão).
