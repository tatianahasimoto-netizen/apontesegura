## Purpose

Contrato do **`CpfSeguroNavigationTopBar`** — o CONTEÚDO da top bar: acessório
esquerdo + título + acessórios direitos (altura 52, sem glass). O glass vem do
`CpfSeguroTopAppBar` / Surface.

## Requirements

### Requirement: left + title + right por acessório
`CpfSeguroNavigationTopBar` SHALL compor `left` (`CpfSeguroNavigationLeftAccessory`)
+ `title` opcional + `right` (`CpfSeguroNavigationRightAccessory`). NÃO SHALL
montar a linha com Row de ícones cru.

#### Scenario: Barra de detalhe
- **WHEN** uma tela de detalhe tem back + título
- **THEN** `left: NavigationLeftAccessory.back(...)`, `title: '...'`

### Requirement: Sem glass próprio
`CpfSeguroNavigationTopBar` NÃO SHALL aplicar glass; o efeito é do container
(`CpfSeguroTopAppBar.app` / Surface).

#### Scenario: Barra glass
- **WHEN** a top bar precisa de glass
- **THEN** o glass vem da TopAppBar.app, não do NavigationTopBar
