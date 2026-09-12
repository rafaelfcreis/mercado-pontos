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
*(a ser preenchido — cronograma real, envolvimento do público, indicadores)*

## III - Encerramento do Projeto
*(a ser preenchido ao final, após a coleta de evidências)*

---

## Próximos passos deste documento

1. Enviar a mensagem de diagnóstico (já combinada) para 6-10 pessoas reais e
   substituir todos os `[AJUSTAR: ...]` da Parte I pelas respostas genuínas.
2. Guardar prints das conversas — viram evidência na Parte III.
3. Preencher a Parte II depois que o site estiver publicado.
4. Preencher a Parte III (relato individual + evidências) por último, com
   prints do Object Manager, Apex, LWC, Prompt Builder, Agentforce, site
   publicado, e o link deste repositório git.

## Fontes

Buscadas pela IA (Claude Code) via pesquisa na web em 2026-09-12, para
embasar a seção "Situação-problema" com dados reais de mercado:

1. [88% dos brasileiros utilizam programas de fidelidade, diz pesquisa da Abemf](https://www.panrotas.com.br/mercado/pesquisas-e-estatisticas/2025/10/88-dos-brasileiros-utilizam-programas-de-fidelidade-diz-pesquisa-da-abemf_222537.html) — Panrotas
2. [Sete em cada dez brasileiros já aderiram a programas de fidelidade em supermercados](https://www.superhiper.com.br/sete-em-cada-dez-brasileiros-ja-aderiram-a-programas-de-fidelidade-em-supermercados/) — SuperHiper
3. [88% dos brasileiros utilizam programas de fidelidade, segundo pesquisa](https://www.apras.org.br/noticias/88-dos-brasileiros-utilizam-programas-de-fidelidade-segundo-pesquisa/) — APRAS
