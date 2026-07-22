## Purpose

Contrato do **`CpfSeguroWalletCard`** — o cartão da carteira / meio de pagamento.
Variantes: `cpfSeguro`, `partner`, `payment`, `pixSplash` (+ Stack). Hero visual do
cartão.

## Requirements

### Requirement: Variante conforme o cartão
`CpfSeguroWalletCard` SHALL escolher a variante pelo cartão: cpfSeguro, partner,
payment ou pixSplash (fluxo NFC).

#### Scenario: Splash do Pix por aproximação
- **WHEN** a tela de NFC mostra o cartão Pix
- **THEN** usa a variante `pixSplash`

### Requirement: Skeleton enquanto carrega
Enquanto os dados do cartão carregam, SHALL mostrar a variante skeleton.

#### Scenario: Carregando o cartão
- **WHEN** os dados do cartão ainda não vieram
- **THEN** mostra o WalletCard skeleton

### Requirement: Cartão, não card genérico
`CpfSeguroWalletCard` SHALL ser o cartão de pagamento. Bloco informativo genérico
SHALL usar `CpfSeguroInfoCard`.

#### Scenario: Card de aviso
- **WHEN** é um bloco de informação
- **THEN** é InfoCard, não WalletCard
