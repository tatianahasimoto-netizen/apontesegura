## Purpose

Definir a **gramática** de composição do DS: toda superfície (screen, modal,
bottomsheet) se monta navegando por regiões — **top · content · bottom** — via o
primitivo `CpfSeguroSurface`. É a lógica primordial de layout do app.

Não é a raiz do sistema: a raiz são os tokens + roles ([`design-system-semantic-roles`](../design-system-semantic-roles/spec.md)).
Surface é **um** primitivo (cobre ~80-90% das telas). Contexto em
[`DS_LANGUAGE.md`](../../../DS_LANGUAGE.md) §2.

## Requirements

### Requirement: Superfície se compõe por regiões via CpfSeguroSurface
Screen, modal e bottomsheet SHALL ser montados por `CpfSeguroSurface` com as
regiões `top` (opcional), `content` (obrigatório) e `bottom` (opcional). Não
SHALL haver um scaffold próprio por tela reimplementando essa estrutura.

#### Scenario: Screen padrão
- **WHEN** uma tela full precisa de barra superior, corpo e navegação inferior
- **THEN** ela usa `CpfSeguroSurface(top: …, content: …, bottom: …)`, não um Column/Stack ad hoc

### Requirement: content é o único slot rolável
Na `CpfSeguroSurface`, o `content` SHALL ser a única região que rola; `top` e
`bottom` SHALL ficar fixos. `content` é rolável por default (`scrollableContent`).

#### Scenario: Conteúdo longo
- **WHEN** o content excede a altura disponível
- **THEN** só o content rola; top e bottom permanecem fixos na tela

### Requirement: top e bottom usam os componentes canônicos
`top` SHALL aceitar `CpfSeguroTopAppBar` / `CpfSeguroNavigationTopBar`. `bottom`
SHALL aceitar `CpfSeguroBottomApp` (nav, button, keyboard, chatInput). Não SHALL
haver barras superiores/inferiores paralelas fora desses contratos.

#### Scenario: Bottom com navegação global
- **WHEN** uma tela de nível raiz precisa da navegação global
- **THEN** o `bottom` recebe `CpfSeguroBottomApp.nav(...)`

### Requirement: Sheet e modal reusam a mesma gramática
Bottomsheet e modal SHALL usar `CpfSeguroSurface.sheet` (cantos superiores r24,
fundo de surface) — a **mesma** gramática top/content/bottom, não um widget de
sheet separado com layout próprio.

#### Scenario: Sheet de confirmação
- **WHEN** um modal de confirmação com título e dois CTAs é aberto
- **THEN** ele é uma `CpfSeguroSurface.sheet` com `top` (grip + close), `content` (texto) e `bottom` (`CpfSeguroNavigationButton`)

### Requirement: content consome roles, nunca cor crua
O conteúdo montado dentro de `content` SHALL consumir roles/tokens semânticos
(ver `design-system-semantic-roles`), nunca cor/raio/spacing cru.

#### Scenario: Estado de erro no content
- **WHEN** o content mostra um erro
- **THEN** usa o role `error`/`danger` (via componente do DS), não um `Color` vermelho literal

### Requirement: Surface é primitivo, web adiciona região side
`CpfSeguroSurface` (top/content/bottom) SHALL ser tratado como primitivo, não
como a raiz do sistema. A gramática web (webadmin / IB) SHALL admitir uma 4ª
região `side` (nav lateral) + breakpoints e densidade, sem forçar tudo em 3
fatias.

#### Scenario: Admin web com nav lateral
- **WHEN** uma tela de webadmin precisa de navegação lateral persistente
- **THEN** a gramática admite a região `side` além de top/content/bottom (não se espreme a nav num dos 3 slots)
