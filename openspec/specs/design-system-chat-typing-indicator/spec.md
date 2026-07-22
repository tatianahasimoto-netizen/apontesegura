## Purpose

Contrato do **`CpfSeguroChatTypingIndicator`** — a bolha própria de "digitando"
(80×54, fixa) que sinaliza que o bot está preparando a próxima fala.

## Requirements

### Requirement: Espera do bot
`CpfSeguroChatTypingIndicator` SHALL aparecer enquanto o bot prepara a próxima
mensagem, na posição de bolha do bot.

#### Scenario: Bot pensando
- **WHEN** o próximo passo do chat está carregando
- **THEN** mostra o typing indicator antes da fala

### Requirement: Bolha própria fixa
`CpfSeguroChatTypingIndicator` SHALL ser uma bolha própria de tamanho fixo (80×54),
não um spinner genérico dentro de um ChatBubble.

#### Scenario: Indicador de digitação
- **WHEN** o chat sinaliza atividade do bot
- **THEN** usa o typing indicator, não um LoadingSpinner na bolha

### Requirement: Some quando a fala chega
O indicador SHALL desaparecer quando a mensagem real é renderizada.

#### Scenario: Fala pronta
- **WHEN** a resposta do bot chega
- **THEN** o typing indicator é substituído pela ChatBubble
