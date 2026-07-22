## Purpose

Contrato do **`CpfSeguroAppListRow`** + **`CpfSeguroAppList`** — a lista padrão do
app. A row é uma linha PURA (left/middle/right); a coleção (`.carded`/`.plain`/
`.menu`) é a dona única do separador.

## Requirements

### Requirement: Row é pura, coleção decide o separador
`CpfSeguroAppListRow` SHALL ser uma linha sem separador nem posição própria. O
separador entre linhas SHALL ser responsabilidade de `CpfSeguroAppList`.

#### Scenario: Lista com divisórias
- **WHEN** uma lista precisa de divisórias entre itens
- **THEN** o separador vem do `CpfSeguroAppList`, não de cada row

### Requirement: Slots left/middle/right
A linha SHALL compor accessories por slot: `left` (avatar/spotIcon/progressRing),
`middle` (título/subtítulo), `right` (amount/action/toggle/checkbox).

#### Scenario: Linha de pagamento
- **WHEN** a linha mostra um pagamento
- **THEN** `left` = ícone, `middle` = descrição, `right` = `Amount`

### Requirement: Variante da coleção por contexto
`CpfSeguroAppList` SHALL expor `.carded` (card), `.plain` (flat) e `.menu`
(configurações). Não SHALL haver um "AppListGroup" paralelo.

#### Scenario: Menu de configurações
- **WHEN** é uma lista de settings
- **THEN** usa `CpfSeguroAppList.menu`

### Requirement: Não montar lista na mão
Listas SHALL usar AppListRow/AppList; NÃO SHALL empilhar `Row` + `Divider` ad hoc
por tela.

#### Scenario: Nova lista de contatos
- **WHEN** uma tela lista contatos
- **THEN** usa AppListRow dentro de AppList, não Rows manuais
