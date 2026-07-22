## Purpose

Contrato do **`CpfSeguroDetailRow`** — a linha **label/valor** de um comprovante ou
bloco de detalhe (horizontal: label à esquerda, valor à direita), com hairline
entre linhas.

## Requirements

### Requirement: Horizontal label/valor
`CpfSeguroDetailRow` SHALL exibir o label à esquerda e o valor à direita, com
hairline separando linhas.

#### Scenario: Comprovante Pix
- **WHEN** o comprovante lista "Origem" e o valor
- **THEN** DetailRow com label esquerda / valor direita

### Requirement: chevron só se tocável
`CpfSeguroDetailRow` SHALL mostrar chevron apenas quando a linha leva a outra
tela/ação. Linha estática NÃO SHALL ter chevron.

#### Scenario: Detalhe estático
- **WHEN** a linha só exibe informação
- **THEN** sem chevron

### Requirement: Detalhe, não lista navegável
Para uma lista de itens navegáveis repetíveis, SHALL usar `CpfSeguroAppListRow`.

#### Scenario: Lista de contatos tocáveis
- **WHEN** cada linha navega para um detalhe
- **THEN** é AppListRow, não DetailRow
