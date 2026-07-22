## Purpose

Contrato do **`CpfSeguroSpotIcon`** — o ícone em **círculo colorido** de destaque
(accessory de linha, marcador semântico). fill/outline × 8 states de cor. Compõe
`CpfSeguroIconAccessory`.

## Requirements

### Requirement: state semântico
O `state` (8 cores) SHALL casar com o tom semântico do contexto. Cor crua NÃO é
permitida.

#### Scenario: Item de sucesso
- **WHEN** a linha representa algo concluído
- **THEN** o SpotIcon usa o state de sucesso

### Requirement: fill vs outline por ênfase
`fill` SHALL ser a versão de ênfase; `outline`, a leve.

#### Scenario: Marcador discreto
- **WHEN** o destaque deve ser leve
- **THEN** usa `outline`

### Requirement: Identidade, não ação
`CpfSeguroSpotIcon` SHALL ser decorativo/identidade (ex.: left accessory da
AppListRow). Ação tocável SHALL usar `CpfSeguroIconButton`.

#### Scenario: Ícone que dispara ação
- **WHEN** tocar deve executar algo
- **THEN** é `CpfSeguroIconButton`, não SpotIcon
