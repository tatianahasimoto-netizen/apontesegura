# Origem e mapeamento de tokens — A Ponte Design System

Este repositório foi **copiado** da arquitetura do [`cpf-seguro-ds`](https://github.com/huntercarmo-diletta/cpf-seguro-ds)
(pipeline Style Dictionary + widgets Flutter) para servir de ponto de partida ao design
system do projeto **A Ponte**. O repositório original **não foi alterado** — apenas
clonado como referência somente-leitura em ambiente local e descartado depois de copiado.

Fonte dos valores novos: variáveis do arquivo Figma "[A Ponte] Design System"
(`fileKey 70i2bXarrpFxzclsPfLa6e`, coleção de variáveis `0.Theme`) e da tela "Home"
do fluxo do app (`fileKey 8KQ5pWXTEFzeSsn5Sx0zR2`).

## O que já foi atualizado nesta cópia

| Arquivo | Mudança |
|---|---|
| `tokens/color.cpf.tokens.json` | `primary01/02/03/04/06` atualizados para os valores reais do A Ponte (`Primary/01,02,03,04,06`). Adicionados `secondary03/06/07`, `commonFg`, `commonBg`, `commonBgMenu`, `brandPrincipal`, `brandOnPrincipal`, `brandAlpha15`. |
| `tokens/role.tokens.json` | `roleLight.bg/bgMenu/fg` agora apontam para `commonBg/commonBgMenu/commonFg` (no A Ponte, `Common/FG` #2B2B2B é diferente de `Neutral/01` #3D3939 — no cpf-seguro eram o mesmo token). `primary`/`onPrimary` agora apontam para `brandPrincipal`/`brandOnPrincipal`. Adicionadas roles novas `secondary`, `secondaryBorder`, `secondarySubtle` (roleLight e roleDark). |
| `tokens/type.tokens.json` | `labelLg.fontWeight` corrigido de 600 → 500 (Label/large do A Ponte é Medium, não SemiBold). |
| `tokens/elevation.tokens.json` | Adicionadas `elevation1` (#00000033, y4/blur10) e `elevation2` (#00000040, y5/blur16), correspondentes às variáveis `Elevation/1` e `Elevation/2` do Figma. |
| `pubspec.yaml`, `package.json` | descrição e `repository` atualizados para o projeto A Ponte / seu repo git. |

Depois de cada edição de token, `npm run tokens` foi rodado para regenerar
`lib/design_system/theme/generated/*.g.dart` e `tokens/generated/cps-tokens.css`.

## Achado importante: fundação compartilhada

A escala **Neutral** (01,02,03,04,06,07,08,10, white, black) e a maior parte da
**tipografia** (`headlineLg/Sm`, `displaySm`, `titleLg/Md/Sm`, `bodyMd/Sm`, `labelMd/Sm`)
já eram **idênticas** entre cpf-seguro-ds e o A Ponte DS — sinal de que os dois design
systems partem da mesma fundação Diletta Solutions. Por isso quase nenhuma mudança foi
necessária nesses grupos.

## TODO — ainda não confirmado a partir do Figma do A Ponte

Estes tokens foram **mantidos com o valor original do cpf-seguro-ds** porque eu não
tinha o valor real do A Ponte no momento desta cópia (não fabriquei nenhum hex).
Confirme cada um no Figma antes de usar em produção:

- `primary05, primary07, primary08, primary09, primaryStateSelected, primaryStateHover`
- `secondary01, secondary02, secondary04, secondary05` (existem no Figma A Ponte, coleção `0.Theme/color/Secondary/*`, só não peguei o hex ainda)
- `neutral05, neutral09` (muito provável que sejam iguais ao cpf-seguro-ds, dado o padrão acima, mas não confirmados)
- Toda a família `warning*`, `success*`, `secure*`/`error01,02,03,05,06,07` — nenhum valor do A Ponte foi coletado para essas; os valores atuais são 100% herdados do cpf-seguro-ds
- `roleDark.*` — nenhum dado de tema escuro do A Ponte foi coletado; os valores de dark mode continuam sendo os do cpf-seguro-ds
- `Brand/Alpha 70`, `Brand/Gradient/Start`, `Brand/Gradient/End`, `Brand/State/Hover`, `Brand/State/Pressed` — variáveis existem no Figma, hex não coletado

## Pendência maior: tipografia usa DUAS famílias de fonte, não uma

O cpf-seguro-ds aplica uma única família (**SF Pro Rounded**) globalmente no wrapper
Dart (`cpf_seguro_typography.dart` / `cpf_seguro_fonts.dart`), com pesos como assets
locais em `assets/fonts/`. O A Ponte usa **duas famílias**:

- `Headline/*` e `Display/*` → **Poppins** (peso SemiBold)
- `Title/*`, `Label/*`, `Body/*` → **Roboto Flex**

Isso não foi mudado automaticamente porque exige: (1) baixar/licenciar os arquivos de
fonte Poppins e Roboto Flex, (2) registrá-los em `pubspec.yaml`, e (3) editar o wrapper
Dart de tipografia para aplicar a família certa por estilo em vez de uma família única.
Ficou como próximo passo manual.

## Também não renomeado (proposital)

O pacote Dart continua se chamando `cpf_seguro_design_system` e os ~90 arquivos em
`lib/design_system/widgets/` continuam com o prefixo `cpf_seguro_*`. Renomear isso é
um refactor mecânico grande (afeta imports em todo o projeto) que você disse que vai
adaptar por conta própria — não mexi para não competir com esse trabalho.
