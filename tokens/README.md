# Design Tokens — pipeline DTCG (V2)

Fonte única de tokens em formato **W3C Design Tokens (DTCG)** → gera Dart
(Flutter) + CSS vars (web) via **Style Dictionary**. Base do multiplataforma:
mesmo significado, mesmas cores, mobile e web.

## Fluxo

```
tokens/*.json (DTCG, fonte)  ──npm run tokens──►  lib/.../generated/cps_color_tokens.g.dart  (Flutter)
                                                   tokens/generated/cps-tokens.css            (web)
```

- Fonte: `tokens/*.tokens.json` — `color.cpf` (primitivos), `radius`, `spacing`,
  `breakpoint`, e `role` (tier 2 semântico: `roleLight` + `roleDark`, refs pros
  primitivos via `{color.x}`). Novos grupos entram como arquivos DTCG aqui.
- Config: `sd.config.mjs` (formatos custom Dart + CSS).
- Rodar: `npm install` (uma vez) e depois `npm run tokens`.
- Saídas são **commitadas** — o build do Vercel (Flutter) NÃO roda o npm; só
  consome o que já está no repo.

## Guardrail

`test/tokens_parity_test.dart` garante que o gerado (DTCG) bate 1:1 com a
`CpfSeguroPalette.cpf` viva. Roda no gate (`flutter test`), então drift entre o
DTCG e o token vivo quebra o build.

## Estado (invertido — L3)

- **`CpfSeguroPalette.cpf` (tier-1) CONSOME o gerado** (`CpfSeguroColorConsts`):
  o DTCG é a fonte única dos primitivos de cor do flavor cpf. O `CpfSeguroScheme`
  (roles, tier-2) lê a Palette, então light/dark também vêm do DTCG.
- Roles (light+dark) modelados em `role.tokens.json` (refs `{color.x}`) → geram
  `cpfSeguroRoleLight/DarkTokensGen` + CSS, com paridade vs `CpfSeguroScheme`.
- **`CpfSeguroColors` também consome o gerado** — os 51 primitivos cobertos pelo
  DTCG viram `Color(CpfSeguroColorConsts.x)`. Ficam literais só os fora do DTCG
  (primary10/neutral11 app-specific, partner, errorBanner/cardDark, transparent)
  e os alphas derivados. Cor primitiva agora tem UMA fonte: o DTCG.
- **Compostos no pipeline + invertidos**:
  - **elevation** (`shadow`) → `CpfSeguroElevationConsts` (`List<BoxShadow>`) + CSS
    box-shadow. Dark/funções/`resolve()` seguem no Dart.
  - **gradients** (`gradient`) → `CpfSeguroGradientConsts` (`LinearGradient`, cores
    por ref) + CSS `linear-gradient` (ângulo computado).
  - **typography** (`typography`) → `CpfSeguroTypeConsts` (`TextStyle`, `height`
    como ratio exato) + CSS type vars. 5 estilos especiais (fontFeatures/cor)
    seguem no Dart.
  - **motion/durations** (`duration`) → `CpfSeguroDurationConsts` + CSS ms. Curvas
    (`Curves.*`) e specs (duração+curva) seguem no Dart.
- Ainda literal (por design): os alphas derivados, curvas de motion, e cores
  fora do DTCG (primary10/neutral11/partner/errorBanner/cardDark/transparent).
- Próximo (fonte a montante): Figma Variables → DTCG (Code Connect), pra o DTCG
  ser editado no Figma em vez de na mão.

## Adicionar tokens

1. Editar/adicionar arquivo DTCG em `tokens/*.json` (leaf = nome do campo).
2. `npm run tokens`.
3. Se for cor da palette, atualizar `CpfSeguroPalette` junto (até a fase F) —
   o teste de paridade avisa se esquecer.
