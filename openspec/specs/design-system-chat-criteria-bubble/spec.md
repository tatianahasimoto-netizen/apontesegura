## Purpose

Contrato do **`CpfSeguroChatCriteriaBubble`** — a bolha do chat que apresenta os
**critérios** (ex.: regras de senha) via `CpfSeguroCriteriaList`. É a variante wide
do `CpfSeguroChatBubble` para conteúdo multi-item.

## Requirements

### Requirement: Compõe CriteriaList
Os critérios SHALL ser renderizados por `CpfSeguroCriteriaList` (marker ok/fail/
pending), dentro da bolha.

#### Scenario: Critérios de senha
- **WHEN** o passo de senha lista as regras
- **THEN** a bolha usa CriteriaList com os estados

### Requirement: Wide para multi-item
`CpfSeguroChatCriteriaBubble` SHALL soltar o teto de 250 do ChatBubble para caber
a lista.

#### Scenario: Lista longa de regras
- **WHEN** há várias regras
- **THEN** a bolha usa a largura wide, não a apertada de fala

### Requirement: Estado reage à digitação
Os markers SHALL atualizar conforme o usuário digita (via CriteriaList).

#### Scenario: Digitando a senha
- **WHEN** a senha passa a atender uma regra
- **THEN** o marker vira ok em tempo real
