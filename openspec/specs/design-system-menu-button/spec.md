## Purpose

Contrato do **`CpfSeguroMenuButton`** — o item de **menu/atalho** do DS. Um único
word com três `variant`s (rail vertical, menu horizontal, card de atalho tile),
não três componentes. Consome ícone (`CpfSeguroIconAccessory`) + roles.

## Requirements

### Requirement: variant escolhida pelo contexto
`CpfSeguroMenuButton` SHALL expor `variant`: `vertical` (ícone acima do label,
rail), `horizontal` (ícone à esquerda, menu contextual) e `tile` (card sólido
97×97, fill primary, one-shot da home). A variant SHALL refletir o contexto de
navegação, não a estética.

#### Scenario: Atalho da home pix
- **WHEN** a home mostra um atalho de ação one-shot
- **THEN** usa `CpfSeguroMenuButton(variant: tile, ...)`

### Requirement: active só no item atual
`active: true` SHALL marcar apenas o item de menu selecionado no momento. A
variant `tile` NÃO SHALL usar `active` (é ação one-shot, sem estado de seleção).

#### Scenario: Rail de navegação
- **WHEN** o rail mostra a seção atual
- **THEN** só o item da seção atual tem `active: true`

### Requirement: MenuButton é menu, não CTA
`CpfSeguroMenuButton` SHALL representar navegação/atalho. A ação principal de uma
tela SHALL usar `CpfSeguroButton`.

#### Scenario: Confirmar ação
- **WHEN** a tela precisa de "Confirmar"
- **THEN** é `CpfSeguroButton`, não um MenuButton
