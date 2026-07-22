## Purpose

Contrato do **`CpfSeguroRadioList`** — a escolha **única** entre opções pequenas e
visíveis (motivo de exclusão, tipo de conta). Distinto de Checkbox (múltipla) e
Dropdown (lista fechada extensa em sheet).

## Requirements

### Requirement: Exatamente uma opção
`CpfSeguroRadioList` SHALL permitir selecionar exatamente uma `CpfSeguroRadioOption`
por vez (`value` único). NÃO SHALL permitir múltipla seleção.

#### Scenario: Motivo de exclusão
- **WHEN** o usuário escolhe por que está saindo
- **THEN** só um motivo fica selecionado por vez

### Requirement: Título e opções visíveis
`CpfSeguroRadioList` SHALL aceitar `title` (a decisão) e SHALL exibir todas as
`options` de uma vez (é lista aberta, não bottomsheet).

#### Scenario: Escolha entre poucas opções
- **WHEN** há 3-5 opções mutuamente exclusivas
- **THEN** todas aparecem na lista com o título acima

### Requirement: Muitas opções migram pra Dropdown
Quando o conjunto é grande (não cabe visível), SHALL usar `CpfSeguroDropdown`
(seleção em bottomsheet), não uma RadioList longa.

#### Scenario: Lista de bancos
- **WHEN** as opções são dezenas
- **THEN** é `CpfSeguroDropdown`, não RadioList
