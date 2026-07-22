## Purpose

Contrato do **`CpfSeguroProgressRing`** — o progresso **circular** conhecido com
label central (nível do serviço "sou eu"). Consumido por `left.progressRing` na
AppListRow.

## Requirements

### Requirement: Progresso circular com valor
`CpfSeguroProgressRing` SHALL mostrar progresso mensurável em anel, com label
central do valor/percentual.

#### Scenario: Nível do serviço
- **WHEN** o serviço tem um nível de completude
- **THEN** o ring mostra o percentual no centro

### Requirement: Circular quando comunica melhor
`CpfSeguroProgressRing` SHALL ser escolhido quando o formato circular comunica
melhor que a barra. Progresso linear longo SHALL usar `CpfSeguroProgressBar`.

#### Scenario: Barra de upload longa
- **WHEN** o progresso é linear e extenso
- **THEN** é `CpfSeguroProgressBar`, não ring

### Requirement: Acompanha a linha
Como accessory de linha, `CpfSeguroProgressRing` SHALL entrar via
`left.progressRing` da `CpfSeguroAppListRow`, não montado à parte.

#### Scenario: Item de lista com progresso
- **WHEN** uma AppListRow mostra o progresso do item
- **THEN** usa `left.progressRing`
