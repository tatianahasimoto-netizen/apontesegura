## Purpose

Contrato do **`CpfSeguroAction`** — o **affordance** de linha: o chevron/ellipsis
que sinaliza "abre / expande / opções isto" dentro de uma row tocável. É
sinalização, não um botão de ação com alvo próprio.

## Requirements

### Requirement: direção sinaliza a intenção
`CpfSeguroAction` SHALL expor `direction` (`CpfSeguroActionDirection`): `right`
(entrar/navegar), `up`/`down` (colapsar/expandir), `ellipsis` (menu de opções).
A direção SHALL casar com o comportamento real da row.

#### Scenario: Entrar num item de lista
- **WHEN** tocar na row abre uma tela de detalhe
- **THEN** o affordance é `CpfSeguroAction(direction: right)`

### Requirement: A row é o alvo de toque, não o Action
O toque SHALL ser tratado pela row inteira (AppListRow / GestureDetector). O
`CpfSeguroAction` SHALL apenas sinalizar; não é o hit-target principal.

#### Scenario: Linha de configuração
- **WHEN** uma AppListRow leva a outra tela
- **THEN** a row inteira é tocável e mostra `CpfSeguroAction(right)` à direita

### Requirement: Não é CTA
`CpfSeguroAction` NÃO SHALL ser usado como botão de ação real (cor neutra,
affordance). Ações reais SHALL usar `CpfSeguroButton` / `CpfSeguroIconButton`.

#### Scenario: Ação destrutiva
- **WHEN** a intenção é excluir algo
- **THEN** é `CpfSeguroIconButton(state: error)`, não um `CpfSeguroAction`
