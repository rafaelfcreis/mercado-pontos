# Relato de Extensão — Mercado Pontos (IA para Devs)

> **Status: RASCUNHO.** Trechos marcados com `[AJUSTAR: ...]` precisam ser
> completados com respostas reais da comunidade informal (família, amigos,
> colegas) antes da entrega final. O roteiro exige conversas genuínas com
> evidências (prints/mensagens) — nada aqui substitui isso.

> **Nota sobre origem do conteúdo (transparência metodológica):** este
> rascunho foi redigido com apoio do Claude Code (IA). Cada tipo de conteúdo
> está marcado quanto à origem:
> - **Estatísticas com citação numerada/link** (ex: "88,3% dos brasileiros...")
>   vêm de pesquisa real publicada por terceiros (Abemf/imprensa
>   especializada) — fonte completa na seção **Fontes**, ao final.
> - **Texto corrido sem citação** (enquadramento da situação-problema,
>   objetivos, motivação acadêmica) foi **redigido pela IA** a partir dos
>   dados reais acima e das decisões técnicas tomadas em conversa com o
>   autor — precisa de revisão e ajuste de voz por ele antes da entrega.
> - **`[AJUSTAR: ...]`** marca lacunas que só podem ser preenchidas com dados
>   primários reais (respostas de pessoas de verdade) — a IA não gerou nem
>   deve gerar conteúdo para essas lacunas.

## I - Diagnóstico e Teorização

### 1. Identificação das partes envolvidas e parceiros

O público envolvido nesta atividade de extensão é uma **comunidade informal**,
composta por familiares, amigos e colegas de trabalho/estudo do autor,
consultados diretamente por mensagem de texto sobre seus hábitos de compra em
supermercado. Não há uma instituição parceira formal envolvida.

Perfil estimado do grupo consultado:
- **Quantidade estimada de participantes:** `[AJUSTAR: quantas pessoas você
  consultou — ex: 6 a 10 pessoas]`
- **Faixa etária:** `[AJUSTAR]`
- **Escolaridade:** `[AJUSTAR]`
- **Perfil socioeconômico:** `[AJUSTAR]`
- **Localização:** `[AJUSTAR]`

### 2. Situação-problema identificada

Nas conversas realizadas com as partes envolvidas, buscou-se entender: (a) o
que a pessoa faz com a nota fiscal depois de pagar a compra; (b) sua
experiência com programas de pontos/fidelidade de supermercado; (c) se ela
usaria uma ferramenta simples de pontos baseada na nota fiscal; (d) seu nível
de familiaridade com IA aplicada a tarefas do dia a dia.

`[AJUSTAR: substituir o parágrafo abaixo pelas respostas reais das
conversas]`

Respostas reais obtidas na comunidade consultada:
- `[AJUSTAR: resumo/citações das respostas sobre o que fazem com a nota fiscal]`
- `[AJUSTAR: resumo/citações das respostas sobre experiência com fidelidade]`
- `[AJUSTAR: resumo/citações sobre interesse na ferramenta proposta]`
- `[AJUSTAR: resumo/citações sobre familiaridade com IA]`

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
estabelecidos. `[AJUSTAR: se algum contato relatou uma frustração pessoal
específica com programas de fidelidade ou nota fiscal, citar aqui]`

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

**Objetivo 2:** Reduzir o desconhecimento do grupo consultado sobre
aplicações práticas de IA generativa em tarefas do cotidiano, medido pela
quantidade de pessoas do grupo que testarem a ferramenta e responderem a um
questionário rápido de satisfação/aprendizado até o encerramento da
atividade.

---

## II - Planejamento para Desenvolvimento do Projeto

> Nota sobre origem: o cronograma abaixo usa as datas reais dos commits do
> repositório git do projeto como evidência objetiva de quando cada etapa
> foi executada (não são datas estimadas). O texto de cada ação foi
> redigido pela IA a partir desse histórico real, em conversa com o autor.

### 1. Plano de trabalho com cronograma das atividades

**Objetivo 1:** Desenvolver e publicar um site funcional (Experience Cloud)
onde o cliente envia o texto da nota fiscal e recebe pontos calculados
automaticamente, até `[AJUSTAR: data de entrega]`. Prazo: `[AJUSTAR]`

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
fiscal e resgate de pontos, com testes automatizados (cobertura acima de
95%), e dos componentes de interface (`enviarNotaFiscal`, `extratoPontos`,
`catalogoResgate`).

**Ação 3 — Diagnóstico com a comunidade informal** (a partir de
`[AJUSTAR: data em que a mensagem foi enviada]`)
Como fazer: envio de mensagem de texto (WhatsApp) para família/amigos com
perguntas sobre hábitos de compra, uso de programas de fidelidade e
familiaridade com IA (ver texto completo na Parte I). Para quem: círculo
social informal do autor. Onde: conversas remotas por mensagem.
`[AJUSTAR: confirmar quando as respostas foram recebidas]`

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

**Outras ações pendentes:** `[AJUSTAR: pesquisa de satisfação com a
comunidade, gravação de vídeo demo, etc.]`

### 2. Envolvimento do público participante

O público (comunidade informal) participa em dois momentos: (1) na etapa
de diagnóstico, respondendo às perguntas sobre hábitos de compra e
fidelidade que embasaram a situação-problema da Parte I; (2)
`[AJUSTAR: se o grupo também testou o site publicado depois de pronto,
descrever aqui — ex: pediu para 2-3 pessoas do grupo se cadastrarem e
testarem o envio de uma nota fiscal real]`.

