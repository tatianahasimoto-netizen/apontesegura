## Purpose

Contrato do **`CpfSeguroInput`** — o campo de **texto livre** de formulário (nome,
CPF, e-mail). Recompõe o átomo-fundação `CpfSeguroField` (TextField da plataforma
despido de Material) e adiciona label, helper e erro inline. Ver
[`design-system-field`](../design-system-field/spec.md) para a robustez do núcleo.

## Requirements

### Requirement: Núcleo de texto é o átomo Field
`CpfSeguroInput` SHALL compor `CpfSeguroField` como núcleo de texto. NÃO SHALL
reimplementar `EditableText`/overlay ad-hoc — seleção, IME, autofill e a11y vêm
do Field.

#### Scenario: Campo de nome
- **WHEN** o formulário pede o nome completo
- **THEN** o `CpfSeguroInput` renderiza sobre `CpfSeguroField`, herdando seleção/IME nativos

### Requirement: Label persistente, não placeholder-como-label
`CpfSeguroInput` SHALL ter `label`. O `placeholder` NÃO SHALL ser usado como
substituto do label (ele some ao digitar).

#### Scenario: Campo com dica
- **WHEN** o campo é "E-mail"
- **THEN** `label: 'E-mail'` fixo + `placeholder: 'você@exemplo.com'`, não só o placeholder

### Requirement: Erro e helper inline
Erro SHALL vir por `error` (mensagem curta e acionável, borda no role `error`).
Instrução persistente SHALL vir por `helper`. Não SHALL haver texto de erro solto
fora do contrato.

#### Scenario: CPF inválido
- **WHEN** o CPF digitado é inválido
- **THEN** `error: 'CPF inválido'` renderiza a borda error + a mensagem sob o campo

### Requirement: Teclado e máscara por tipo de dado
`keyboardType` e `inputFormatters` SHALL casar com o dado (CPF, telefone). O
`type` (`CpfSeguroInputType`) define o comportamento; `disabled` rebaixa sem
trocar o role.

#### Scenario: Campo de CPF
- **WHEN** o campo aceita CPF
- **THEN** `keyboardType` numérico + `inputFormatters` da máscara de CPF

### Requirement: Input é texto livre, não lista fechada
`CpfSeguroInput` SHALL ser texto livre. Escolha de lista fechada SHALL usar
`CpfSeguroDropdown`; data SHALL usar `CpfSeguroDateField` (ambos = Input readOnly
+ trigger, palavras próprias).

#### Scenario: Escolher um tipo de chave
- **WHEN** o usuário escolhe entre opções fixas
- **THEN** é `CpfSeguroDropdown`, não um Input com truque
