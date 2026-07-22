## Purpose

Contrato do **`CpfSeguroSdkScreen`** — o layout de **tela cheia** de resultado/
entrada (Welcome, ErrorFatal): cobrand no topo + hero central + CTA. Full-bleed,
não a `CpfSeguroSurface` padrão de 3 slots.

## Requirements

### Requirement: Tela de foco único
`CpfSeguroSdkScreen` SHALL ser usado para telas de um foco só (boas-vindas, erro
fatal, resultado). NÃO SHALL virar a tela comum do app (essa é
`CpfSeguroSurface`).

#### Scenario: Tela de boas-vindas
- **WHEN** o fluxo abre com uma tela de entrada
- **THEN** é `CpfSeguroSdkScreen` (cobrand + hero + CTA)

### Requirement: Cobrand + hero + CTA
A composição SHALL ser cobrand no topo, hero (ilustração/título) central e CTA
embaixo.

#### Scenario: ErrorFatal
- **WHEN** ocorre um erro fatal
- **THEN** cobrand + hero de erro + CTA de recuperação

### Requirement: Não encher de conteúdo
`CpfSeguroSdkScreen` SHALL manter um único foco; conteúdo denso/rolável SHALL usar
`CpfSeguroSurface`.

#### Scenario: Tela com lista longa
- **WHEN** a tela precisa de conteúdo rolável denso
- **THEN** é `CpfSeguroSurface`, não SdkScreen
