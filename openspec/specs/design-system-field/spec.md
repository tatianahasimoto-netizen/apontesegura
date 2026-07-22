## Purpose

Contrato do **`CpfSeguroField`** — o **átomo-fundação** de entrada de texto:
o `TextField` da plataforma despido de Material (borda/fill/padding zerados),
vestido só de token. Resolve a robustez de texto (seleção, IME, autofill,
acessibilidade, hint nativo) UMA vez, e é consumido por `CpfSeguroInput`,
`CpfSeguroSearchInput` e `CpfSeguroChatInput`.

## Requirements

### Requirement: Núcleo de texto único do DS
Todo componente de entrada de texto do DS SHALL compor `CpfSeguroField` como
núcleo. NÃO SHALL existir `EditableText` cru ou overlay de texto ad-hoc em outro
componente/tela.

#### Scenario: Novo campo do DS
- **WHEN** um novo componente precisa de entrada de texto
- **THEN** ele compõe `CpfSeguroField`, não monta `EditableText`/`TextField` Material próprio

### Requirement: Despido de Material, vestido de token
`CpfSeguroField` SHALL zerar a decoração Material (border/fill/contentPadding) e
receber estilo apenas via tokens (tipografia/cor do scheme). A moldura visual
(borda, raio, fundo) é responsabilidade do componente que o embrulha.

#### Scenario: Moldura do Input
- **WHEN** o `CpfSeguroInput` desenha sua borda/estado de foco
- **THEN** a borda é do Input; o `CpfSeguroField` entra sem decoração própria

### Requirement: Robustez herdada da plataforma
`CpfSeguroField` SHALL preservar seleção, IME, autofill, acessibilidade e hint
nativos do engine de texto da plataforma — para o app poder delegar 100% do
input, inclusive em fluxos auth-críticos.

#### Scenario: Autofill de senha
- **WHEN** um campo de senha usa Field
- **THEN** o autofill/keychain da plataforma funciona sem código extra