Registros de evidência: `[AJUSTAR: prints das conversas de diagnóstico;
se houver, prints do feedback de quem testou o site]`.

### 3. Avaliação dos resultados alcançados

**Objetivo 1** (site funcional publicado): avaliado objetivamente — o site
está publicado e ao vivo, testado com um fluxo real de ponta a ponta
(cadastro → envio de nota → crédito de pontos → resgate com endereço de
entrega), com o código versionado publicamente em git.

**Objetivo 2** (redução do desconhecimento sobre IA): `[AJUSTAR: aplicar o
questionário de satisfação/aprendizado combinado com o grupo e resumir os
resultados aqui]`.

## III - Encerramento do Projeto

### 1. Relato da experiência individual no desenvolvimento da atividade

**1. Contextualização** `[AJUSTAR: escrever em primeira pessoa — como foi
a experiência, como os conteúdos da disciplina de IA para Devs se
conectaram com a prática de construir uma solução real de IA generativa
aplicada a um problema do dia a dia]`

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
   `NetworkSelfRegistration` diretamente pela API de dados.
8. **CSP bloqueando imagens externas**: imagens do catálogo de produtos
   não carregavam porque o domínio usado não estava na lista de CSP
   Trusted Sites do site — resolvido adicionando o domínio via metadata.
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

Essas descobertas mostram na prática algo central pra disciplina: **usar
IA generativa em produção não é só "chamar uma API"** — envolve lidar com
imaturidade de plataforma, debugar com evidência real (queries, logs de
deploy, pesquisa de issues públicas) em vez de tentativa e erro cego, e
tomar decisões de arquitetura (como o pivot Prompt Builder → Agentforce)
quando a solução ideal esbarra em uma limitação real.

`[AJUSTAR: complementar com impressões pessoais, o que foi mais
desafiador, o que aprendeu.]`

Resultados conforme a Seção 3 da Parte II: `[AJUSTAR conforme preenchido
acima]`.

### 2. Evidências das atividades realizadas

`[AJUSTAR: redigir a contextualização de cada evidência antes de anexar]`

- Link do repositório git (histórico completo de commits):
  `[AJUSTAR: link do repositório, se publicado remotamente, ou indicar que
  é local]`
- `docs/historico-conversa-claude-code.md` — histórico completo da
  conversa de desenvolvimento com a IA (reexecutar
  `scripts/gerar-historico-claude.ps1` antes de anexar, para pegar a
  versão mais atualizada).
- Site publicado: https://orgfarm-375b864f55-dev-ed.develop.my.site.com/mercadopontos
- `[AJUSTAR: prints do Object Manager (modelo de dados), das classes Apex
  e cobertura de testes, dos componentes LWC, do Agent Builder
  (Agentforce), do site publicado (Home, envio de nota, catálogo,
  checkout de resgate), e das conversas de diagnóstico com a comunidade]`
- `[AJUSTAR: mensagens/e-mails trocados com a comunidade informal]`

---

## Próximos passos deste documento

1. Enviar a mensagem de diagnóstico (já combinada) para 6-10 pessoas reais e
   substituir todos os `[AJUSTAR: ...]` da Parte I pelas respostas genuínas.
2. Guardar prints das conversas — viram evidência na Parte III.
3. ~~Preencher a Parte II depois que o site estiver publicado~~ — Parte II
   preenchida (site já publicado e testado); falta só os `[AJUSTAR]` que
   dependem das respostas reais da comunidade.
4. ~~Preencher a Parte III~~ — rascunho já feito, com a lista completa dos
   bugs reais de plataforma encontrados e contornados; falta só as
   impressões pessoais em primeira pessoa e anexar as evidências (prints,
   link do git).

## Fontes

Buscadas pela IA (Claude Code) via pesquisa na web em 2026-09-12, para
embasar a seção "Situação-problema" com dados reais de mercado:

1. [88% dos brasileiros utilizam programas de fidelidade, diz pesquisa da Abemf](https://www.panrotas.com.br/mercado/pesquisas-e-estatisticas/2025/10/88-dos-brasileiros-utilizam-programas-de-fidelidade-diz-pesquisa-da-abemf_222537.html) — Panrotas
2. [Sete em cada dez brasileiros já aderiram a programas de fidelidade em supermercados](https://www.superhiper.com.br/sete-em-cada-dez-brasileiros-ja-aderiram-a-programas-de-fidelidade-em-supermercados/) — SuperHiper
3. [88% dos brasileiros utilizam programas de fidelidade, segundo pesquisa](https://www.apras.org.br/noticias/88-dos-brasileiros-utilizam-programas-de-fidelidade-segundo-pesquisa/) — APRAS

Buscadas em 2026-09-16, para embasar duas decisões de design reais do projeto:

4. [Dúvidas Frequentes — Pão de Açúcar (retirada de prêmio físico em loja, não entrega)](https://www.paodeacucar.com/duvidas-frequentes/7/7.22/como-funciona-o-pagstix) — motivou a mudança do resgate de "entrega por Correios" para "retirada em loja com QR code" (item de Resultados e Discussão).
5. [Turn Images & PDFs Into AI-Powered Insights With Agentforce — Salesforce Admins](https://admin.salesforce.com/blog/2025/turn-images-pdfs-into-ai-powered-insights-with-agentforce) — confirma que leitura de imagem/recibo é um recurso real do Agentforce (não disponível neste org especificamente, ver item 10 de Resultados e Discussão).
