## Purpose

Contrato do **`CpfSeguroNavigationRightAccessory`** — os acessórios direitos da top
bar: até 3 ícones de ação (sino, olho) OU um botão tertiary small.

## Requirements

### Requirement: No máximo 3 ícones
`CpfSeguroNavigationRightAccessory` SHALL ter no máximo 3 ícones de ação. Acima
disso, repensar a barra.

#### Scenario: Home com sino + olho
- **WHEN** a home tem notificações e toggle de saldo
- **THEN** dois ícones à direita (≤3)

### Requirement: Rótulo acessível em cada ícone
Cada ícone SHALL ter `semanticLabel`.

#### Scenario: Ícone de sino
- **WHEN** o sino de notificações aparece
- **THEN** tem semanticLabel "Notificações"

### Requirement: CTA principal não vive no topo
A ação principal da tela SHALL ficar na bottom bar. O acessório direito comporta
só ações secundárias (ícones ou buttonTertiarySmall).

#### Scenario: Ação "Salvar"
- **WHEN** salvar é a ação principal
- **THEN** vai pra bottom bar (NavigationButton), não pro topo
