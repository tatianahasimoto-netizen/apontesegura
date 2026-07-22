## Purpose

Contrato do **`CpfSeguroDropdown`** — a seleção de **lista fechada** (escolher, não
digitar). É um `CpfSeguroInput` readOnly + chevron cujo toque abre um bottomsheet
single-select (idioma mobile, HIG/Material). Palavra própria, não "Input com
truque".

## Requirements

### Requirement: Lista fechada, não texto livre
`CpfSeguroDropdown` SHALL ser usado quando o valor vem de um conjunto fixo de
`items`. Texto livre SHALL usar `CpfSeguroInput`.

#### Scenario: Tipo de chave Pix
- **WHEN** o usuário escolhe entre tipos fixos de chave
- **THEN** é `CpfSeguroDropdown(items: [...])`, não um Input

### Requirement: Gatilho readOnly + seleção em bottomsheet
O gatilho SHALL ter cara de campo (readOnly + chevron-down) e, ao tocar, abrir um
bottomsheet single-select (check no ativo). `sheetTitle` SHALL nomear a decisão.

#### Scenario: Abrir a seleção
- **WHEN** o usuário toca o gatilho
- **THEN** abre o bottomsheet com as opções; a atual vem marcada

### Requirement: Estados de campo iguais ao Input
`label`, `placeholder`, `error` e `disabled` SHALL seguir a mesma gramática de
campo do `CpfSeguroInput` (erro inline, borda no role error).

#### Scenario: Seleção obrigatória vazia
- **WHEN** o dropdown é obrigatório e está vazio ao validar
- **THEN** `error: 'Escolha um tipo'` com a borda error, igual ao Input
