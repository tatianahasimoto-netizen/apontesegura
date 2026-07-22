## Purpose

Contrato do **`CpfSeguroBottomApp`** — o slot inferior da tela (região `bottom` da
Surface). Cada factory (`nav`, `button`, `keyboard`, `chatInput`,
`chatInputAndKeyboard`, `buttonAndKeyboard`, `defaultVariant`) compõe as moléculas
em glass + `CpfSeguroBottomHomeIndicator`.

## Requirements

### Requirement: Factory pelo conteúdo
`CpfSeguroBottomApp` SHALL ser instanciado pela factory que casa com o conteúdo:
`.nav` (tabs), `.button` (CTAs), `.chatInput` (chat), etc.

#### Scenario: Rodapé de fluxo com CTA
- **WHEN** a tela precisa do CTA fixo embaixo
- **THEN** `CpfSeguroBottomApp.button(button: CpfSeguroNavigationButton(...))`

### Requirement: Provê glass + home indicator + safe area
`CpfSeguroBottomApp` SHALL prover o glass, o `CpfSeguroBottomHomeIndicator` e a
safe area. A tela NÃO SHALL montar barra inferior própria.

#### Scenario: Bottom nav glass
- **WHEN** a home mostra a navegação inferior
- **THEN** o glass + indicator vêm do BottomApp.nav, não montados por fora

### Requirement: Uma barra inferior
NÃO SHALL haver duas barras inferiores empilhadas na mesma tela.

#### Scenario: Chat + teclado
- **WHEN** o chat precisa de input + teclado
- **THEN** usa a factory combinada (`.chatInputAndKeyboard`), não duas barras
