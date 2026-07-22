# Plano — migração de widgets (app → package DS)

Contexto: o app `cpf-seguro-real` ainda tem widgets forkados/próprios. O pivô
package-first quer o app consumindo os widgets do DS direto. A migração de
ícones (~608 usos) é faceta desta: os params `IconData` viram token String do
DS quando o widget host migra. Ver `ICON_NAME_MAP.md`.

## Paisagem

- **13 forks** em `lib/design_system/` do app — todos têm equivalente no DS.
- **27 componentes próprios** do app com param de ícone (`IconData`).
- **608 usos de ícone / 201 arquivos** pegam carona nesta migração.
- Regra: migração **atômica por arquivo** (dropa import da font, adota
  `CpfSeguroIcons` do DS sem colisão).

## Track A — Forks → package (13, ~1:1, baixo risco)

Trocar o import do fork pelo widget do package e DELETAR o fork. Os params que
divergiram (fork = `IconData`, DS = token String) resolvem o ícone aqui mesmo.

Forks: action, avatar, button, checkbox, glass_surface, icon_accessory,
icon_button, input_chip, loading_spinner, otp_input, spot_icon, status_tag,
toggle_switch.

Prioridade (memory já listava pendentes): **button, avatar, checkbox,
status_tag, spot_icon** primeiro. São 1:1, removem divergência e desbloqueiam.

## Track B — Componentes do app → twin DS ou alinhar param (27)

| Componente | Usos (arq) | Alvo DS proposto | Confiança | Nota |
|---|---|---|---|---|
| MenuItemComponent | 24 | MenuButton **ou** AppList | BAIXA | mais rico (subtitle, trailingComment, divider) — DECIDIR alvo |
| CustomIconButton | 19 | CpfSeguroIconButton | ALTA | IconData→token, swap direto |
| InformationCard | 6 | FeatureCard / DetailRow | MÉDIA | |
| InfoListComponent | 5 | DetailRow / AppList | MÉDIA | |
| ChipInfoWidget | 5 | InputChip / StatusTag | MÉDIA | |
| StatementListItem | 4 | DetailRow / AppList | MÉDIA | |
| ReadOnlyInput | 4 | CpfSeguroInput (readOnly) | ALTA | DS já tem readOnly+onTap (v0.9.0) |
| TextfieldComponent | 2 (residual) | CpfSeguroInput | ALTA | fecha o resto do P4 |
| PixMenuComponent | 2 | MenuButton | MÉDIA | |
| HomeBannerComponent | 2 | StatusBanner | MÉDIA | |
| + demais (cards/badges/pages locais) | 1 cada | twin ou **alinhar param** | — | B2 abaixo |

**B2 — app-specific sem twin** (páginas/cards que declaram `IconData icon`
local): não têm equivalente DS. Decisão: mudar o param `IconData` → token
String do DS (+ render `CpfSeguroIcon`), OU manter font nesses pontos isolados.

## Ordem de execução

1. **Track A forks** (1:1, baixo risco, remove divergência).
2. **Track B alta confiança**: CustomIconButton, ReadOnlyInput, TextfieldComponent.
3. **MenuItemComponent** (maior impacto) — só depois de decidir o alvo.
4. Cards/listas de confiança média.
5. **B2** app-specific: alinhar param ou manter.

## Modelo de execução

- **Atômico por arquivo**: migra a definição do componente + todos os call
  sites dele numa unidade; dropa import da font; adota token DS.
- **Workflow multi-agente**: 1 agente por componente (migra + call sites) +
  agente verify. Escala ~ P4 do Input (dezenas de agentes, múltiplos M tokens).
  **Precisa opt-in explícito.**
- **Gate por onda**: `flutter analyze lib/` = 0 erros + verificação visual.

## MenuItemComponent → CpfSeguroAppList (decidido + piloto OK)

Alvo = `CpfSeguroAppList` (sistema de linha por acessórios), NÃO MenuButton
(botão quick-access) nem DetailRow (subconjunto). Piloto `profile_documents_page`
migrado e `analyze` limpo.

Mapa de props:

| MenuItemComponent | CpfSeguroAppList |
|---|---|
| `leadingIcon` (plain) | `left: CpfSeguroLeftAccessory.iconAccessory(icon: <token>)` |
| `leadingIcon` + `iconBackgroundEnabled` | `left: ...spotIcon(icon: <token>, ...)` (bg circular) |
| `leadingWidgetCustom` | `left: ...custom(child)` |
| `title` (+ `subtitle`) | `middle: ...title(title:)` / `...titleSubtitle(title:, subtitle:)` |
| `trailingIcon` = chevron | `right: CpfSeguroRightAccessory.action(direction: right)` (chevron built-in, NÃO mapeia o ícone) |
| `trailingWidgetCustom` (switch) | `right: ...toggle / ...checkbox / ...custom` |
| `divider` (bool) | `position` (solo/first/middle/last) — hairline por agrupamento |
| `onTap` | `onTap` |

Regras:
- **Colisão:** arquivos que importam o barrel da font (`common.dart`) importam
  o DS com prefixo `as ds` (font `CpfSeguroIcons` fica em escopo pelo barrel).
- **Chevron** vem do `action(direction: right)`, não do ícone.
- **Divider:** item único = `solo`; listas = first/middle/last.

Gaps (decisão):
- **`isLoading` (shimmer):** AppList não tem estado loading (ex `home_body_page`
  usa `MenuItemComponent(isLoading:true)` como placeholder). Manter wrapper
  shimmer no call site OU adicionar loading ao DS.
- **`trailingComment` (texto):** sem slot direto — `right: amountChip` (valores)
  ou `right: custom(Text)`. Definir.
- **Overrides de cor custom** (`customLeadingIconColor`...): CAEM pra tokens/roles
  (contrato). Diferença visual a validar.

## Decisões abertas (precisam do user)

1. **MenuItemComponent** (24 arq, maior peso): alvo = `CpfSeguroMenuButton`,
   `CpfSeguroAppList`, ou estender o DS pra cobrir subtitle/trailing/divider?
2. **B2**: mudar API dos componentes app-specific (`IconData`→token) ou manter
   font nesses pontos?
3. **calendarRegularLight**: peso light vs regular (ver ICON_NAME_MAP).
4. **RISCO — WIP não commitado**: o app tem ~357 arquivos uncommitted (P4 + F1).
   Empilhar outra migração grande sobre árvore suja é arriscado. Recomendado
   COMMITAR o WIP atual antes de iniciar.
