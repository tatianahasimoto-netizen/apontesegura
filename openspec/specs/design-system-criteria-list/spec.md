## Purpose

Contrato do **`CpfSeguroCriteriaList`** — a lista de **regras/validações com
estado** (ok/fail/pending), tipicamente os critérios de senha. Reage à digitação.

## Requirements

### Requirement: Marker por estado
Cada critério SHALL ter um marker do estado: ok, fail ou pending.

#### Scenario: Critérios de senha
- **WHEN** a senha atende "8+ caracteres" mas não "1 número"
- **THEN** o primeiro fica ok e o segundo fail

### Requirement: Reage à entrada
`CpfSeguroCriteriaList` SHALL atualizar os estados conforme o usuário digita (não
é estático).

#### Scenario: Digitando a senha
- **WHEN** o usuário adiciona um número
- **THEN** o critério correspondente passa a ok em tempo real

### Requirement: Validação, não checklist interativo
`CpfSeguroCriteriaList` mostra validação automática; NÃO SHALL ser um checklist que
o usuário marca (isso é `CpfSeguroCheckbox`).

#### Scenario: Aceitar termos
- **WHEN** o usuário precisa marcar itens manualmente
- **THEN** é Checkbox, não CriteriaList
