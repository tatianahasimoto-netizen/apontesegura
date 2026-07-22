## Purpose

Contrato do **`CpfSeguroDateField`** — a escolha de **data**: um `CpfSeguroInput`
readOnly + ícone de calendário que abre o `CpfSeguroCalendar` num bottomsheet.
Formata a data; o usuário não digita dd/mm/aaaa à mão.

## Requirements

### Requirement: Escolher data, não digitar
`CpfSeguroDateField` SHALL abrir o `CpfSeguroCalendar` para o usuário escolher a
data. NÃO SHALL exigir digitação manual de dd/mm/aaaa.

#### Scenario: Data de nascimento
- **WHEN** o formulário pede a data de nascimento
- **THEN** o toque abre o Calendar; o valor volta formatado

### Requirement: Gatilho readOnly + ícone calendário
O gatilho SHALL ter cara de campo (readOnly) com ícone de calendário. A seleção
acontece no bottomsheet do Calendar; `sheetTitle` nomeia a decisão.

#### Scenario: Abrir o calendário
- **WHEN** o usuário toca o campo de data
- **THEN** abre o Calendar em bottomsheet

### Requirement: Formatação e estados de campo
`format` SHALL definir a exibição (default dd/MM/aaaa). `label`, `placeholder`,
`error`, `disabled` SHALL seguir a gramática de campo do `CpfSeguroInput`.

#### Scenario: Data obrigatória vazia
- **WHEN** o campo é obrigatório e está vazio ao validar
- **THEN** `error: 'Data obrigatória'` com borda error
