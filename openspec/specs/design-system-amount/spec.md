## Purpose

Contrato do **`CpfSeguroAmount`** — o valor monetário **compacto** de linha (cashIn
verde / cashOut − / cashBack tachado / obscured). Usado como accessory direito da
AppListRow.

## Requirements

### Requirement: Sinal/cor pelo tipo
`CpfSeguroAmount` SHALL derivar sinal e cor do tipo (cashIn/cashOut/cashBack/
obscured), não de estilo cru na tela.

#### Scenario: Entrada de dinheiro
- **WHEN** a linha é uma entrada
- **THEN** o Amount aparece em verde (cashIn)

### Requirement: Accessory de linha
`CpfSeguroAmount` SHALL entrar via `right.amount` da `CpfSeguroAppListRow`.

#### Scenario: Linha de pagamento
- **WHEN** uma AppListRow mostra o valor
- **THEN** usa `right.amount`

### Requirement: Compacto, não hero
`CpfSeguroAmount` SHALL ser o valor compacto de linha. O valor em destaque (hero)
SHALL usar `CpfSeguroAmountDisplay`.

#### Scenario: Saldo em destaque
- **WHEN** o valor é o hero da tela
- **THEN** é AmountDisplay, não Amount
