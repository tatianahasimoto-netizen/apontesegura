## Purpose

Contrato do **`CpfSeguroTooltip`** — a explicação **curta** ancorada num alvo (o
"?" ao lado de um label). Modo interativo (`child`) embrulha o gatilho no engine
de tooltip da plataforma, vestido com a estética do chip.

## Requirements

### Requirement: Complemento curto, não conteúdo essencial
`CpfSeguroTooltip` SHALL trazer texto curto e complementar. Informação essencial
NÃO SHALL viver só no tooltip (fica escondida).

#### Scenario: Explicar um termo
- **WHEN** um label precisa de uma nota curta
- **THEN** um "?" com tooltip explica; a info crítica está na tela

### Requirement: side não cobre o alvo
O `side` SHALL posicionar o tooltip sem cobrir o elemento de origem.

#### Scenario: Tooltip num item no topo
- **WHEN** o alvo está no topo da tela
- **THEN** o tooltip abre para baixo (não cortado, não cobrindo o alvo)

### Requirement: Modo interativo via child
Quando embrulha um gatilho real, `CpfSeguroTooltip` SHALL usar `child` (engine de
tooltip da plataforma), não um popover reimplementado na tela.

#### Scenario: Ícone de ajuda tocável
- **WHEN** um ícone de ajuda abre a explicação
- **THEN** usa `CpfSeguroTooltip(child: ...)`, não um overlay ad-hoc
