## Purpose

Contrato do **`CpfSeguroProgressBar`** — o progresso **linear conhecido** (2fa por
instituição, upload) ou atividade contínua. Variantes `.activity` (azul) e
`.banner` (secure sobre gradient).

## Requirements

### Requirement: Progresso mensurável
`CpfSeguroProgressBar` SHALL representar progresso com medida. Espera
indeterminada SHALL usar `CpfSeguroLoadingSpinner`.

#### Scenario: Verificação por instituição
- **WHEN** 2 de 3 instituições foram verificadas
- **THEN** a ProgressBar mostra o avanço, com caption do passo

### Requirement: Variante por contexto
`.activity` SHALL ser o progresso de tarefa padrão; `.banner` (secure) SHALL ser
usado sobre gradient. Caption comunica o passo (incl. falhas).

#### Scenario: Barra sobre banner de proteção
- **WHEN** a barra fica sobre o gradient de proteção
- **THEN** usa a variante `.banner`

### Requirement: Não é o stepper segmentado
O stepper segmentado tri-state do onboarding DIVERGE (lógica de nível própria) e
SHALL permanecer bespoke; `CpfSeguroProgressBar` NÃO SHALL ser forçado nesse caso.

#### Scenario: Stepper de nível do onboarding
- **WHEN** o onboarding mostra N segmentos animados de nível
- **THEN** é o widget bespoke, não ProgressBar
