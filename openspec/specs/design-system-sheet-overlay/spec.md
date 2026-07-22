## Purpose

Contrato do **`CpfSeguroSheetOverlay`** — o primitivo de **overlay modal** (scrim +
slide) sobre o qual vivem os sheets do DS (ExitConfirm, PasswordBottomSheet,
BiometriaOverlay). Todos são a mesma gramática `CpfSeguroSurface.sheet` (ver
[`design-system-surface-grammar`](../design-system-surface-grammar/spec.md)).

## Requirements

### Requirement: Overlay = scrim + Surface.sheet
Um sheet/modal SHALL ser um `CpfSeguroSheetOverlay` (scrim + slide) contendo uma
`CpfSeguroSurface.sheet` (top grip+close / content / bottom). NÃO SHALL haver
scaffold de sheet reimplementado por tela.

#### Scenario: Confirmar saída
- **WHEN** um modal de confirmação abre
- **THEN** é um SheetOverlay com Surface.sheet (grip+close / texto / NavigationButton)

### Requirement: Scrim fecha quando não-bloqueante
Quando o sheet não é bloqueante, tocar no scrim SHALL fechá-lo. Sheets críticos
(bloqueantes) NÃO SHALL fechar por toque fora.

#### Scenario: Sheet informativo
- **WHEN** o sheet é dispensável
- **THEN** tocar fora fecha

### Requirement: Um Positioned.fill, sem duplo
O overlay SHALL ser posicionado uma vez (o próprio `CpfSeguroSheetOverlay` é
`Positioned.fill`-rooted); o consumidor NÃO SHALL envolvê-lo em outro
`Positioned.fill`.

#### Scenario: Montar o sheet num Stack
- **WHEN** o sheet entra num Stack
- **THEN** vai direto como filho (o overlay já se posiciona), sem Positioned extra
