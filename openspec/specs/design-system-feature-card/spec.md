## Purpose

Contrato do **`CpfSeguroFeatureCard`** — o card de destaque do carrossel "PARA
VOCÊ" (tile de ícone + título + estado em overlay). Um destaque, não item de
lista.

## Requirements

### Requirement: Destaque, não linha de lista
`CpfSeguroFeatureCard` SHALL ser um card de destaque. Linha de lista repetível
SHALL usar `CpfSeguroAppListRow`.

#### Scenario: Carrossel "PARA VOCÊ"
- **WHEN** a home mostra destaques
- **THEN** cada destaque é um FeatureCard

### Requirement: Estado via statusOverlay
O estado SHALL entrar por `statusOverlay` (slot), e a cor de marca por
`brandColor`; a máquina de estado fica no consumidor.

#### Scenario: Card com selo de estado
- **WHEN** o destaque tem um estado (novo, bloqueado)
- **THEN** o estado vem no `statusOverlay`, alimentado pelo wrapper

### Requirement: Conteúdo enxuto
O título SHALL ser curto para caber no card sem estourar.

#### Scenario: Título longo
- **WHEN** o texto não cabe
- **THEN** encurta o título (não deixa overflow)
