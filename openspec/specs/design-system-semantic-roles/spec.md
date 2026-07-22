## Purpose

Definir a **camada semântica** do DS — os *roles* — como o dicionário de
significado da linguagem. Um role não é uma cor: é um pacote de intenção
(cor + on-color + ícone default + tom + par de contraste). "Vermelho = erro"
mora aqui, não na convenção. Componentes consomem roles; nunca cor crua.

Base atual a estender (não recriar): `CpfSeguroScheme` (semântico) e
`CpfSeguroStatusTone { warning, neutral, primary, success, danger, secure }`.
Contexto conceitual em [`DS_LANGUAGE.md`](../../../DS_LANGUAGE.md) §1.

## Requirements

### Requirement: Componente consome role, nunca estilo cru
Todo componente do DS SHALL receber a intenção via **role/intent/tone/size** e
resolver cor, ícone e contraste a partir do role. Componente SHALL NOT receber
cor, raio ou spacing cru como API pública de estilo, nem referenciar
`CpfSeguroPalette` (primitivo) diretamente no corpo de um widget.

#### Scenario: Nenhuma cor primitiva vaza pro componente
- **WHEN** se roda `rg "CpfSeguroPalette" lib/design_system/widgets/`
- **THEN** o resultado é vazio (widgets consomem só `CpfSeguroScheme`/roles, não a paleta primitiva)

#### Scenario: Erro expresso por role, não por cor
- **WHEN** um componente precisa comunicar falha (ex.: Input, StatusTag, Toast)
- **THEN** ele recebe o role `error`/`danger` e deriva a cor dele — não um `Color` vermelho literal

### Requirement: Conjunto canônico de roles
O DS SHALL expor um conjunto fechado de roles semânticos, cada um com
significado fixo. O conjunto mínimo:

| role | significado | cor base | ícone default |
|---|---|---|---|
| `primary` | ação principal / marca | primary-04 | — |
| `error` / `danger` | falha / destrutivo | error-04 | triangle-exclamation |
| `success` | confirmação | success-04 | circle-check |
| `warning` | atenção / limite | warning-04 | triangle-exclamation |
| `secure` | KYC / pausa / proteção | secure-03 | lock |
| `info` / `neutral` | informativo | neutral | circle-info |

Novos roles SHALL entrar por change (proposal) — não ad hoc no código.

#### Scenario: Role fora do dicionário é rejeitado
- **WHEN** um componente precisa de uma intenção que não é um role canônico
- **THEN** o role é adicionado ao dicionário via change antes de ser usado (nunca uma cor solta pra "resolver rápido")

### Requirement: Cada role é um pacote (cor + on-color + ícone + contraste)
Cada role SHALL definir: cor base, `on-<role>` (texto/ícone sobre a cor base),
ícone default, e o par de contraste garantido. Componentes SHALL usar `on-role`
pra conteúdo sobre a cor do role — nunca escolher a cor de texto manualmente.

#### Scenario: Texto sobre a cor do role
- **WHEN** um botão usa `role: primary` com label
- **THEN** o label usa `on-primary` do role, não um branco/preto hardcoded

### Requirement: Contraste acessível por par role/on-role
Todo par `role` / `on-role` SHALL atender contraste WCAG AA (≥ 4.5:1 texto
normal; ≥ 3:1 texto grande e ícones). A garantia de contraste é propriedade do
role, não responsabilidade da tela.

#### Scenario: Par abaixo do mínimo bloqueia
- **WHEN** um novo role (ou ajuste de cor) é proposto
- **THEN** o change só é aceito se o par role/on-role passar no AA (teste de contraste no design/tasks)

### Requirement: Tokens em três camadas, semântico como única superfície
Os tokens SHALL seguir 3 camadas: primitivo (`CpfSeguroPalette`) → semântico
(roles / `CpfSeguroScheme`) → componente. O nível **semântico** SHALL ser o
único que o componente enxerga. O primitivo é trocável por *flavor* sem que
nenhum componente mude.

#### Scenario: Troca de flavor não toca componente
- **WHEN** a paleta primitiva é trocada por outro flavor de marca
- **THEN** nenhum arquivo em `lib/design_system/widgets/` precisa mudar (só o mapeamento primitivo → semântico)

### Requirement: Significado compartilhado entre plataformas
Os roles SHALL ser a fonte de significado compartilhada entre as implementações
(Flutter mobile e web). A mesma tabela de roles vale pro `cpf_seguro_ds` (Dart)
e pro futuro `cpf_seguro_ds_web` — só a implementação muda, o significado não.

#### Scenario: Role idêntico em mobile e web
- **WHEN** o role `secure` é usado no app mobile e no webadmin/IB
- **THEN** ambos derivam do mesmo token semântico (gerado da fonte única), com o mesmo significado (KYC/proteção)
