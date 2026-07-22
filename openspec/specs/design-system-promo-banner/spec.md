## Purpose

Contrato do **`CpfSeguroPromoBanner`** — o card de **chamada com CTA** (oferta,
novidade). Marketing/ativação, não estado da conta. Variantes `light` e `solid`.

## Requirements

### Requirement: Chamada com um CTA
`CpfSeguroPromoBanner` SHALL ter uma mensagem de chamada e UM CTA claro. NÃO SHALL
empilhar vários CTAs.

#### Scenario: Conheça um recurso
- **WHEN** a home promove um recurso novo
- **THEN** um PromoBanner com um CTA "Conhecer"

### Requirement: Variante e ilustração por token
`variant` SHALL ser `light` ou `solid`. A ilustração SHALL vir por token
(`illustration: enum`), não por String-path cru.

#### Scenario: Banner de destaque
- **WHEN** o banner precisa de mais peso visual
- **THEN** usa `variant: solid` + ilustração por token

### Requirement: Não é estado da conta
Estado de proteção/conta SHALL usar `CpfSeguroStatusBanner`.

#### Scenario: CPF pausado
- **WHEN** a mensagem é o estado do CPF
- **THEN** é StatusBanner, não PromoBanner
