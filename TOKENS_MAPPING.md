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

**Por que ainda não peguei esses valores:** a ferramenta que uso para ler o Figma só
resolve o hex de uma variável a partir de um nó que a *usa de fato* (uma tela/componente
que aplica aquela cor). Para as variáveis acima eu não encontrei ainda uma tela/frame no
arquivo do fluxo do app ou do DS que as use visivelmente. Listar todas as páginas do
arquivo também não funciona de forma confiável pela API — só enxergo as páginas que já
estão carregadas no Figma Desktop. Se você quiser fechar isso mais rápido, a forma mais
direta é: abrir no Figma Desktop a página/tela que usa essas cores (ex: telas de sucesso,
erro, aviso, ou a página de paleta/cores do DS) e me mandar o link com `node-id` dela —
com isso eu consigo puxar o valor exato na próxima rodada.

## Pendência maior: tipografia usa DUAS famílias de fonte, não uma

O cpf-seguro-ds aplica uma única família (**SF Pro Rounded**) globalmente no wrapper
Dart (`cpf_seguro_typography.dart` / `cpf_seguro_fonts.dart`), com pesos como assets
locais em `assets/fonts/`. O A Ponte usa **duas famílias**:

- `Headline/*` e `Display/*` → **Poppins** (peso SemiBold)
- `Title/*`, `Label/*`, `Body/*` → **Roboto Flex**

**Atualização:** o código já está preparado para isso — `CpfSeguroFonts.familyPoppins`
e `CpfSeguroFonts.familyRobotoFlex` existem, e cada estilo de `CpfSeguroType` já é um
`const TextStyle(...)` literal com o `fontFamily` certo (display/headline → Poppins;
title/label/body → Roboto Flex). Importante: são literais `const`, não
`.copyWith(...)` em cima do gerado — `lib/main.dart` referencia esses campos dentro de
coleções `const`, e `.copyWith` não é const, o que quebrava o build (ver seção de
deploy abaixo). O que falta é só **binário**: baixar/licenciar os
arquivos `.ttf`/`.otf` do Poppins SemiBold e Roboto Flex (Regular/Medium), colocar em
`assets/fonts/` e descomentar o bloco de exemplo já deixado em `pubspec.yaml` (seção
`flutter: fonts:`). Até lá, o Flutter usa o fallback do sistema silenciosamente — não
quebra o build, só não mostra a fonte certa.

## Bugs de deploy corrigidos (Vercel)

Três problemas apareceram nos primeiros builds no Vercel, todos já corrigidos:

1. **`pubspec.yaml` inválido** — `description:` tinha dois-pontos sem aspas, invalidando
   o YAML (`flutter pub get` falhava). Corrigido com string multi-linha (`>-`).
2. **`vercel.json` `buildCommand` estourando o limite de 256 caracteres** da Vercel
   (o comando inline tinha 424). Movido para `vercel-build.sh`, com `buildCommand`
   agora só `bash vercel-build.sh`.
3. **Build do Flutter Web quebrado por `const` inválido** — ao aplicar `fontFamily` via
   `.copyWith(...)` nos estilos de `CpfSeguroType` (ver seção anterior), `dart2js`
   falhava porque `lib/main.dart` usa esses estilos dentro de coleções `const`, e
   `.copyWith` não é const. Corrigido reescrevendo cada estilo como `const TextStyle(...)`
   literal. Confirmado localmente: `flutter build web --release` agora passa da etapa
   de compilação (o único erro restante ao rodar localmente foi um crash do compilador
   de shaders `impellerc`, que parece ser específico deste Mac/sandbox local — não
   deve reproduzir no container Linux do Vercel).

## Também não renomeado (proposital)

O pacote Dart continua se chamando `cpf_seguro_design_system` e os ~90 arquivos em
`lib/design_system/widgets/` continuam com o prefixo `cpf_seguro_*`. Renomear isso é
um refactor mecânico grande (afeta imports em todo o projeto) que você disse que vai
adaptar por conta própria — não mexi para não competir com esse trabalho.
