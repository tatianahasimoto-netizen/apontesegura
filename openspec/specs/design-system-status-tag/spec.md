## Purpose

Contrato do **`CpfSeguroStatusTag`** — o rótulo de **estado semântico** (Pago,
Pendente, Erro, Seguro). O `tone` carrega o significado (ver
[`design-system-semantic-roles`](../design-system-semantic-roles/spec.md)).

## Requirements

### Requirement: tone é o significado
`CpfSeguroStatusTag` SHALL receber um `tone` (`CpfSeguroStatusTone`:
warning/neutral/primary/success/danger/secure). O tone SHALL casar com o estado
real; cor crua NÃO é permitida.

#### Scenario: Pagamento concluído
- **WHEN** um item foi pago
- **THEN** `CpfSeguroStatusTag(label: 'Pago', tone: success)`

### Requirement: Texto curto de estado
O `label` SHALL ser o estado em 1-2 palavras. O ícone default do tone acompanha.

#### Scenario: Documento em erro
- **WHEN** o doc falhou
- **THEN** tag `tone: danger` com o ícone do tone

### Requirement: Estado, não filtro nem decoração
`CpfSeguroStatusTag` SHALL indicar estado. Filtro removível SHALL usar
`CpfSeguroInputChip`; pill decorativo SHALL usar `CpfSeguroInfoChip`.

#### Scenario: Filtro de período
- **WHEN** a intenção é um filtro ativo removível
- **THEN** é `CpfSeguroInputChip`, não StatusTag
