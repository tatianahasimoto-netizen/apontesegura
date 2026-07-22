# Auditoria do catálogo — cobertura componente × superfície

> Snapshot 2026-07-20 (fim da leva Onda A + enriquecimentos). O catálogo reflete
> o que temos de verdade. Princípio: a cada mudança de componente, atualizar
> Preview + Árvore + Spec + Integração (não Fluxos/SDK/Standalone).

## Estado da integração (snapshot — aba Integração)

94 itens rastreados. Cinco baldes — 3 de INTEGRAÇÃO (transitório) + 2 de
DEFINITIONS (por design, fora do cálculo):

| Balde | Nº | O que é |
|---|---|---|
| **Integrado** | **41** | `used` (26) + `token port` (8) — DS é a fonte no app |
| Playbook only | 38 | GAP: DS tem, app não adotou (15 bespoke + 26 gap suave) |
| App only | 0 | (Dropdown/DatePicker viraram palavra e o app já delega — ver v0.27) |
| DS definitions | 10 | só no DS POR DESIGN (SDK/cobrand/device) — nunca no app |
| App definitions | 6 | só no app POR DESIGN (plataforma/dev/domínio) — nunca DS |

**Integração = integrado / integrável** (exclui as 16 definitions): 41/78 ≈ **53%**.
O "playbook only" antes inflava porque juntava gaps reais + coisas que nunca vão
pro app; agora o que é por-design vive em **DS/App definitions**, separado do gap.

## Leva v0.27 (input pickers + ajuste de bolha)

- **Dropdown** (molécula): campo Input readOnly + chevron → bottomsheet
  single-select (idioma mobile HIG/Material). App delega via `DropdownComponent`
  (title → sheetTitle); call-site `insert_pix_key_page` intacto.
- **Calendar** (superfície) + **DateField** (campo): grid mensal em Flutter puro
  (sem `table_calendar`). App delega via `CustomDatePickerWidget` (isReversed
  mapeia os limites); 2 pix scheduling sheets saíram do `table_calendar`.
- **ChatBubble**: wmax 270 → **250** (hug, bot e user); **loading** virou bolha
  própria fixa **80×54** (o `ChatTypingIndicator` já é a bolha — os 2 onboardings
  não envolvem mais em ChatBubble).
- **Input**: mantido em **altura fixa 48** (revertida a tentativa de padding 12/8).
- Integração: Dropdown/DatePicker `app only` → `used` (34/77 ≈ 44%).

## Palavras novas / enriquecimentos desta leva

Todas catalogadas nas 4 superfícies + typedef público sem prefixo:
- **Motion** (token): duração + easing + **contexto** (fade/sheet/page/control/
  toast/emphasis). Presets/ScreenTransition + widgets DS consomem; app adotou.
- **Skeleton + Shimmer**: forma + efeito de loading (loop `Motion.shimmer`).
  Absorveu o `MenuItemComponent` zumbi.
- **CriteriaList** (+ CriteriaRow): extraído do ChatCriteriaBubble; app adotou
  (PasswordRequirement).
- **PromoBanner**: banner CTA light/solid (distinto de StatusBanner de nível).
- **InfoChip**: pill decorativo light/onColor; absorveu o `ChipInfoWidget`.
- **OtpInput**: enriquecido pra interativo (controller/foco/onChanged/obscure);
  app delega.
- **Amount / ProgressRing** (leva anterior).

Adoção Onda A (delegação, estética→DS, call-sites intactos): ToggleSwitch,
LoadingSpinner, Toast, Logo, EmptyState.

## Método

- Fonte da verdade = classes `CpfSeguroX extends Stateless/StatefulWidget` em
  `lib/design_system/widgets/` (só WIDGETS — enums, data-classes e tokens NÃO são
  componentes de catálogo e ficam de fora).
- Excluídos: infra (DevInfo/Animation/Gap/Text/ScreenTransition/ChatScroll/
  KeyboardIndicator), acessórios de slot (Left/Middle/RightAccessory,
  NavigationLeft/RightAccessory — documentados via named ctors nas seções
  AppList/Nav) e partes internas (StatusBanner*, AppListGroup/DayGroup).
- Presença: `CpfSeguroX(` OU `CpfSeguroX.` (cobre construtores nomeados, ex.
  `Amount.cashIn`, `LeftAccessory.spotIcon`).

## Cobertura nas 4 superfícies (~90 componentes reais)

