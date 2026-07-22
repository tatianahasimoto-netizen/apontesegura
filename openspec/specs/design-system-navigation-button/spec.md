## Purpose

Contrato do **`CpfSeguroNavigationButton`** — a pilha de **1 a 3 CTAs** do rodapé
de um fluxo. É o conteúdo canônico de `CpfSeguroBottomApp.button`. Compõe
`CpfSeguroButton` (ver [`design-system-button`](../design-system-button/spec.md))
dentro da gramática de superfície (região `bottom`).

## Requirements

### Requirement: 1 a 3 ações empilhadas por hierarquia
`CpfSeguroNavigationButton` SHALL aceitar `primary` (topo), `secondary` e
`tertiary` (`CpfSeguroNavigationAction`), nessa ordem de hierarquia. NÃO SHALL
haver mais de 3 ações.

#### Scenario: Pausar / Cancelar
- **WHEN** o rodapé tem "Pausar agora" + "Cancelar"
- **THEN** `primary: Pausar agora`, `secondary: Cancelar`

### Requirement: Vive dentro de BottomApp.button
Para virar rodapé real da tela, `CpfSeguroNavigationButton` SHALL ser envolvido
em `CpfSeguroBottomApp.button(...)` (que provê glass + home indicator + safe
area). NÃO SHALL ser posto solto no meio do `content`.

#### Scenario: Rodapé de confirmação
- **WHEN** uma tela full precisa do CTA fixo embaixo
- **THEN** `bottom: CpfSeguroBottomApp.button(button: CpfSeguroNavigationButton(...))`

### Requirement: Uma primary só
A pilha SHALL ter no máximo uma ação `primary`. As demais SHALL descer pra
`secondary`/`tertiary`.

#### Scenario: Duas ações fortes
- **WHEN** duas ações parecem igualmente importantes
- **THEN** escolhe uma como `primary`; a outra vira `secondary`
