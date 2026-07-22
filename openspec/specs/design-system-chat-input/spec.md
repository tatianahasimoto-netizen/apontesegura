## Purpose

Contrato do **`CpfSeguroChatInput`** — a barra de entrada dos fluxos de chat/
onboarding: um campo por vez + toggle eye + botão enviar + erro + chip de
checkbox opcional. Recompõe `CpfSeguroField`; vive no `bottom` via
`CpfSeguroBottomApp.chatInput` (ver [`design-system-surface-grammar`](../design-system-surface-grammar/spec.md)).

## Requirements

### Requirement: Núcleo é o átomo Field
`CpfSeguroChatInput` SHALL compor `CpfSeguroField`. NÃO SHALL montar
`EditableText` + overlay ad-hoc — a robustez (seleção/IME/autofill/a11y) é do
Field, resolvida uma vez.

#### Scenario: Campo de cadastro
- **WHEN** o onboarding pede um dado
- **THEN** o ChatInput usa o Field como núcleo, herdando o comportamento nativo

### Requirement: Validação e erro no consumidor
A VALIDAÇÃO e o gate de envio SHALL ficar no wrapper (validator/onError/merge de
erro server-side); `CpfSeguroChatInput` SHALL apenas renderizar o `errorText`
final e expor `onSend`/`sendDisabled`.

#### Scenario: Telefone inválido
- **WHEN** o número digitado é inválido
- **THEN** o wrapper resolve e passa `errorText`; o send fica `sendDisabled: true`

### Requirement: Ancorado no bottom da superfície
Para virar barra real, `CpfSeguroChatInput` SHALL ser envolvido em
`CpfSeguroBottomApp.chatInput` (glass + home indicator + safe area), não posto
solto no content.

#### Scenario: Passo do onboarding
- **WHEN** um passo do chat pede entrada
- **THEN** `bottom: CpfSeguroBottomApp.chatInput(input: CpfSeguroChatInput(...))`

### Requirement: Campo sensível usa password + eye
Para senha, `password: true` + toggle `visible`/`onToggleVisible` SHALL controlar
a ocultação. NÃO SHALL haver um campo de senha paralelo fora deste contrato.

#### Scenario: Criar senha
- **WHEN** o passo pede uma senha
- **THEN** `password: true` e o eye alterna a visibilidade

### Requirement: Um campo por vez
`CpfSeguroChatInput` SHALL representar UMA entrada por vez (o chat guia). NÃO
SHALL ser empilhado como formulário multi-campo.

#### Scenario: Vários dados
- **WHEN** o fluxo precisa de nome, CPF e telefone
- **THEN** são passos sequenciais do chat, um ChatInput por vez, não um form empilhado
