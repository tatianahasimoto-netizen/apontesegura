## Purpose

Contrato do **`CpfSeguroSearchInput`** — o campo de **busca** (filtrar lista/
histórico). Recompõe `CpfSeguroField` + ícone de lupa. É busca, não campo de
formulário: sem label, com placeholder e filtro imediato.

## Requirements

### Requirement: Busca filtra ao digitar
`CpfSeguroSearchInput` SHALL expor `onChanged` e filtrar o resultado conforme o
texto muda (resultado imediato), não só ao submeter.

#### Scenario: Filtrar atividades
- **WHEN** o usuário digita na busca da lista de Atividade
- **THEN** a lista filtra a cada tecla via `onChanged`

### Requirement: Sem label, com placeholder
`CpfSeguroSearchInput` NÃO SHALL ter label. SHALL usar `placeholder` que diz o que
se busca e o ícone de lupa como affordance.

#### Scenario: Placeholder de busca
- **WHEN** a busca é exibida
- **THEN** mostra "Buscar atividade" como placeholder, sem label acima

### Requirement: Núcleo é o átomo Field
O núcleo de texto SHALL ser `CpfSeguroField` (mesma robustez de seleção/IME/a11y).

#### Scenario: Foco e seleção
- **WHEN** o usuário foca a busca
- **THEN** seleção/IME nativos vêm do Field, não de EditableText cru

### Requirement: Busca, não formulário
`CpfSeguroSearchInput` SHALL ser usado para filtrar. Entrada de dados de
formulário SHALL usar `CpfSeguroInput`.

#### Scenario: Campo de nome num cadastro
- **WHEN** o formulário coleta o nome
- **THEN** é `CpfSeguroInput` (com label), não SearchInput
