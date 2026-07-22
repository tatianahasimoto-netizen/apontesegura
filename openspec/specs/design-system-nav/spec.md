## Purpose

Contrato do **`CpfSeguroNav`** — a navegação **global** entre raízes (Home, Sou eu,
Carteira, CPF Seguro). Vive na bottom bar em glass, com pop-out no item ativo.

## Requirements

### Requirement: Navegação entre raízes, não ação
`CpfSeguroNav` SHALL trocar entre seções-raiz do app. NÃO SHALL disparar uma ação
(isso é Button).

#### Scenario: Ir pra Carteira
- **WHEN** o usuário toca a aba Carteira
- **THEN** o app muda de seção-raiz via Nav

### Requirement: Tabs configuráveis via .items
`CpfSeguroNav.items` SHALL receber `items` (`CpfSeguroNavItem`: icon+label+badge),
`activeIndex` e `onIndexChanged`.

#### Scenario: Nav dinâmica do app
- **WHEN** as tabs vêm do controller
- **THEN** `CpfSeguroNav.items(items: [...], activeIndex: i, onIndexChanged: ...)`

### Requirement: Poucas tabs
`CpfSeguroNav` SHALL ter um número pequeno de tabs (~5, idioma de bottom nav).
Acima disso, a IA SHALL ser repensada.

#### Scenario: Muitas seções
- **WHEN** há mais de 5 seções-raiz
- **THEN** reorganiza a IA (não empilha tabs)
