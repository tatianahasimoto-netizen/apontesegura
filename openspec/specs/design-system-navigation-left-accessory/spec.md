## Purpose

Contrato do **`CpfSeguroNavigationLeftAccessory`** — o acessório esquerdo da top
bar: `back` (voltar na pilha), `close` (fechar sheet/fluxo) ou `home` (saudação +
avatar/perfil na raiz).

## Requirements

### Requirement: back vs close vs home por contexto
`back` SHALL ser usado para navegação de pilha; `close` para fechar sheet/modal/
fluxo; `home` só na tela raiz (saudação + acesso ao perfil).

#### Scenario: Sheet aberto
- **WHEN** um bottomsheet/fluxo precisa fechar
- **THEN** usa `close`, não `back`

### Requirement: back e close não coexistem
`CpfSeguroNavigationLeftAccessory` NÃO SHALL mostrar back e close ao mesmo tempo.

#### Scenario: Tela de detalhe
- **WHEN** a tela é empilhada
- **THEN** só `back` (não back + close)

### Requirement: home só na raiz
`home` SHALL aparecer apenas na tela raiz.

#### Scenario: Tela interna
- **WHEN** a tela não é raiz
- **THEN** não usa `home` (usa back/close)
