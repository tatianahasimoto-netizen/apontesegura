## Purpose

Contrato do **`CpfSeguroNoticeBanner`** — o card claro de **aviso/estado** da conta
com botão-ícone (fechar ou uma ação). Mais leve que StatusBanner, mais persistente
que Toast.

## Requirements

### Requirement: Aviso/estado persistente e leve
`CpfSeguroNoticeBanner` SHALL trazer um aviso/estado que precisa ficar na tela,
com mensagem curta e um botão-ícone (fechar ou ação única).

#### Scenario: Estado da conta na home
- **WHEN** há um aviso de estado a comunicar de forma leve
- **THEN** um NoticeBanner com a mensagem + botão-ícone

### Requirement: Ilustração por token
A ilustração SHALL vir por token (`illustration: enum`), não por String-path.

#### Scenario: Banner com imagem
- **WHEN** o aviso tem ilustração
- **THEN** `illustration:` enum, não um asset cru

### Requirement: Não é promo nem hero de proteção
Promoção SHALL usar `CpfSeguroPromoBanner`; o hero de proteção,
`CpfSeguroStatusBanner`; feedback efêmero, `CpfSeguroToast`.

#### Scenario: Confirmação efêmera
- **WHEN** a mensagem é um resultado passageiro
- **THEN** é Toast, não NoticeBanner
