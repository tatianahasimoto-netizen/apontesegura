## Purpose

Contrato do **`CpfSeguroQuickAccessCard`** — o mini-card de atalho (75×84: ícone +
label curto) da grade "ACESSO RÁPIDO". 2 states: `active` / `inactive`.

## Requirements

### Requirement: Dois estados
`CpfSeguroQuickAccessCard` SHALL ter exatamente 2 states: `active` (disponível) e
`inactive` (com lock badge). NÃO SHALL inventar estados extras.

#### Scenario: Atalho indisponível
- **WHEN** o recurso ainda não está liberado
- **THEN** o card fica `inactive` com o lock badge

### Requirement: Label curto, nowrap
O `label` SHALL ser curto e nowrap (quebra só com `\n`), para caber no 75×84.

#### Scenario: Label de duas palavras
- **WHEN** o label tem duas palavras
- **THEN** quebra só se vier com `\n`, senão fica em uma linha

### Requirement: Atalho, não CTA
`CpfSeguroQuickAccessCard` SHALL ser um atalho de navegação. A ação principal da
tela SHALL usar `CpfSeguroButton`.

#### Scenario: Ação principal
- **WHEN** a tela tem um CTA forte
- **THEN** é `CpfSeguroButton`, não um QuickAccessCard
