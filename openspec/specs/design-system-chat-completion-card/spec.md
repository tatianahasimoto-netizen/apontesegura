## Purpose

Contrato do **`CpfSeguroChatCompletionCard`** — o card de **conclusão** de um
nível/fluxo dentro do chat (nível concluído + próximo nível + CTAs). Vive no
onboarding.

## Requirements

### Requirement: Conclusão dentro do chat
`CpfSeguroChatCompletionCard` SHALL marcar a conclusão de um nível/fluxo no chat.
NÃO SHALL ser usado fora de fluxo conversacional.

#### Scenario: Nível concluído
- **WHEN** o usuário completa um nível do onboarding
- **THEN** aparece o ChatCompletionCard com o resumo

### Requirement: primary opcional + slot nextLevel
`CpfSeguroChatCompletionCard` SHALL aceitar `primary` opcional (ação de avançar) e
um slot `nextLevel` expansível para o próximo nível.

#### Scenario: Avançar de nível
- **WHEN** há um próximo nível
- **THEN** o slot `nextLevel` expande e o `primary` leva adiante

### Requirement: Hierarquia de CTAs
Se houver mais de uma ação, SHALL respeitar hierarquia (uma primary).

#### Scenario: Duas ações
- **WHEN** há avançar + secundária
- **THEN** só uma é primary
