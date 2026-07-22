# CPF SEGURO — Design System (Flutter)

Widgets Dart/Flutter em paridade 1:1 com o protótipo React em
`~/Desktop/cpf-seguro-app`. **Toda mudança no DS aterrissa aqui.**

## Catálogo visual

O `lib/main.dart` é um app Flutter com **duas abas** no topo:

- **Preview** — cada widget renderizado com exemplos curados (mesma função
  do `/ds` do React). Bom pra "ver como fica em uso".
- **Specs** — instance tables no estilo Figma: matriz completa de variantes
  com brackets/labels nos eixos (linhas × colunas), inspirado no formato do
  próprio Figma DS (`node-id=2281-30785`). Cada célula é uma combinação real
  suportada pelo widget — nada é inventado.

### 3 formas de abrir

**1. Flutter local** (recomendado — precisa instalar `flutter`):

```bash
cd ~/Desktop/cpf-seguro-flutter
flutter pub get
flutter run                 # macOS/iOS/Android — o device que estiver conectado
flutter run -d chrome       # roda no browser (mais rápido pra iterar)
```

**2. DartPad / Zapp.run** (sem instalar nada, direto no browser):

- Abra <https://zapp.run> (suporta packages e assets).
- Cole `pubspec.yaml`, `lib/main.dart`, e a pasta `lib/design_system/` inteira.
- Copie também `assets/icons/` e `assets/logos/`.
- Botão "Run".

**3. Rodar em VS Code / Android Studio**: abra a pasta como projeto Flutter,
pressione F5. Configuração `.vscode/launch.json` opcional já funciona out-of-box.

## Convenções

- Arquivos: `cps_<nome>.dart` (snake_case)
- Classes: `Cps<Nome>` (PascalCase)
- Enums: `Cps<Nome>Size { sm, md, lg }`, `Cps<Nome>Type`, `Cps<Nome>State`
- Tokens sempre via `CpsColors` — nunca hex hardcoded no widget
- Semantics em todo widget interativo

## Estrutura

```
lib/
├── main.dart                                    # App demo — 2 abas (Preview / Specs)
├── spec_table.dart                              # CpsSpecTable helper (brackets + labels)
├── spec_tables.dart                             # 15 spec tables (uma por widget combinatório)
└── design_system/
    ├── cps_design_system.dart                   # Barrel único
    ├── theme/
    │   ├── cps_colors.dart                      # Tokens (7 escalas)
    │   ├── cps_typography.dart                  # 15 estilos M3
    │   └── cps_metrics.dart                     # Spacing / Radius / Motion
    └── widgets/                                 # 24 widgets
assets/
├── icons/                                       # 350 SVGs
└── logos/                                       # logo + logo-full
```

## Componentes disponíveis

| Categoria | Widgets |
|-----------|---------|
| Primitivos | `CpsIcon` `CpsButton` `CpsIconButton` `CpsInput` `CpsCheckbox` `CpsRadioList` |
| Composições | `CpsAction` `CpsStatusTag` `CpsAppList*` `CpsSpotIcon` `CpsAvatar` `CpsOtpInput` `CpsMenuButton` `CpsLogo` |
| DS já existentes | `CpsToggleSwitch` `CpsPageTitle` `CpsMenuSection` `CpsLoadingSpinner` |
| Containers | `CpsTopAppBar*` `CpsBottomHomeIndicator` `CpsBottomActionBar` `CpsBottomNav` `CpsToast` |
| Chat | `CpsChatBubble` `CpsChatCriteriaBubble` `CpsChatTypingIndicator` `CpsChatScroll` `CpsChatHeader` `CpsChatProgress` `CpsChatTopBar` `CpsCobrandMark` |
| Cobranding | `CpsCobrandedBadge` |

## Import

```dart
import 'package:cpf_seguro_design_system/cpf_seguro_design_system.dart';
```

Entrypoint público único — tokens, roles, widgets e o primitivo `CpfSeguroSurface`.
O scaffolding do catálogo (main.dart, spec_tables, telas) não faz parte da API.

## Uso como package (no app)

O DS é consumido via git ref (código é a fonte por ora — ver `DS_CONSOLIDATION_PLAN.md`).

1. No `pubspec.yaml` do app:

```yaml
dependencies:
  cpf_seguro_design_system:
    git:
      url: https://github.com/huntercarmo-diletta/cpf-seguro-ds.git
      ref: v0.1.0
```

2. Aplicar a fonte empacotada (SF Pro Rounded) uma vez, no tema:

```dart
import 'package:cpf_seguro_design_system/cpf_seguro_design_system.dart';

MaterialApp(
  theme: ThemeData(fontFamily: CpfSeguroFonts.family),
  // ...
);
```

3. Envolver a árvore com o `CpfSeguroTheme` (scheme light/dark) e usar os widgets.

Assets (ícones, logos, ilustrações) e a fonte já vêm bundlados pelo package.

## Versão

`v0.1.0` — primeira versão empacotada. Tokens sob fonte única (DTCG → Dart/CSS,
gated por testes de paridade e contraste). Changelog em commits/tags.
