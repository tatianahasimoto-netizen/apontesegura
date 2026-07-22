## Purpose

Contrato do **`CpfSeguroAmountDisplay`** — o valor em **destaque** (hero, entre
hairlines) num detalhe de transação/saldo, com onTap/chevron opcional.

## Requirements

### Requirement: Hero do valor
`CpfSeguroAmountDisplay` SHALL ser o valor em destaque de um detalhe/saldo, não um
valor de linha.

#### Scenario: Detalhe da transação
- **WHEN** a tela de detalhe mostra o valor central
- **THEN** usa AmountDisplay entre hairlines

### Requirement: obscure/format/loading no consumidor
A ocultação (obscure), a formatação e o loading SHALL ser resolvidos pelo
consumidor; o componente só renderiza.

#### Scenario: Saldo oculto
- **WHEN** o usuário esconde o saldo
- **THEN** o consumidor controla o obscure; o AmountDisplay renderiza o estado

### Requirement: Hero, não linha
Valor compacto de linha SHALL usar `CpfSeguroAmount`.

#### Scenario: Valor numa lista
- **WHEN** o valor está numa AppListRow
- **THEN** é `CpfSeguroAmount`, não AmountDisplay
