## Purpose

Contrato do **`CpfSeguroChatBubble`** — a bolha de fala do chat/onboarding (bot
bottom-left · user bottom-right). Hug-content, wmax 250, tone por papel. Base da
superfície de chat (bolhas + `CpfSeguroChatInput` no bottom, fundo único).

## Requirements

### Requirement: Alinhamento por autor
`CpfSeguroChatBubble` SHALL alinhar por `from`: bot à esquerda, user à direita.

#### Scenario: Fala do bot
- **WHEN** o bot fala
- **THEN** a bolha fica bottom-left (cinza)

### Requirement: tone por papel
O `tone` SHALL carregar o papel da mensagem (neutra, alerta). Cor crua NÃO é
permitida.

#### Scenario: Aviso no chat
- **WHEN** o bot alerta sobre algo
- **THEN** usa `tone` alert, não um vermelho literal

### Requirement: Hug-content com teto
A bolha SHALL abraçar o conteúdo com largura máxima (250); conteúdo multi-item
(CriteriaBubble) SHALL soltar o teto via `wide`.

#### Scenario: Bolha de critérios
- **WHEN** a bolha lista critérios de senha
- **THEN** usa `CpfSeguroChatCriteriaBubble` (wide), não uma bubble apertada

### Requirement: Bolha do DS, não montada na mão
Falas do chat SHALL usar `CpfSeguroChatBubble`; NÃO SHALL haver container de bolha
ad hoc por tela.

#### Scenario: Nova fala no onboarding
- **WHEN** aparece uma mensagem
- **THEN** é um ChatBubble, não um Container estilizado à mão
