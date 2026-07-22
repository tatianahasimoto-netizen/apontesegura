## Purpose

Contrato do **`CpfSeguroInfoChip`** — o pill **decorativo/informativo** (badge
"Novo", rótulo curto) sobre uma superfície. Sem semântica de estado (StatusTag)
nem interação de filtro (InputChip).

## Requirements

### Requirement: Decorativo, não estado nem filtro
`CpfSeguroInfoChip` SHALL ser um rótulo informativo estático. NÃO SHALL carregar
`tone` semântico de estado nem ação de remover.

#### Scenario: Badge "Novo"
- **WHEN** um item é novidade
- **THEN** um InfoChip "Novo" sobre o card

### Requirement: Variante por superfície
`CpfSeguroInfoChip` SHALL ter variante `light` (superfície clara) e `onColor`
(sobre cor). Texto curto.

#### Scenario: Chip sobre banner colorido
- **WHEN** o chip fica sobre uma superfície de cor
- **THEN** usa a variante `onColor`

### Requirement: Distinto de StatusTag e InputChip
Estado semântico SHALL usar `CpfSeguroStatusTag`; filtro removível,
`CpfSeguroInputChip`.

#### Scenario: Estado "Pendente"
- **WHEN** a intenção é comunicar estado
- **THEN** é `CpfSeguroStatusTag`, não InfoChip
