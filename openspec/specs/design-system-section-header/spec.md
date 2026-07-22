## Purpose

Contrato do **`CpfSeguroSectionHeader`** — o cabeçalho (label em caps) acima de uma
lista/seção, com ação trailing opcional ("Ver tudo").

## Requirements

### Requirement: Eyebrow de seção
`CpfSeguroSectionHeader` SHALL rotular uma seção/lista com um label curto em caps.

#### Scenario: Lista "Contatos"
- **WHEN** uma seção de contatos começa
- **THEN** um SectionHeader "CONTATOS" acima

### Requirement: trailing = SeeAllLink
Quando há "ver tudo", o trailing SHALL usar `CpfSeguroSeeAllLink`, não um botão
próprio.

#### Scenario: Ver todos os contatos
- **WHEN** a seção tem mais itens
- **THEN** trailing `CpfSeguroSeeAllLink`

### Requirement: Não é título de tela
`CpfSeguroSectionHeader` SHALL ser cabeçalho de seção. Título da tela SHALL usar
`CpfSeguroPageTitle`. NÃO SHALL ser usado em empty-state/appbar/interior de card.

#### Scenario: Título principal da tela
- **WHEN** é o h1 da tela
- **THEN** é PageTitle, não SectionHeader