**Preview / Árvore / Spec / Integração: completos** para todos os componentes
reais (verificado por scan cruzado nesta leva). Os "faltantes" residuais são
INTENCIONAIS:

| Componente | Ausente em | Por quê (intencional) |
|---|---|---|
| SheetOverlay | Preview/Árvore/Spec | primitivo INTERNO (não é API pública showcase) |
| Surface | Preview/Spec/Integração | mostrado na aba **Gramática** (top/content/bottom) |
| SdkScreen | Spec | tela cheia — mostrada em **Standalone/Fluxos**, não em spec-table |
| Nav / BottomApp | Integração | rastreados como item COMBINADO `Nav / BottomApp` |

## Consolidação do zoo de linhas (FECHADA 2026-07-20)

Sistemas de linha paralelos ao `AppList` foram ELIMINADOS:
- **Deletados**: `ListItemComponent` (base arbitrary-widget), `InfoListComponent`,
  `InfoItem`, `InfoCardComponent`.
- Toda linha consome `ds.AppList` via recipes de domínio (BasicPaymentItem,
  StatementListItem, wrappers contato/serviço, SummaryInfoListWithReciever).
- `ReceiverInfoCard` mantido (app-specific: chip copiar-chave com clipboard).

Palavras novas criadas no DS na consolidação (todas catalogadas nas 4 superfícies
+ typedef público sem prefixo): **Amount** (cashIn/cashOut/cashBack/obscured),
**ProgressRing** (+ `left.progressRing`), **right.iconAccessory**, `left.avatar`+size.

## Ilustração: token ↔ accessory (FORMALIZADO 2026-07-20)

Mesmo padrão de `Icon ↔ IconAccessory`:
- **`Illustration` é TOKEN** — um NOME (29 nomes), resolve tema light/dark sozinho.
- **`IllustrationAccessory` é ÁTOMO** — consome o token e SÓ o dimensiona. Escala
  fixa `sm/md/lg/xl` = 100/200/300/400 (novo enum `IllustrationSize`), sem `double`
  livre. Recolor de marca por token é interno. Não há mais escape hatch de asset
  cru (`name:` removido) — falta arte, adiciona-se o token.
- **`left.illustration` REMOVIDO** do AppList — ilustração a 40px num row de 72px
  era misuse; esse slot é spotIcon/avatar/iconAccessory/progressRing.

## AppList: row pura + coleção dona do separador (v0.19.0, 2026-07-20)

O separador depende da POSIÇÃO na coleção — e uma row não pode saber se é a
última. Só a coleção sabe. Antes havia 3 mecanismos concorrentes (row.position,
AppListGroup, DayGroup) e `solo`/`bottom` renderizavam idênticos (redundância).

Novo modelo (uma responsabilidade, um dono):
- **`AppListRow`** — a row PURA (Left · Middle · Right). Sem `position`, não
  desenha separador, renderizável sozinha.
- **`AppList`** (coleção, dona ÚNICA do separador), construtores nomeados:
  - `.carded(children, title?)` — card com stroke externo + radius + padding;
    divisor entre rows, nenhum no último.
  - `.plain(children, title?)` — SEM stroke externo; divisor entre rows, nenhum
    no último.
  - `.menu(children, title?)` — sem stroke; divisor sob CADA row (item único
    tem linha).
- **Deletados:** enum `CpfSeguroAppListPosition` e `CpfSeguroAppListGroup`
  (absorvido em `.carded`). `AppListDayGroup` mantido (grupo flat por dia).
- Fundo light do catálogo/SIM = branco puro (divisor `#ECECEC` some sobre
  `#F6F6F6`).

Adoção no app (`ds.AppListRow`/`ds.AppList.*`) é migração à parte — o app pina
o DS em `ref` git, então bumpa a versão + migra os call-sites numa leva.

## Migração da fonte de ícones (app, FECHADA 2026-07-20)

O app (`cpf-seguro-real`) saiu 100% da fonte-ícone própria (`CpfSeguroIcons`,
`.ttf` codepoints) e passou a renderizar via `ds.Icon` (SVG/vec do DS). 134
arquivos migrados, mapa de codepoints + 3 `.ttf` + família no pubspec deletados,
`flutter analyze` = 0 erros.

## Como regenerar

Script: enumera `class CpfSeguroX extends (Stateless|Stateful)Widget` em widgets/,
exclui infra+acessórios, cruza cada nome contra `X(`/`X.` (Preview/Spec), `'Short'`
(Árvore) e `'CpfSeguroX'` (Integração). Rodar a cada leva de mudanças.
