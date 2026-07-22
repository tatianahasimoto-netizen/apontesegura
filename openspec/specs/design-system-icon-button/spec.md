## Purpose

Contrato do **`CpfSeguroIconButton`** — a ação **só-glyph** (fechar, voltar,
kebab, lixeira) para onde não cabe um label. Compartilha a família de `type` do
`CpfSeguroButton` (ver [`design-system-button`](../design-system-button/spec.md))
e o átomo de ícone `CpfSeguroIconAccessory`.

## Requirements

### Requirement: Ação só-glyph com rótulo acessível
`CpfSeguroIconButton` SHALL exigir `semanticLabel` (o nome da ação para leitor de
tela) e receber o glyph por `icon` (nome de token `CpfSeguroIcons`), nunca um
widget de ícone cru.

#### Scenario: Botão fechar
- **WHEN** um sheet precisa do botão de fechar
- **THEN** usa `CpfSeguroIconButton(icon: CpfSeguroIcons.xmarkLight, semanticLabel: 'Fechar', ...)`

#### Scenario: Sem rótulo
- **WHEN** um IconButton é criado sem `semanticLabel`
- **THEN** é erro de contrato — o leitor de tela não teria como anunciá-lo

### Requirement: type/size/state espelham o Button
`type` SHALL ser um de `primary`, `secondary`, `secondaryPrimary`, `tertiary`,
`tertiaryPrimary`. `size` SHALL ser `sm`/`md`/`lg`. `state` SHALL ser `normal`
ou `error` (error só para destrutivo). Sem cor/raio crus.

#### Scenario: Excluir item
- **WHEN** o glyph é uma lixeira que apaga
- **THEN** usa `state: CpfSeguroIconButtonState.error`

### Requirement: Usar quando não cabe label
`CpfSeguroIconButton` SHALL ser usado quando não há espaço para um label. Se há
espaço e a ação é a principal da tela, SHALL usar `CpfSeguroButton` com label.

#### Scenario: Ação principal com espaço
- **WHEN** a ação principal cabe com texto ("Pagar")
- **THEN** usa `CpfSeguroButton`, não um IconButton mudo
