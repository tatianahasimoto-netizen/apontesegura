# Figma Variables — fonte de registro + reconciliação

Exports DTCG das Variables do Figma ("CPF Seguro Design System"). Esta pasta é a
**fonte de registro** dos tokens. Ainda **não** está ligada ao Style Dictionary
(o pipeline lê `tokens/*.json`, não `tokens/figma/**`) — ligar é o próximo passo,
depois de decidir a convenção de nomes.

## Coleções

| Arquivo | Tier | Conteúdo |
|---|---|---|
| `Palette 01/*` | primitivo | 4 flavors (CPF Seguro, Diletta, Red, Rose), cada um com modes Light/Dark; grupos Common/Logo/Brand/Neutral/Error/Primary/Warning/Success |
| `0.Theme/{Light,Dark}` | semântico | scheme por mode (= CpfSeguroScheme) |
| `Cotainers/Mode 1` | dimensão | Corner radius (9), Spacing (17), **Containers sm/md/lg/xl (breakpoints)** |
| `Elevation/Mode` | sombra | position-x/y, blur, spread + Light/Dark |
| `Typescale/Mode 1` | tipografia | grade M3 completa |
| `Typeface/Baseline` | tipografia | Weight (3) + baseline |
| `Icons/{Light,Solid}` | ícone | 154 × 2 |
| `Icontype/*` | ícone | wrapper |
| `Illustration/Default` | ilustração | 26 tokens |

Formato: DTCG rico — cor = `{$type:color, $value:{colorSpace, components, alpha,
hex}, $extensions:{com.figma.variableId}}`. O `variableId` é estável (habilita
Code Connect / round-trip).

## Reconciliação (mão dupla) — palette CPF

Diff código (`CpfSeguroPalette.cpf`) × Figma CPF/Light. **Zero conflito de
valor**: todo token compartilhado é idêntico. Integração é aditiva nos dois lados.

### Compartilhado, idêntico
`primary01–07`, `neutral01–10` + white/black, `error01–07`, `warning01–07`,
`success01–07`.

### Só no código → adicionar no Figma
- **Família `secure`** (inteira): `secure02 #625500`, `secure03 #DABD00`,
  `secure04 #E5B73A`, `secure05 #F5CC2C`, `secure07 #FFF7D6`, `secure08 #FFFADC`.
- **Primary extra**: `primary08 #F2F5FF`, `primary09 #F8FAFF`.
- **Primary states**: `primaryStateSelected #E0E8FF`, `primaryStateHover #EBF0FF`.

### Só no Figma → trazer pro código
- Grupo **Brand** (Principal, OnPrincipal, Alpha/Alpha15/Alpha70, Gradient
  Start/End, State), **Common** (BG/BGMenu/FG), **Logo** (Colour 01–03, Mono 01).
- **4 flavors** (código só tem `cpf`; `CpfSeguroPalette.all` já previa multi).
- **Modes Light/Dark** dentro da palette.
- **Containers/breakpoints** (sm/md/lg/xl) — o primitivo que falta pro DS web.
- Radius (9) e Spacing (17) mais granulares; Elevation decomposto; Typescale M3;
  **26 ilustrações** (código implementa 2).

## Mapa de nomes (Figma → código)

| Figma | Código |
|---|---|
| `Primary/04` | `primary04` |
| `Neutral/01`, `Neutral/White`, `Neutral/Black` | `neutral01`, `white`, `black` |
| `Error/04`, `Warning/04`, `Success/04` | `error04`, `warning04`, `success04` |
| `Brand/Principal` | `primary` (scheme) |
| `Brand/OnPrincipal` | `onPrimary` |
| `Common/BG`, `Common/FG` | `bg`, `fg` (scheme) |
| `Corner radius/N` | `CpfSeguroRadius.rN` |
| `Spacing/N` | `CpfSeguroSpacing.sN` |

Convenção: Figma `TitleCase/Família/Variante` (termos pt) → código camelCase EN.

## Próximos passos

1. **Decidir a convenção de nomes** do DTCG unificado (manter EN do código com
   mapa Figma→EN, ou adotar os nomes do Figma). Gate do pipeline.
2. Ligar o Style Dictionary nestes arquivos (parse do formato rico, modes,
   multi-flavor), preservando as adições do código (secure, primary08/09, states).
3. Time adiciona no Figma: `secure`, `primary08/09`, `primaryStateSelected/Hover`.
