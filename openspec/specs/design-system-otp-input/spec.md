## Purpose

Contrato do **`CpfSeguroOtpInput`** — o campo de **código de verificação** curto
(SMS/e-mail) em dígitos separados. Não é senha nem texto livre.

## Requirements

### Requirement: Dígitos separados de comprimento fixo
`CpfSeguroOtpInput` SHALL renderizar `length` boxes de um dígito. `length` SHALL
casar com o código enviado (ex.: 4 ou 6).

#### Scenario: Código SMS de 6 dígitos
- **WHEN** o backend envia um código de 6 dígitos
- **THEN** `CpfSeguroOtpInput(length: 6, ...)`

### Requirement: Completa automático no último dígito
`onCompleted` SHALL disparar quando o último dígito é preenchido, iniciando a
verificação sem exigir um botão "enviar" separado.

#### Scenario: Preencheu o código
- **WHEN** o usuário digita o último dígito
- **THEN** `onCompleted` dispara a verificação automaticamente

### Requirement: Erro inline
Falha de código SHALL ser sinalizada por `error` (boxes no role `error` +
mensagem), não por um alerta desacoplado.

#### Scenario: Código errado
- **WHEN** o código não confere
- **THEN** `error` marca os boxes e mostra a mensagem sob eles

### Requirement: OTP não é senha nem texto livre
`CpfSeguroOtpInput` SHALL ser usado só para código de verificação. Senha SHALL
usar `CpfSeguroChatInput`/`CpfSeguroInput` com `password`; texto livre, `Input`.

#### Scenario: Criar senha
- **WHEN** a tela cria uma senha
- **THEN** é um campo `password`, não OtpInput
