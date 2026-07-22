## Purpose

Contrato do **`CpfSeguroInfoCard`** — o bloco informativo destacado com borda:
ícone + título + `CpfSeguroStatusTag` opcional + descrição. Um destaque único,
não uma lista.

## Requirements

### Requirement: Bloco informativo, não lista
`CpfSeguroInfoCard` SHALL ser um bloco informativo destacado. Conteúdo repetível
em série SHALL usar `CpfSeguroAppList`.

#### Scenario: Aviso informativo numa página
- **WHEN** a página traz um bloco de informação com destaque
- **THEN** um InfoCard com título + descrição

### Requirement: Título obrigatório, StatusTag opcional
`CpfSeguroInfoCard` SHALL ter título; SHALL aceitar `CpfSeguroStatusTag` opcional
pra sinalizar estado do bloco.

#### Scenario: Bloco com estado
- **WHEN** o bloco precisa marcar um estado
- **THEN** inclui um StatusTag no card

### Requirement: Consome StatusTag, não recria
O selo de estado SHALL ser `CpfSeguroStatusTag`, não um chip próprio.

#### Scenario: Estado "Pendente" no card
- **WHEN** o card mostra pendência
- **THEN** usa `CpfSeguroStatusTag(tone: warning)`
