## Purpose

Contrato do **`CpfSeguroTopAppBar`** — a barra superior da tela (organismo, região
`top` da Surface). Factories: `.app` (glass + inset real da status bar),
`.stepper` (fluxo com progresso) e `.defaultVariant` (mock 9:41, só catálogo).

## Requirements

### Requirement: .app nas telas do app
Telas do app SHALL usar `CpfSeguroTopAppBar.app` (glass + inset REAL da status
bar). A `.defaultVariant` (mock 9:41) NÃO SHALL ser usada em tela real.

#### Scenario: Top bar da home
- **WHEN** a home renderiza a barra superior
- **THEN** usa `CpfSeguroTopAppBar.app(navBar: ...)`

### Requirement: Compõe NavigationTopBar
O conteúdo (left/title/right) SHALL vir de `CpfSeguroNavigationTopBar`; a
TopAppBar cuida do chrome (glass + safe area).

#### Scenario: Barra com home + ícones
- **WHEN** a top bar tem saudação e ícones à direita
- **THEN** o navBar é um NavigationTopBar dentro da TopAppBar.app

### Requirement: Conteúdo passa sob o glass
Para o glass funcionar, a tela SHALL usar `extendBodyBehindAppBar` para o content
rolar sob a barra.

#### Scenario: Chat rola sob o topo
- **WHEN** o content é rolável sob a top bar glass
- **THEN** a tela usa extendBodyBehindAppBar
