## Purpose

Contrato do **`CpfSeguroSeeAllLink`** — o text-link "Ver tudo" que fica no trailing
de um `CpfSeguroSectionHeader` (leva à lista completa da seção).

## Requirements

### Requirement: Text-link, não botão-ícone
`CpfSeguroSeeAllLink` SHALL ser um link de texto (ex.: "Ver tudo"). NÃO SHALL ser
um botão-ícone circular ad hoc.

#### Scenario: Ver todos os contatos
- **WHEN** a seção de contatos tem mais itens
- **THEN** o trailing é um SeeAllLink de texto, não um IconButton redondo

### Requirement: Vive no trailing do SectionHeader
`CpfSeguroSeeAllLink` SHALL ser usado como o `trailing` de um
`CpfSeguroSectionHeader`.

#### Scenario: Cabeçalho de lista
- **WHEN** uma seção precisa de "ver tudo"
- **THEN** o SeeAllLink entra no trailing do SectionHeader

### Requirement: Navega para a lista completa
O toque SHALL levar à lista completa da seção, não executar uma ação destrutiva.

#### Scenario: Tocar "Ver tudo"
- **WHEN** o usuário toca o link
- **THEN** navega para a lista completa
