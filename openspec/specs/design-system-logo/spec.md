## Purpose

Contrato do **`CpfSeguroLogo`** — a marca CPF Seguro: `mark` (só símbolo) e `full`
(símbolo + wordmark).

## Requirements

### Requirement: mark vs full por espaço
`full` SHALL ser usado em splash/topo/boas-vindas; `mark` em espaços apertados
(barras, ícones).

#### Scenario: Splash
- **WHEN** a tela de abertura mostra a marca
- **THEN** usa `full`

### Requirement: Marca não é recolorida nem distorcida
`CpfSeguroLogo` SHALL usar a cor da marca por token; NÃO SHALL ser recolorido,
distorcido ou rotacionado ad hoc.

#### Scenario: Fundo escuro
- **WHEN** a marca fica sobre fundo escuro
- **THEN** usa a variante de cor prevista, não um recolor manual

### Requirement: Marca do produto, não do parceiro
`CpfSeguroLogo` SHALL ser a marca CPF Seguro. Marca de parceiro SHALL usar os
componentes de cobrand.

#### Scenario: Tela cobrand
- **WHEN** aparece a marca do parceiro
- **THEN** é cobrand (CobrandMark/Eyebrow), não CpfSeguroLogo
