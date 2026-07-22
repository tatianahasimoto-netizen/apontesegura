## Purpose

Contrato do **`CpfSeguroIconAccessory`** — o átomo que padroniza qualquer ícone:
box consistente + padding + slot de badge. Consome o token `CpfSeguroIcons` (asset
= token). Todo componente roteia o ícone por aqui.

## Requirements

### Requirement: Todo ícone passa pelo átomo
Ícones SHALL ser renderizados via `CpfSeguroIconAccessory` (que resolve o token
`CpfSeguroIcons`). NÃO SHALL haver glyph/`Icon` cru em tela ou componente.

#### Scenario: Ícone numa linha
- **WHEN** uma AppListRow mostra um ícone
- **THEN** vem por IconAccessory, não um `Icon(...)` cru

### Requirement: Badge no slot
Quando há badge (contador/dot), SHALL usar o slot de badge do átomo, não uma
sobreposição manual.

#### Scenario: Sino com badge
- **WHEN** o sino tem notificações
- **THEN** o badge entra no slot do IconAccessory

### Requirement: Box consistente
O box/padding SHALL seguir o padrão do átomo, garantindo alinhamento entre ícones
de tamanhos diferentes.

#### Scenario: Ícones lado a lado
- **WHEN** vários ícones aparecem numa linha
- **THEN** o box padrão os alinha
