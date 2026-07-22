## Purpose

Contrato do **`CpfSeguroStatusBanner`** — o card **hero de estado** da conta/
proteção no topo da home (nível, pausa, doc em análise/erro). Um por tela.

## Requirements

### Requirement: Estado da conta, um por tela
`CpfSeguroStatusBanner` SHALL comunicar o estado de proteção/conta e SHALL haver
no máximo um por tela (é o hero de estado).

#### Scenario: Home protegida
- **WHEN** a home mostra o estado do CPF
- **THEN** um único StatusBanner no topo

### Requirement: eyebrow + footnote + StatusBannerButton
O estado SHALL vir no `eyebrow`; verificado/pausado (+ instituições) na
`footnote`; a ação principal (pausar/reativar) no `CpfSeguroStatusBannerButton`.

#### Scenario: Pausar proteção
- **WHEN** o usuário pode pausar
- **THEN** o banner traz o StatusBannerButton "Pausar"

### Requirement: Sem status-dot/info-pills
Conforme a decisão 07-21, `CpfSeguroStatusBanner` NÃO SHALL trazer status-dot nem
info-pills (o app adotou o look do DS).

#### Scenario: Migração do card do app
- **WHEN** o card de proteção do app é migrado
- **THEN** dot e pills saem; estado vira eyebrow/footnote

### Requirement: Não é promo nem aviso simples
Promoção SHALL usar `CpfSeguroPromoBanner`; aviso leve, `CpfSeguroNoticeBanner`.

#### Scenario: Oferta
- **WHEN** a mensagem é marketing
- **THEN** é PromoBanner, não StatusBanner
