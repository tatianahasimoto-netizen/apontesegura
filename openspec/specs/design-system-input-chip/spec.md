## Purpose

Contrato do **`CpfSeguroInputChip`** — o chip de **filtro/contexto** ativo e
removível (período "15 dias", contexto "Meu CPF"). Distinto de InfoChip
(decorativo) e StatusTag (semântico de estado).

## Requirements

### Requirement: Filtro/contexto, não ação
`CpfSeguroInputChip` SHALL representar um filtro ou contexto selecionável. NÃO
SHALL ser usado como CTA (isso é `CpfSeguroButton`).

#### Scenario: Filtro de período
- **WHEN** a lista está filtrada por "15 dias"
- **THEN** um InputChip mostra o filtro ativo

### Requirement: filled = selecionado; trailIcon remove
`filled: true` SHALL indicar o chip ativo/selecionado. `trailIcon` (x) SHALL
remover o filtro; `leadIcon` SHALL trazer o ícone de contexto.

#### Scenario: Remover filtro
- **WHEN** o usuário toca o x do chip
- **THEN** o filtro é removido (o `trailIcon` é o affordance de remover)

### Requirement: Distinto de InfoChip e StatusTag
`CpfSeguroInputChip` (interativo, filtro) NÃO SHALL ser confundido com
`CpfSeguroInfoChip` (decorativo) nem `CpfSeguroStatusTag` (estado semântico).

#### Scenario: Selo "Pago"
- **WHEN** a intenção é mostrar um estado semântico
- **THEN** é `CpfSeguroStatusTag`, não InputChip
