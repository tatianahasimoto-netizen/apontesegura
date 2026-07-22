## Purpose

Contrato do **`CpfSeguroAvatar`** — a representação da **pessoa**: foto do perfil ou
iniciais quando não há foto.

## Requirements

### Requirement: Foto ou iniciais
`CpfSeguroAvatar` SHALL mostrar a foto do perfil quando existir; caso contrário, as
iniciais do nome (até 2 letras).

#### Scenario: Perfil sem foto
- **WHEN** o usuário não subiu foto
- **THEN** o avatar mostra as iniciais (2 letras)

### Requirement: Representa pessoa, não ícone
`CpfSeguroAvatar` SHALL representar uma pessoa/perfil. Ícone genérico em círculo
SHALL usar `CpfSeguroSpotIcon`.

#### Scenario: Ícone de categoria
- **WHEN** o círculo é um ícone de categoria
- **THEN** é `CpfSeguroSpotIcon`, não Avatar

### Requirement: Iniciais de até 2 letras
As iniciais SHALL ter no máximo 2 letras.

#### Scenario: Nome composto
- **WHEN** o nome tem vários sobrenomes
- **THEN** usa 2 iniciais (primeiro + último)
