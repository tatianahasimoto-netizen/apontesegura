## Purpose

Contrato do **`CpfSeguroBottomHomeIndicator`** — o slot do gesture bar do iOS no
rodapé das barras. Adaptativo: no device usa o inset REAL do SO; no catálogo (sem
inset) desenha o pill de fidelidade.

## Requirements

### Requirement: Adaptativo ao inset real
`CpfSeguroBottomHomeIndicator` SHALL usar o `viewPadding.bottom` real do device
(reservando o espaço, sem desenhar pill fake). Apenas sem inset (catálogo) SHALL
desenhar o pill de fidelidade.

#### Scenario: iPhone com notch
- **WHEN** roda num device com safe area inferior
- **THEN** reserva o inset e deixa o SO desenhar o gesture bar (não desenha pill fake)

### Requirement: Recolhe com teclado aberto
Com o teclado aberto (`viewInsets.bottom > 0`), `CpfSeguroBottomHomeIndicator`
SHALL recolher (não flutuar sobre o teclado).

#### Scenario: Teclado aberto no chat
- **WHEN** o teclado sobe
- **THEN** o indicator some (não fica flutuando)

### Requirement: Gerido pelo BottomApp
`CpfSeguroBottomHomeIndicator` SHALL ser usado pelas factories do
`CpfSeguroBottomApp`, não solto como espaçador genérico.

#### Scenario: Espaço no rodapé
- **WHEN** uma tela precisa do gesture slot
- **THEN** vem do BottomApp, não de um indicator solto
