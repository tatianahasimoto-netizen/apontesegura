## Purpose

Contrato do **`CpfSeguroPageTitle`** — o título (h1 22/32) + subtítulo opcional do
conteúdo, logo abaixo do appbar. Um por tela.

## Requirements

### Requirement: Um título por tela
`CpfSeguroPageTitle` SHALL ser o h1 do conteúdo; SHALL haver no máximo um por tela.

#### Scenario: Tela de perfil
- **WHEN** a tela de perfil abre
- **THEN** um PageTitle "Perfil" abaixo do appbar

### Requirement: Subtítulo curto e orientador
O subtítulo (opcional, bodyMd) SHALL ser curto e orientar o que fazer ali.

#### Scenario: Tela de nome
- **WHEN** a tela pede o nome completo
- **THEN** subtítulo "Atualize seu nome completo..."

### Requirement: Não é título de card/sheet/appbar
`CpfSeguroPageTitle` SHALL ser o título do conteúdo da tela. Título de card, de
bottomsheet e do appbar têm componentes próprios e NÃO SHALL usar PageTitle.

#### Scenario: Título de bottomsheet
- **WHEN** um sheet tem título
- **THEN** usa o title do NavigationTopBar do sheet, não PageTitle
