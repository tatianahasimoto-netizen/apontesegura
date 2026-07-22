## Purpose

Contrato do **`CpfSeguroAppListDayGroup`** — o agrupamento de linhas de lista por
**dia** (extrato, atividade): header de data + `CpfSeguroAppListRow`s com divider
entre itens.

## Requirements

### Requirement: Agrupa por data
`CpfSeguroAppListDayGroup` SHALL agrupar linhas por dia, com um header de data no
topo do grupo.

#### Scenario: Extrato por dia
- **WHEN** o extrato lista transações
- **THEN** cada dia vira um DayGroup com sua data

### Requirement: Reusa AppListRow
As linhas dentro do grupo SHALL ser `CpfSeguroAppListRow`, não linhas próprias.

#### Scenario: Item do dia
- **WHEN** um item aparece sob uma data
- **THEN** é uma AppListRow dentro do DayGroup

### Requirement: Agrupamento temporal
`CpfSeguroAppListDayGroup` SHALL ser usado para agrupamento por data. Agrupamento
não-temporal SHALL usar as seções do `CpfSeguroAppList`.

#### Scenario: Agrupar por categoria
- **WHEN** o agrupamento é por categoria, não data
- **THEN** usa seções do AppList, não DayGroup
