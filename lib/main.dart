import 'package:flutter/material.dart';

import 'design_system/cpf_seguro_design_system.dart';
import 'ds_tree_screen.dart';
import 'grammar_screen.dart';
import 'parity_screen.dart';
import 'spec_tables.dart';
import 'tokens_screen.dart';

void main() {
  runApp(const _CatalogApp());
}

class _CatalogApp extends StatelessWidget {
  const _CatalogApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPF SEGURO · DS Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Rounded',
        scaffoldBackgroundColor: CpfSeguroColors.neutral10,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: CpfSeguroColors.neutral01)),
      ),
      home: const _CatalogHome(),
    );
  }
}

class _CatalogHome extends StatefulWidget {
  const _CatalogHome();
  @override
  State<_CatalogHome> createState() => _CatalogHomeState();
}

/// IA no padrão Material 3 (m3.material.io): Foundations → Styles → Components,
/// mais os handoffs (Specs, SDK) e o tracker de Integração.
enum _Tab { foundations, styles, components, specs, integracao }

class _CatalogHomeState extends State<_CatalogHome> {
  _Tab _tab = _Tab.components;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CpfSeguroColors.neutral10,
        body: Column(
          children: [
            _TabBar(active: _tab, onTap: (t) => setState(() => _tab = t)),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    switch (_tab) {
      case _Tab.foundations:
        return const _FoundationsScreen();
      case _Tab.styles:
        return const _StylesScreen();
      case _Tab.components:
        return const _CatalogScreen();
      case _Tab.integracao:
        return const ParityScreen();
      case _Tab.specs:
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: CpfSeguroColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SpecTablesScreen(),
            ),
          ),
        );
    }
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.active, required this.onTap});
  final _Tab active;
  final ValueChanged<_Tab> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        border: Border(bottom: BorderSide(color: CpfSeguroColors.neutral09)),
      ),
      child: Row(
        children: [
          const Text(
            'CPS · Design System',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CpfSeguroColors.primary04,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 24),
          _TabButton(label: 'Foundations', selected: active == _Tab.foundations, onTap: () => onTap(_Tab.foundations)),
          const SizedBox(width: 4),
          _TabButton(label: 'Styles', selected: active == _Tab.styles, onTap: () => onTap(_Tab.styles)),
          const SizedBox(width: 4),
          _TabButton(label: 'Components', selected: active == _Tab.components, onTap: () => onTap(_Tab.components)),
          const SizedBox(width: 4),
          _TabButton(label: 'Specs', selected: active == _Tab.specs, onTap: () => onTap(_Tab.specs)),
          const SizedBox(width: 4),
          _TabButton(label: 'Integração', selected: active == _Tab.integracao, onTap: () => onTap(_Tab.integracao)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? CpfSeguroColors.primaryStateSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.neutral03,
            ),
          ),
        ),
      ),
    );
  }
}

/// Categorias de componentes no padrão Material 3 (agrupamento por FUNÇÃO).
/// O eixo atômico (token→átomo→molécula→organismo) segue vivo em Foundations
/// (Árvore + Gramática) e nos chips "compõe:" de cada seção.
enum _Cat { actions, inputs, selection, communication, containment, navigation, domain }

extension _CatMeta on _Cat {
  String get label => switch (this) {
        _Cat.actions => 'Actions',
        _Cat.inputs => 'Text inputs',
        _Cat.selection => 'Selection',
        _Cat.communication => 'Communication',
        _Cat.containment => 'Containment',
        _Cat.navigation => 'Navigation',
        _Cat.domain => 'CPF · domínio',
      };
}

/// Shell comum das telas de catálogo — card centrado maxWidth 980, header +
/// sub-nav + seções. Reusado por Styles e Components.
Widget _catalogCard({
  required String title,
  required String subtitle,
  required Widget subnav,
  required List<Widget> sections,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: CpfSeguroColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(title: title, subtitle: subtitle),
              subnav,
              ...sections,
            ],
          ),
        ),
      ),
    ),
  );
}

/// FOUNDATIONS (M3) — como o sistema se compõe (Gramática) + o mapa de
/// dependências (Árvore). É o "porquê" do sistema, na linguagem do DS.
class _FoundationsScreen extends StatefulWidget {
  const _FoundationsScreen();
  @override
  State<_FoundationsScreen> createState() => _FoundationsScreenState();
}

class _FoundationsScreenState extends State<_FoundationsScreen> {
  int _view = 0; // 0 = Gramática, 1 = Árvore

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 12),
          child: Wrap(
            spacing: 8,
            children: [
              _NavPill(label: 'Gramática', selected: _view == 0, onTap: () => setState(() => _view = 0)),
              _NavPill(
                  label: 'Árvore de dependências',
                  selected: _view == 1,
                  onTap: () => setState(() => _view = 1)),
            ],
          ),
        ),
        Expanded(child: _view == 0 ? const GrammarScreen() : const DsTreeScreen()),
      ],
    );
  }
}

/// STYLES (M3) — os tokens: scheme, palette, ícones, ilustração, elevação,
/// raio, spacing, tipografia e motion. O material bruto do sistema.
class _StylesScreen extends StatelessWidget {
  const _StylesScreen();

  @override
  Widget build(BuildContext context) {
    return _catalogCard(
      title: 'Styles · Tokens',
      subtitle: 'O material bruto do sistema (M3 Styles). O Scheme resolve a '
          'Palette; elevação, raio, spacing, tipografia, ícones e motion são os '
          'tokens que todo componente consome — nunca valores crus.',
      subnav: const SizedBox.shrink(),
      sections: const [
        _TokenPipelineBanner(),
        _SchemeSection(),
        _ColorsSection(),
        _IconSection(),
        _IllustrationSection(),
        _ElevationSection(),
        _ShadowsSection(),
        _GradientsSection(),
        _RadiusSection(),
        _SpacingSection(),
        _TypographySection(),
        _MotionSection(),
      ],
    );
  }
}

/// L3 · banner do pipeline DTCG no topo do Styles — documenta que os tokens são
/// FONTE ÚNICA (DTCG) → gerados pra Dart (mobile) + CSS (web), com guard de paridade.
class _TokenPipelineBanner extends StatelessWidget {
  const _TokenPipelineBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CpfSeguroColors.primary08,
          borderRadius: CpfSeguroRadius.all16,
          border: Border.all(color: CpfSeguroColors.primary07),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FONTE ÚNICA · PIPELINE DTCG',
                style: CpfSeguroType.labelSm.copyWith(
                    color: CpfSeguroColors.primary04,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                _PipeStage('tokens/*.json', 'DTCG (fonte)'),
                _PipeArrow(),
                _PipeStage('Style Dictionary', 'npm run tokens'),
                _PipeArrow(),
                _PipeStage('Dart + CSS', 'mobile · web'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Editar um token = editar o JSON + `npm run tokens` → propaga pra '
              'Dart (Palette/Scheme/Elevation/Type…) e CSS de uma vez. O teste de '
              'paridade trava drift no gate. Vêm daqui: cor, roles (light/dark), '
              'radius/spacing, elevation, gradients, typography e motion.',
              style: CpfSeguroType.bodySm
                  .copyWith(color: CpfSeguroColors.primary03, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipeStage extends StatelessWidget {
  const _PipeStage(this.title, this.sub);
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all8,
        border: Border.all(color: CpfSeguroColors.primary07),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: CpfSeguroType.labelMd.copyWith(
                  color: CpfSeguroColors.neutral01, fontWeight: FontWeight.w700)),
          Text(sub,
              style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        ],
      ),
    );
  }
}

class _PipeArrow extends StatelessWidget {
  const _PipeArrow();
  @override
  Widget build(BuildContext context) {
    return Text('→',
        style: CpfSeguroType.title.copyWith(color: CpfSeguroColors.primary04));
  }
}

/// COMPONENTS (M3) — componentes agrupados por função, com sub-nav de categoria.
class _CatalogScreen extends StatefulWidget {
  const _CatalogScreen();
  @override
  State<_CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<_CatalogScreen> {
  _Cat _cat = _Cat.actions;

  @override
  Widget build(BuildContext context) {
    return _catalogCard(
      title: 'Components',
      subtitle: 'Componentes agrupados por função (Material 3). Cada seção traz '
          'o preview vivo, o papel semântico e os chips "compõe:" (as peças que '
          'o componente consome). O eixo atômico completo vive em Foundations.',
      subnav: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in _Cat.values)
              _NavPill(label: c.label, selected: c == _cat, onTap: () => setState(() => _cat = c)),
          ],
        ),
      ),
      sections: _sectionsFor(_cat),
    );
  }

  List<Widget> _sectionsFor(_Cat c) {
    switch (c) {
      case _Cat.actions:
        return const [
          _ButtonsSection(),
          _IconButtonsSection(),
          _NavigationButtonSection(),
          _MenuButtonSection(),
          _ActionSection(),
        ];
      case _Cat.inputs:
        return const [
          _InputsSection(),
          _SearchInputSection(),
          _ChatInputSection(),
          _OtpSection(),
        ];
      case _Cat.selection:
        return const [
          _CheckboxSection(),
          _ToggleSwitchSection(),
          _RadioListSection(),
          _InputChipSection(),
          _PickersSection(),
          _KeyboardSection(),
        ];
      case _Cat.communication:
        return const [
          _MacroHeader('STATUS & TAGS'),
          _StatusTagSection(),
          _InfoChipSection(),
          _OfflinePillSection(),
          _MacroHeader('FEEDBACK'),
          _ToastSection(),
          _TooltipSection(),
          _MacroHeader('LOADING & PROGRESSO'),
          _LoadingSpinnerSection(),
          _SkeletonSection(),
        ];
      case _Cat.containment:
        return const [
          _MacroHeader('SUPERFÍCIE'),
          _GlassSurfaceSection(),
          _MacroHeader('CARDS'),
          _FeatureCardSection(),
          _InfoCardSection(),
          _QuickAccessCardSection(),
          _MacroHeader('LISTAS & LINHAS'),
          _AppListSection(),
          _DayGroupSection(),
          _DetailRowSection(),
          _CriteriaListSection(),
          _EmptyStateSection(),
          _MacroHeader('SHEETS'),
          _SheetsSection(),
        ];
      case _Cat.navigation:
        return const [
          _MacroHeader('TOP'),
          _TopAppBarSection(),
          _NavigationTopBarSection(),
          _NavigationLeftAccessorySection(),
          _NavigationRightAccessorySection(),
          _StepperSection(),
          _StatusBarSection(),
          _MacroHeader('BOTTOM'),
          _BottomAppSection(),
          _NavSection(),
          _BottomHomeIndicatorSection(),
        ];
      case _Cat.domain:
        return const [
          _MacroHeader('IDENTIDADE & ÍCONES'),
          _IconAccessorySection(),
          _SpotIconSection(),
          _LogoSection(),
          _AvatarSection(),
          _MacroHeader('TEXTO'),
          _PageTitleSection(),
          _SectionHeaderSection(),
          _MacroHeader('VALOR & CARTEIRA'),
          _AmountSection(),
          _AmountDisplaySection(),
          _ReceiptSection(),
          _MacroHeader('CONFIANÇA'),
          _FaceIdCardSection(),
          _MacroHeader('CHAT'),
          _ChatSection(),
        ];
    }
  }
}

/// Pílula genérica de sub-navegação (categoria de componente / view).
class _NavPill extends StatelessWidget {
  const _NavPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.white,
            borderRadius: CpfSeguroRadius.pillAll,
            border: Border.all(
              color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.neutral08,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: CpfSeguroType.labelMd.copyWith(
              color: selected ? CpfSeguroColors.white : CpfSeguroColors.neutral03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Divisor de macro-grupo DENTRO de uma camada (mais leve que _TierHeader).
class _MacroHeader extends StatelessWidget {
  const _MacroHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 0),
      child: Row(
        children: [
          Text(
            label,
            style: CpfSeguroType.labelSm.copyWith(
              color: CpfSeguroColors.primary04,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: CpfSeguroColors.neutral09)),
        ],
      ),
    );
  }
}

/// Seção TOKENS que mostra o Scheme semântico (light/dark) do tier 2/3.
class _SchemeSection extends StatelessWidget {
  const _SchemeSection();

  @override
  Widget build(BuildContext context) {
    return const _Section(
      title: 'SCHEME · semântica light & dark (o que os widgets consomem)',
      composedOf: ['Palette', 'Theme'],
      child: CpfSchemeShowcase(),
    );
  }
}

/// Seção ATOMS — IconAccessory: o átomo do ícone (box consistente com padding
/// 2 + slot de badge). Consome o token Icon.
class _IconAccessorySection extends StatelessWidget {
  const _IconAccessorySection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ICONACCESSORY · o átomo do ícone (box + slot de badge · consome o token Icon)',
      specId: 'design-system-icon-accessory',
      whenUse: 'o átomo que padroniza QUALQUER ícone: box consistente + padding + '
          'slot de badge. Todo componente roteia o ícone por aqui.',
      dos: const [
        'Rotear todo ícone por IconAccessory (nunca o glyph cru).',
        'Badge no slot próprio (não sobreposto na mão).',
      ],
      donts: const [
        'Montar Icon/glyph cru direto numa tela.',
        'Tamanhos de box aleatórios — use o padrão do átomo.',
      ],
      role: 'O átomo do ícone: box consistente + padding + slot de badge. Todo componente roteia o ícone por aqui, nunca o glyph cru.',
      composedOf: const ['Icon'],
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CpfSeguroIconAccessory(icon: CpfSeguroIcons.houseLight, size: 32, color: CpfSeguroColors.primary04),
          CpfSeguroIconAccessory(icon: CpfSeguroIcons.fingerprintLight, size: 32, color: CpfSeguroColors.neutral05),
          CpfSeguroIconAccessory(
              icon: CpfSeguroIcons.idCardLight, size: 32, color: CpfSeguroColors.primary04, badge: CpfSeguroBadge.danger),
          CpfSeguroIconAccessory(
              icon: CpfSeguroIcons.walletLight, size: 32, color: CpfSeguroColors.neutral05, badge: CpfSeguroBadge.primary),
        ],
      ),
    );
  }
}

/// Seção TOKENS — Elevation: as 7 sombras NOMEADAS (o que os widgets usam).
class _ElevationSection extends StatelessWidget {
  const _ElevationSection();

  static const _items = <(String, List<BoxShadow>, String)>[
    ('low', CpfSeguroElevation.low, 'card / nav base'),
    ('medium', CpfSeguroElevation.medium, 'card flutuante'),
    ('soft', CpfSeguroElevation.soft, 'toast'),
    ('overlay', CpfSeguroElevation.overlay, 'tooltip'),
    ('overlayLg', CpfSeguroElevation.overlayLg, 'dev inspect / popover largo'),
    ('keyPress', CpfSeguroElevation.keyPress, 'tecla do numpad'),
    ('brandLow', CpfSeguroElevation.brandLow, 'chat button'),
    ('brandMedium', CpfSeguroElevation.brandMedium, 'banner'),
    ('brandHigh', CpfSeguroElevation.brandHigh, 'completion card'),
    ('brandSoft', CpfSeguroElevation.brandSoft, 'nav item ativo'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ELEVATION · 7 sombras nomeadas (4 neutras + 3 brand) — o que os widgets consomem',
      composedOf: const ['Color'],
      child: Wrap(
        spacing: 28,
        runSpacing: 28,
        children: [
          for (final it in _items)
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: CpfSeguroColors.white,
                      borderRadius: CpfSeguroRadius.all16,
                      boxShadow: it.$2,
                      border: Border.all(color: CpfSeguroColors.neutral09),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(it.$1,
                      style: CpfSeguroType.labelSm
                          .copyWith(color: CpfSeguroColors.neutral02, fontWeight: FontWeight.w600)),
                  Text(it.$3, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Seção TOKENS — Spacing: a escala base-4 (4 → 48).
class _SpacingSection extends StatelessWidget {
  const _SpacingSection();

  // Significado derivado do uso (contagem real no DS): s4 e s6 dominam.
  static const _scale = <(String, String, double)>[
    ('s0_5 · 2', 'Micro — hairline, separação mínima.', CpfSeguroSpacing.s0_5),
    ('s1 · 4', 'Gap curtíssimo — dentro da StatusTag, ícone colado ao texto.', CpfSeguroSpacing.s1),
    ('s1_5 · 6', 'Meio-passo — padding off-scale de chip.', CpfSeguroSpacing.s1_5),
    ('s2 · 8', 'Gap apertado — ícone↔label, padding de chip, entre rows.', CpfSeguroSpacing.s2),
    ('s3 · 12', 'Gap médio — avatar↔texto, entre elementos de um bloco.', CpfSeguroSpacing.s3),
    ('s4 · 16', 'O gap de trabalho — entre campos, padding interno de card.', CpfSeguroSpacing.s4),
    ('s5 · 20', 'Raro — meio-termo entre 16 e 24.', CpfSeguroSpacing.s5),
    ('s6 · 24', 'Margem da tela e entre seções — o respiro grande.', CpfSeguroSpacing.s6),
    ('s8 · 32', 'Respiro entre blocos grandes.', CpfSeguroSpacing.s8),
    ('s10 · 40', 'Espaço generoso — topo de tela, antes de um CTA.', CpfSeguroSpacing.s10),
    ('s12 · 48', 'Raro — separação máxima.', CpfSeguroSpacing.s12),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SPACING · escala base-4 (4 → 48) · s4=16 é o edge padding padrão',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in _scale)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(s.$1,
                        style: CpfSeguroType.labelSm.copyWith(
                            color: CpfSeguroColors.neutral03, fontWeight: FontWeight.w600)),
                  ),
                  // Track fixo (48 = o maior valor) com a barra proporcional em
                  // cima — assim a escala 2→48 lê de forma inequívoca, alinhada.
                  Container(
                    width: 48,
                    height: 16,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: CpfSeguroColors.neutral09,
                      borderRadius: CpfSeguroRadius.all2,
                    ),
                    child: Container(
                      width: s.$3,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: CpfSeguroColors.primary04,
                        borderRadius: CpfSeguroRadius.all2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(s.$2,
                        style: CpfSeguroType.bodySm.copyWith(
                            color: CpfSeguroColors.neutral04, height: 1.3)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Header + section frame
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({
    this.title = 'Design System · Catálogo',
    this.subtitle = 'Referência canônica Flutter/Dart. Toda mudança estética do '
        'DS aterrissa aqui — o app apenas delega.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.only(bottom: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CpfSeguroColors.neutral09)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CpfSeguroType.headlineSm.copyWith(
                color: CpfSeguroColors.neutral01,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, height: 20 / 14, color: CpfSeguroColors.neutral03),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotionSection extends StatefulWidget {
  const _MotionSection();
  @override
  State<_MotionSection> createState() => _MotionSectionState();
}

class _MotionSectionState extends State<_MotionSection> {
  int _run = 0;

  static const List<(String, String, CpfSeguroMotionSpec)> _ctx = [
    ('fade', 'short 150 · enter', CpfSeguroMotion.fade),
    ('sheet', 'medium 250 · enter', CpfSeguroMotion.sheet),
    ('toast', 'medium 250 · enter', CpfSeguroMotion.toast),
    ('page', 'slow 400 · standard', CpfSeguroMotion.page),
    ('control', 'short 150 · enter', CpfSeguroMotion.control),
    ('emphasis', 'deliberate 600 · emphasized', CpfSeguroMotion.emphasis),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'MOTION · duração + easing amarrados por contexto',
      role: 'Fonte única do movimento. O componente consome um CONTEXTO '
          '(fade/sheet/page/control/toast/emphasis) que já traz duração + curva '
          '— nunca um Duration/Curve solto. Toque "Reproduzir".',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: CpfSeguroButton(
              label: 'Reproduzir',
              type: CpfSeguroButtonType.secondary,
              size: CpfSeguroButtonSize.sm,
              onPressed: () => setState(() => _run++),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final (name, label, spec) in _ctx)
                _MotionTile(name: name, label: label, spec: spec, run: _run),
            ],
          ),
          const SizedBox(height: 24),
          Text('Presets & transição (consomem os contextos)',
              style: CpfSeguroType.labelSm
                  .copyWith(color: CpfSeguroColors.neutral02)),
          const SizedBox(height: 8),
          Text(
            'Animation · topNotification · bottomSheet · scrim · slideInRight · '
            'slideOutRight · fadeIn (posicionamento embutido — fixed-position '
            'pede Stack ancestral).',
            style:
                CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
          ),
          const SizedBox(height: 12),
          const CpfSeguroAnimation(
            preset: CpfSeguroAnimationPreset.fadeIn,
            child: CpfSeguroStatusTag(
                label: 'fadeIn demo', tone: CpfSeguroStatusTone.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'ScreenTransition · troca de pageKey desliza forward/back (contexto '
            'page). Shell de navegação das telas de handoff.',
            style:
                CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
          ),
        ],
      ),
    );
  }
}

class _MotionTile extends StatelessWidget {
  const _MotionTile(
      {required this.name,
      required this.label,
      required this.spec,
      required this.run});
  final String name;
  final String label;
  final CpfSeguroMotionSpec spec;
  final int run;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: CpfSeguroType.labelSm
                  .copyWith(color: CpfSeguroColors.neutral02)),
          Text(label,
              style: CpfSeguroType.caption
                  .copyWith(color: CpfSeguroColors.neutral04)),
          const SizedBox(height: 8),
          Container(
            height: 44,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: CpfSeguroColors.neutral10,
                borderRadius: CpfSeguroRadius.all8),
            child: TweenAnimationBuilder<double>(
              key: ValueKey('$name-$run'),
              tween: Tween(begin: 0, end: 1),
              duration: spec.duration,
              curve: spec.curve,
              builder: (context, t, child) => Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(t * 152, 0),
                  child: Opacity(
                      opacity: (0.25 + 0.75 * t).clamp(0.0, 1.0), child: child),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(6),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: CpfSeguroColors.primary04,
                    borderRadius: CpfSeguroRadius.all8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.role,
    this.composedOf,
    this.whenUse,
    this.dos,
    this.donts,
    this.specId,
  });

  final String title;
  final Widget child;

  /// Papel semântico do componente — o que ele É e QUANDO usar, derivado do
  /// uso real (onde ele aparece nas telas). A "linguagem" do componente.
  final String? role;

  /// Widgets do DS que ESTE consome como building blocks.
  /// Renderizado como chips abaixo do título ("compõe: X, Y, Z").
  /// Deixa null pra átomos/tokens sem dependência.
  final List<String>? composedOf;

  /// L2 · Guidelines de uso (padrão Polaris/Spectrum/M3). O bloco "quando usar /
  /// do & don't" é o que faz HUMANO entender o significado, além da máquina.
  /// [whenUse] = uma linha de quando aplicar. [dos]/[donts] = práticas.
  final String? whenUse;
  final List<String>? dos;
  final List<String>? donts;

  /// L2 · id da spec OpenSpec (contrato) deste componente, se houver.
  /// Ex: 'design-system-button' → openspec/specs/design-system-button/spec.md.
  final String? specId;

  bool get _hasGuidelines =>
      whenUse != null ||
      (dos != null && dos!.isNotEmpty) ||
      (donts != null && donts!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    // Divisão clara entre componentes: hairline no topo + respiro generoso, e o
    // nome do componente como heading. Separa visualmente cada item da lista.
    final parts = title.split(' · ');
    final name = parts.first;
    final meta = parts.length > 1 ? parts.sublist(1).join(' · ') : null;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: CpfSeguroColors.neutral09),
          const SizedBox(height: 24),
          Text(
            name,
            style: CpfSeguroType.subheading.copyWith(
              color: CpfSeguroColors.neutral01,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          if (meta != null) ...[
            const SizedBox(height: 3),
            Text(
              meta,
              style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05),
            ),
          ],
          if (role != null) ...[
            const SizedBox(height: 8),
            Text(
              role!,
              style: CpfSeguroType.bodySm
                  .copyWith(color: CpfSeguroColors.neutral02, height: 1.4),
            ),
          ],
          // Guidelines logo após o título (antes do preview): quando usar +
          // faça/evite + contrato. É o "como falar" antes de "ver".
          if (_hasGuidelines) ...[
            const SizedBox(height: 16),
            _GuidelinesBlock(
                whenUse: whenUse, dos: dos, donts: donts, specId: specId),
          ],
          if (composedOf != null && composedOf!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Text('compõe:',
                    style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
                for (final w in composedOf!) _DepChip(name: w),
              ],
            ),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

/// L2 · bloco de guidelines de uso — "quando usar" + do/don't lado a lado +
/// link do contrato (spec OpenSpec). Padrão Polaris/Spectrum/M3.
class _GuidelinesBlock extends StatelessWidget {
  const _GuidelinesBlock({this.whenUse, this.dos, this.donts, this.specId});
  final String? whenUse;
  final List<String>? dos;
  final List<String>? donts;
  final String? specId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CpfSeguroColors.neutral10,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('GUIDELINES',
                  style: CpfSeguroType.labelSm.copyWith(
                      color: CpfSeguroColors.neutral04,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
              if (specId != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CpfSeguroColors.primary08,
                    borderRadius: CpfSeguroRadius.all200,
                  ),
                  child: Text('contrato · $specId',
                      style: CpfSeguroType.labelSm
                          .copyWith(color: CpfSeguroColors.primary04)),
                ),
              ],
            ],
          ),
          if (whenUse != null) ...[
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Quando usar  ',
                    style: CpfSeguroType.bodySm.copyWith(
                        color: CpfSeguroColors.neutral04,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                    text: whenUse,
                    style: CpfSeguroType.bodySm
                        .copyWith(color: CpfSeguroColors.neutral02, height: 1.4)),
              ]),
            ),
          ],
          if ((dos != null && dos!.isNotEmpty) ||
              (donts != null && donts!.isNotEmpty)) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _DoDontColumn(
                        title: 'Faça',
                        items: dos ?? const [],
                        good: true)),
                const SizedBox(width: 24),
                Expanded(
                    child: _DoDontColumn(
                        title: 'Evite',
                        items: donts ?? const [],
                        good: false)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DoDontColumn extends StatelessWidget {
  const _DoDontColumn(
      {required this.title, required this.items, required this.good});
  final String title;
  final List<String> items;
  final bool good;

  @override
  Widget build(BuildContext context) {
    final color = good ? CpfSeguroColors.success04 : CpfSeguroColors.error04;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          CpfSeguroIconAccessory(
            icon: good ? CpfSeguroIcons.circleCheckLight : CpfSeguroIcons.xmarkLight,
            padding: 0,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(title,
              style: CpfSeguroType.labelMd
                  .copyWith(color: color, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        for (final it in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('· $it',
                style: CpfSeguroType.bodySm
                    .copyWith(color: CpfSeguroColors.neutral03, height: 1.35)),
          ),
        if (items.isEmpty)
          Text('—',
              style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral06)),
      ],
    );
  }
}

/// Chip que representa uma dependência (widget usado como building block).
class _DepChip extends StatelessWidget {
  const _DepChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CpfSeguroColors.neutral10,
        borderRadius: CpfSeguroRadius.all8,
        border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
      ),
      child: Text(
        name,
        style: CpfSeguroType.labelSm.copyWith(
          color: CpfSeguroColors.neutral03,
          fontFamily: 'monospace',
          letterSpacing: 0,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Colors
// ═══════════════════════════════════════════════════════════════════════════

class _ColorsSection extends StatelessWidget {
  const _ColorsSection();

  static const _palettes = <(String, List<(String, Color)>)>[
    (
      'PRIMARY',
      [
        ('primary-01', CpfSeguroColors.primary01),
        ('primary-02', CpfSeguroColors.primary02),
        ('primary-03', CpfSeguroColors.primary03),
        ('primary-04', CpfSeguroColors.primary04),
        ('primary-05', CpfSeguroColors.primary05),
        ('primary-06', CpfSeguroColors.primary06),
        ('primary-07', CpfSeguroColors.primary07),
        ('primary-08', CpfSeguroColors.primary08),
      ]
    ),
    (
      'NEUTRAL',
      [
        ('neutral-01', CpfSeguroColors.neutral01),
        ('neutral-02', CpfSeguroColors.neutral02),
        ('neutral-03', CpfSeguroColors.neutral03),
        ('neutral-04', CpfSeguroColors.neutral04),
        ('neutral-05', CpfSeguroColors.neutral05),
        ('neutral-06', CpfSeguroColors.neutral06),
        ('neutral-07', CpfSeguroColors.neutral07),
        ('neutral-08', CpfSeguroColors.neutral08),
        ('neutral-09', CpfSeguroColors.neutral09),
        ('neutral-10', CpfSeguroColors.neutral10),
        ('white', CpfSeguroColors.white),
        ('black', CpfSeguroColors.black),
        ('blackAlpha20', CpfSeguroColors.blackAlpha20),
        ('blackAlpha40', CpfSeguroColors.blackAlpha40),
        ('transparent', CpfSeguroColors.transparent),
      ]
    ),
    (
      'ERROR',
      [
        ('error-01', CpfSeguroColors.error01),
        ('error-02', CpfSeguroColors.error02),
        ('error-03', CpfSeguroColors.error03),
        ('error-04', CpfSeguroColors.error04),
        ('error-05', CpfSeguroColors.error05),
        ('error-06', CpfSeguroColors.error06),
        ('error-07', CpfSeguroColors.error07),
      ]
    ),
    (
      'SUCCESS',
      [
        ('success-01', CpfSeguroColors.success01),
        ('success-02', CpfSeguroColors.success02),
        ('success-03', CpfSeguroColors.success03),
        ('success-04', CpfSeguroColors.success04),
        ('success-05', CpfSeguroColors.success05),
        ('success-06', CpfSeguroColors.success06),
        ('success-07', CpfSeguroColors.success07),
        ('success07Alpha70', CpfSeguroColors.success07Alpha70),
      ]
    ),
    (
      'WARNING',
      [
        ('warning-01', CpfSeguroColors.warning01),
        ('warning-02', CpfSeguroColors.warning02),
        ('warning-03', CpfSeguroColors.warning03),
        ('warning-04', CpfSeguroColors.warning04),
        ('warning-05', CpfSeguroColors.warning05),
        ('warning-06', CpfSeguroColors.warning06),
        ('warning-07', CpfSeguroColors.warning07),
      ]
    ),
  ];

  // O que cada FAMÍLIA significa — derivado do uso real (o shade 01-09 é só
  // escala clara→escura; o sentido mora na família e nos roles do Scheme).
  static const _familyMeaning = <String, String>{
    'PRIMARY': 'A marca. Ação primária, link, seleção, foco. O 04 (#003BE0) é o BRAND-PRINCIPAL; 08/09 = wash claro de fundo; os alphas viram glow e estado.',
    'NEUTRAL': 'Texto e superfície. 01-02 texto forte, 03-05 secundário/placeholder, 07-09 borda/divisor, 10 wash de fundo. Os alphas = scrim de modal e glass.',
    'ERROR': 'Destrutivo. Toast e banner de erro, validação de campo, botão destrutivo.',
    'SUCCESS': 'Confirmação. Status verificado, toast de sucesso, o check.',
    'WARNING': 'Atenção. Status pendente, aviso, a tag "Convite enviado".',
  };

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'PALETTE · primitivos (tier 1) — o material bruto que o Scheme resolve · troca por flavor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in _palettes) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4),
              child: Text(
                row.$1,
                style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04),
              ),
            ),
            // A semântica da família (o que significa / onde é usada).
            if (_familyMeaning[row.$1] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _familyMeaning[row.$1]!,
                  style: CpfSeguroType.bodySm
                      .copyWith(color: CpfSeguroColors.neutral03, height: 1.4),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final swatch in row.$2) _Swatch(name: swatch.$1, color: swatch.$2),
              ],
            ),
          ],
          // Gradientes são token de COR (Brand/Principal → alpha), não uma
          // categoria à parte — igual ao modelo de variáveis do Figma.
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text('GRADIENTES',
                style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final g in const <(String, Gradient, String)>[
                ('brandLift', CpfSeguroGradients.brandLift, 'primary-05 → 03 · banner'),
              ])
                SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: g.$2,
                          borderRadius: CpfSeguroRadius.all8,
                          border: Border.all(color: CpfSeguroColors.neutral09),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(g.$1,
                          style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral02)),
                      Text(g.$3,
                          style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral05)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});
  final String name;
  final Color color;

  bool _isLight() {
    final l = (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;
    return l > 160;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 72,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CpfSeguroColors.neutral09, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _isLight() ? CpfSeguroColors.neutral01 : CpfSeguroColors.white,
            ),
          ),
          Text(
            '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
            style: TextStyle(
              fontSize: 10,
              color: _isLight() ? CpfSeguroColors.neutral03 : CpfSeguroColors.neutral08,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Typography
// ═══════════════════════════════════════════════════════════════════════════

class _TypographySection extends StatelessWidget {
  const _TypographySection();

  // Cada voz é uma PALAVRA da linguagem: nome · spec técnica · o que significa
  // e quando usar. A semântica é tão token quanto o valor.
  static const _vozes = <(String, List<(String, String, String)>)>[
    ('HEADINGS · a hierarquia de titulação (feito h1→h4)', [
      ('display', '36 · 700', 'Reservado — hero, marketing, número gigante. Hoje não aparece em nenhuma tela do app.'),
      ('title', '22 · 600', 'Título da tela e do topo de sheet — o nome do lugar onde você está (PageTitle, header do sheet).'),
      ('heading', '16 · 600', 'Título de um bloco ou resultado dentro da tela/sheet — "Pagamento efetuado", cabeçalho de appbar.'),
      ('subheading', '14 · 600', 'Abre um grupo ou nomeia uma linha — "Forma de pagamento", título de DetailRow.'),
    ]),
    ('BODY · o texto que se lê', [
      ('bodyLg', '16 · 400', 'Leitura confortável — descrição de item de menu, parágrafo mais longo.'),
      ('body', '14 · 400', 'O corpo de trabalho — subtítulo abaixo do título, descrição, texto de modal.'),
      ('caption', '12 · 400', 'Apoio pequeno — valor de DetailRow, tooltip, helper de campo, subtítulo de item.'),
    ]),
    ('RÓTULOS & AÇÃO · texto de UI', [
      ('label', '12 · 600', 'Rótulo de UI — label de campo, título de row padrão, link de ação inline ("Trocar").'),
      ('overline', '11 · 700', 'Eyebrow de grupo/seção, sempre UPPER — orienta antes do conteúdo.'),
      ('button', '15 · 600', 'Texto de botão (WalletButton, botão do chat, ação no input).'),
    ]),
    ('UTILITY · forma própria', [
      ('numeric', '22 · 500', 'Número em destaque — valor em R\$ (AmountDisplay) e código OTP. Tabular, alinha em coluna.'),
      ('mono', '14 · 600', 'Relógio da status bar do mock — chrome do frame, não conteúdo (o app usa a nativa).'),
      ('chatBody', '13 · 700', 'Corpo da bolha de chat — o negrito é identidade da marca (decisão do time).'),
    ]),
  ];

  static const _vozStyle = <String, TextStyle>{
    'display': CpfSeguroType.display,
    'title': CpfSeguroType.title,
    'heading': CpfSeguroType.heading,
    'subheading': CpfSeguroType.subheading,
    'bodyLg': CpfSeguroType.bodyLg,
    'body': CpfSeguroType.bodyMd,
    'caption': CpfSeguroType.caption,
    'label': CpfSeguroType.label,
    'overline': CpfSeguroType.overline,
    'button': CpfSeguroType.button,
    'numeric': CpfSeguroType.numeric,
    'mono': CpfSeguroType.mono,
    'chatBody': CpfSeguroType.chatBody,
  };

  static const _escala = <String>[
    'displayLg 57', 'displayMd 45', 'displaySm 36', 'headlineLg 32', 'headlineMd 28',
    'headlineSm 24', 'titleLg 22', 'titleMd 16', 'titleSm 14', 'bodyLg 16', 'bodyMd 14',
    'bodySm 12', 'labelLg 14', 'labelMd 12', 'labelSm 11',
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'TYPOGRAPHY · 13 vozes semânticas sobre a escala M3 · cor sempre do scheme',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final g in _vozes) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(g.$1,
                  style: CpfSeguroType.labelSm.copyWith(
                      color: CpfSeguroColors.primary04,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2)),
            ),
            for (final s in g.$2)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome (a palavra) + spec técnica.
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1,
                              style: CpfSeguroType.labelSm.copyWith(
                                  color: CpfSeguroColors.neutral02,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(s.$2,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: CpfSeguroColors.neutral05,
                                  fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Specimen + a SEMÂNTICA (o que significa / quando usar).
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Abc CPF SEGURO',
                              style: (_vozStyle[s.$1] ?? CpfSeguroType.bodyMd)
                                  .copyWith(color: CpfSeguroColors.neutral01)),
                          const SizedBox(height: 4),
                          Text(s.$3,
                              style: CpfSeguroType.bodySm.copyWith(
                                  color: CpfSeguroColors.neutral04, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 20),
          Container(height: 1, color: CpfSeguroColors.neutral09),
          const SizedBox(height: 12),
          Text('ESCALA · o alfabeto (primitivos M3 — as vozes compõem daqui)',
              style: CpfSeguroType.labelSm
                  .copyWith(color: CpfSeguroColors.neutral04, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(_escala.join('   ·   '),
              style: const TextStyle(
                  fontSize: 11, color: CpfSeguroColors.neutral05, fontFamily: 'monospace', height: 1.6)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Buttons
// ═══════════════════════════════════════════════════════════════════════════

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'BUTTON · 3 types × 2 states × 3 sizes + chatLift',
      role: 'A ação. Primary = a ação principal da tela (Pagar, Continuar); secondary/tertiary descem a hierarquia; state error = destrutivo. Como CTA, vive ancorado na bottom bar.',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius', 'Shadow'],
      specId: 'design-system-button',
      whenUse: 'para uma ação clara e imediata (Pagar, Continuar, Confirmar). '
          'Para navegar entre telas, prefira NavigationButton na bottom bar.',
      dos: const [
        'Uma primary por tela — a ação principal.',
        'Rebaixe as demais pra secondary/tertiary (hierarquia).',
        'Use state error só para ação destrutiva (excluir, cancelar conta).',
        'Verbo de ação no label ("Pagar R\$ 10"), não "OK".',
      ],
      donts: const [
        'Duas primary competindo na mesma tela.',
        'Cor/raio crus — o tipo já carrega o role.',
        'Button pra navegar de tab (isso é Nav).',
        'Label longo que quebra em 2 linhas — encurte o verbo.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Types (state normal, size lg)', const [
            CpfSeguroButton(label: 'primary', type: CpfSeguroButtonType.primary, onPressed: _noop),
            CpfSeguroButton(label: 'secondary', type: CpfSeguroButtonType.secondary, onPressed: _noop),
            CpfSeguroButton(label: 'tertiary', type: CpfSeguroButtonType.tertiary, onPressed: _noop),
          ]),
          _row('State error (destructive)', const [
            CpfSeguroButton(label: 'primary', type: CpfSeguroButtonType.primary, state: CpfSeguroButtonState.error, onPressed: _noop),
            CpfSeguroButton(label: 'secondary', type: CpfSeguroButtonType.secondary, state: CpfSeguroButtonState.error, onPressed: _noop),
            CpfSeguroButton(label: 'tertiary', type: CpfSeguroButtonType.tertiary, state: CpfSeguroButtonState.error, onPressed: _noop),
          ]),
          _row('Sizes (sm / md / lg)', const [
            CpfSeguroButton(label: 'sm', size: CpfSeguroButtonSize.sm, onPressed: _noop),
            CpfSeguroButton(label: 'md', size: CpfSeguroButtonSize.md, onPressed: _noop),
            CpfSeguroButton(label: 'lg', size: CpfSeguroButtonSize.lg, onPressed: _noop),
          ]),
          _row('Disabled', const [
            CpfSeguroButton(label: 'primary', disabled: true, onPressed: _noop),
            CpfSeguroButton(label: 'secondary', type: CpfSeguroButtonType.secondary, disabled: true, onPressed: _noop),
            CpfSeguroButton(label: 'tertiary', type: CpfSeguroButtonType.tertiary, disabled: true, onPressed: _noop),
          ]),
          _row('Com ícone', const [
            CpfSeguroButton(label: 'Continuar', trailIcon: CpfSeguroIcons.angleRightLight, onPressed: _noop),
            CpfSeguroButton(label: 'Voltar', leadIcon: CpfSeguroIcons.angleRightLight, type: CpfSeguroButtonType.secondary, onPressed: _noop),
          ]),
        ],
      ),
    );
  }

  Widget _row(String label, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          ),
          Wrap(spacing: 12, runSpacing: 12, children: children),
        ],
      ),
    );
  }

}

// ═══════════════════════════════════════════════════════════════════════════
// IconButtons
// ═══════════════════════════════════════════════════════════════════════════

class _IconButtonsSection extends StatelessWidget {
  const _IconButtonsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ICONBUTTON · 5 types × 2 states × 3 sizes',
      role: 'Ação só-glyph — fechar, voltar, kebab, lixeira. Onde não cabe um label.',
      composedOf: const ['Icon', 'Color', 'Radius'],
      specId: 'design-system-icon-button',
      whenUse: 'para uma ação sem espaço pra label (fechar, voltar, kebab, '
          'lixeira). Se há espaço e é a ação principal, use Button com label.',
      dos: const [
        'Sempre passe semanticLabel (acessibilidade).',
        'Mesma família type do Button (primary/secondary/tertiary).',
        'state error só para destrutivo (excluir).',
        'Ícone por token (CpfSeguroIcons), nunca glyph cru.',
      ],
      donts: const [
        'IconButton pra ação principal quando cabe um label.',
        'Sem semanticLabel (vira botão mudo pro leitor de tela).',
        'Vários enfileirados sem hierarquia — separe por área.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 12, runSpacing: 12, children: [
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'primary', type: CpfSeguroIconButtonType.primary, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'secondary', onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'secondary-primary', type: CpfSeguroIconButtonType.secondaryPrimary, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'tertiary', type: CpfSeguroIconButtonType.tertiary, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'tertiary-primary', type: CpfSeguroIconButtonType.tertiaryPrimary, onPressed: _noop),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'sm', size: CpfSeguroIconButtonSize.sm, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'md', size: CpfSeguroIconButtonSize.md, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'lg', size: CpfSeguroIconButtonSize.lg, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'badge', badge: true, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.angleRightLight, semanticLabel: 'rotate 180', rotate: 180, type: CpfSeguroIconButtonType.tertiary, onPressed: _noop),
            CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'error', state: CpfSeguroIconButtonState.error, type: CpfSeguroIconButtonType.primary, onPressed: _noop),
            const CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'disabled', disabled: true),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Inputs
// ═══════════════════════════════════════════════════════════════════════════

class _InputsSection extends StatefulWidget {
  const _InputsSection();
  @override
  State<_InputsSection> createState() => _InputsSectionState();
}

class _InputsSectionState extends State<_InputsSection> {
  final _c1 = TextEditingController(text: 'Ana Maria');
  final _c2 = TextEditingController();
  final _c3 = TextEditingController(text: '086.111.111-49');
  final _c4 = TextEditingController();

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'INPUT · label + field + tooltip · states',
      role: 'Campo de texto — CPF, nome, código. Carrega label, helper e erro inline.',
      composedOf: const ['Field', 'Color', 'Typography', 'Radius'],
      specId: 'design-system-input',
      whenUse: 'para entrada de texto livre num formulário (nome, CPF, e-mail). '
          'Para escolher de lista fechada use Dropdown; para data, DateField.',
      dos: const [
        'Sempre um label (o placeholder não substitui o label).',
        'Erro inline via error: mensagem curta e acionável.',
        'keyboardType + inputFormatters certos (CPF, telefone).',
        'helper pra instrução persistente ("Como aparece no documento").',
      ],
      donts: const [
        'Usar placeholder como label (some ao digitar).',
        'Montar TextField cru — o átomo Field já resolve a robustez.',
        'Mensagem de erro genérica ("Campo inválido").',
        'Input readOnly como se fosse Dropdown/DateField — use o word certo.',
      ],
      child: SizedBox(
        width: 360,
        child: Column(
          children: [
            CpfSeguroInput(controller: _c1, label: 'Nome completo', helper: 'Como aparece no documento'),
            const SizedBox(height: 16),
            CpfSeguroInput(controller: _c2, label: 'E-mail', placeholder: 'você@exemplo.com'),
            const SizedBox(height: 16),
            CpfSeguroInput(controller: _c3, label: 'CPF', error: 'CPF inválido'),
            const SizedBox(height: 16),
            CpfSeguroInput(controller: _c4, label: 'Read-only', disabled: true, placeholder: 'Preenchido pelo sistema'),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Checkbox
// ═══════════════════════════════════════════════════════════════════════════

class _CheckboxSection extends StatefulWidget {
  const _CheckboxSection();
  @override
  State<_CheckboxSection> createState() => _CheckboxSectionState();
}

class _CheckboxSectionState extends State<_CheckboxSection> {
  final Map<String, bool> _v = {'a': false, 'b': true, 'c': false, 'd': true};

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'CHECKBOX · sm/md × primary/neutral × indeterminate/disabled',
      role: 'Escolha múltipla e aceite — termos, opções de uma lista.',
      composedOf: const ['Color', 'Radius'],
      specId: 'design-system-checkbox',
      whenUse: 'para selecionar zero-ou-vários itens de uma lista, ou aceitar '
          'termos. Para escolha única entre opções, use RadioList; pra liga/'
          'desliga imediato, ToggleSwitch.',
      dos: const [
        'indeterminate no pai quando os filhos estão parciais.',
        'Label tocável junto do box (aumenta o alvo).',
        'variant neutral em superfície colorida; primary no padrão.',
      ],
      donts: const [
        'Checkbox pra escolha única (isso é RadioList).',
        'Checkbox pra config on/off imediata (isso é ToggleSwitch).',
        'Box sem label associado.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
            CpfSeguroCheckbox(checked: _v['a']!, onChanged: (v) => setState(() => _v['a'] = v)),
            CpfSeguroCheckbox(checked: _v['b']!, onChanged: (v) => setState(() => _v['b'] = v)),
            CpfSeguroCheckbox(checked: true, variant: CpfSeguroCheckboxVariant.neutral, onChanged: (_) {}),
            const CpfSeguroCheckbox(indeterminate: true),
            const CpfSeguroCheckbox(disabled: true),
            const CpfSeguroCheckbox(disabled: true, checked: true),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
            CpfSeguroCheckbox(size: CpfSeguroCheckboxSize.sm, checked: _v['c']!, onChanged: (v) => setState(() => _v['c'] = v)),
            CpfSeguroCheckbox(size: CpfSeguroCheckboxSize.sm, checked: true, onChanged: (_) {}),
            const CpfSeguroCheckbox(size: CpfSeguroCheckboxSize.sm, indeterminate: true),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: 340,
            child: Column(
              children: [
                CpfSeguroCheckbox(
                  checked: _v['d']!,
                  onChanged: (v) => setState(() => _v['d'] = v),
                  label: 'Aceito os termos',
                  description: 'Você pode revogar a qualquer momento.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RadioList
// ═══════════════════════════════════════════════════════════════════════════

class _RadioListSection extends StatefulWidget {
  const _RadioListSection();
  @override
  State<_RadioListSection> createState() => _RadioListSectionState();
}

class _RadioListSectionState extends State<_RadioListSection> {
  String? _value = 'tarifas';
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'RADIOLIST · single-select com título',
      role: 'Escolha única — motivo de exclusão, opção entre várias.',
      composedOf: const ['Color', 'Typography'],
      specId: 'design-system-radio-list',
      whenUse: 'para escolher exatamente UMA opção de um conjunto pequeno e '
          'visível (motivo de exclusão, tipo de conta). Muitas opções → Dropdown.',
      dos: const [
        'Título curto dizendo a decisão ("Selecione o motivo").',
        'Opções mutuamente exclusivas.',
        'Todas as opções visíveis (é lista, não sheet).',
      ],
      donts: const [
        'RadioList pra multi-seleção (isso é Checkbox).',
        'Lista longa que não cabe (>6-7 → use Dropdown).',
        'Opção default escondida — deixe claro o que está selecionado.',
      ],
      child: SizedBox(
        width: 360,
        child: CpfSeguroRadioList(
          title: 'Selecione o motivo',
          value: _value,
          onChanged: (v) => setState(() => _value = v),
          options: const [
            CpfSeguroRadioOption(value: 'oferta', label: 'Recebi oferta de outro banco'),
            CpfSeguroRadioOption(value: 'tarifas', label: 'Insatisfação com preço das tarifas'),
            CpfSeguroRadioOption(value: 'atend', label: 'Insatisfação com atendimento'),
            CpfSeguroRadioOption(value: 'outros', label: 'Outros'),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Toggle
// ═══════════════════════════════════════════════════════════════════════════

class _ToggleSwitchSection extends StatefulWidget {
  const _ToggleSwitchSection();
  @override
  State<_ToggleSwitchSection> createState() => _ToggleSwitchSectionState();
}

class _ToggleSwitchSectionState extends State<_ToggleSwitchSection> {
  bool _md = true;
  bool _sm = false;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'TOGGLESWITCH · 2 sizes × on/off × disabled · Figma 2365:32193',
      role: 'Liga/desliga imediato — permissão e config (Face ID, Botão de Pânico). Sem passo de confirmar.',
      composedOf: const ['Color', 'Radius'],
      specId: 'design-system-toggle-switch',
      whenUse: 'para uma configuração binária que aplica NA HORA (Face ID, Botão '
          'de Pânico). Sem botão "salvar".',
      dos: const [
        'Efeito imediato ao alternar (sem confirmar).',
        'semanticLabel dizendo o que liga/desliga.',
        'Label da config à esquerda, switch à direita (na AppListRow).',
      ],
      donts: const [
        'ToggleSwitch que só aplica depois de um "Salvar" (isso é Checkbox).',
        'Toggle pra escolher entre 2 opções nomeadas (isso é RadioList).',
      ],
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            CpfSeguroToggleSwitch(value: _md, onChanged: (v) => setState(() => _md = v)),
            const SizedBox(width: 8),
            Text('md · ${_md ? 'on' : 'off'}', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            CpfSeguroToggleSwitch(size: CpfSeguroToggleSize.sm, value: _sm, onChanged: (v) => setState(() => _sm = v)),
            const SizedBox(width: 8),
            Text('sm · ${_sm ? 'on' : 'off'}', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            const CpfSeguroToggleSwitch(value: false, onChanged: null, disabled: true),
            const SizedBox(width: 8),
            const CpfSeguroToggleSwitch(value: true, onChanged: null, disabled: true),
            const SizedBox(width: 8),
            Text('disabled', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LoadingSpinner
// ═══════════════════════════════════════════════════════════════════════════

class _SkeletonSection extends StatelessWidget {
  const _SkeletonSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SKELETON + SHIMMER · placeholder de loading',
      specId: 'design-system-skeleton',
      whenUse: 'placeholder da FORMA do conteúdo enquanto carrega (linhas de '
          'lista, card). Shimmer = o efeito de atividade em loop.',
      dos: const [
        'Espelhar o layout real do conteúdo que vem.',
        'Shimmer pra sinalizar que está carregando.',
      ],
      donts: const [
        'Skeleton pra espera de uma AÇÃO (isso é spinner).',
        'Manter skeleton após erro (use EmptyState).',
      ],
      role: 'Skeleton = a forma cinza que ocupa o lugar do conteúdo. Shimmer = o '
          'wrapper que aplica o brilho animado (loop Motion.shimmer). Compõe o '
          'esqueleto de uma tela enquanto carrega.',
      composedOf: const ['Color', 'Motion', 'Radius'],
      child: SizedBox(
        width: 280,
        child: CpfSeguroShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CpfSeguroSkeleton.circle(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CpfSeguroSkeleton.line(width: 120),
                        SizedBox(height: 8),
                        CpfSeguroSkeleton.line(width: 80),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CpfSeguroSkeleton.box(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingSpinnerSection extends StatelessWidget {
  const _LoadingSpinnerSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'LOADINGSPINNER · 3 sizes · track neutral-07 + arco 75% primary-04',
      specId: 'design-system-loading-spinner',
      whenUse: 'espera INDETERMINADA e curta (botão processando, carregar uma '
          'tela). Progresso conhecido → ProgressBar; placeholder de conteúdo → '
          'Skeleton.',
      dos: const [
        'size conforme o contexto (inline no botão vs tela).',
        'Centralizar na área que está carregando.',
      ],
      donts: const [
        'Spinner pra progresso mensurável (isso é ProgressBar/Ring).',
        'Spinner sobre a lista inteira — prefira Skeleton da forma.',
      ],
      role: 'Espera curta inline — dentro de botão, sheet, carregamento de bloco.',
      composedOf: const ['Color'],
      child: Wrap(spacing: 32, runSpacing: 16, children: [
        _wrap('sm · 22', const CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.sm)),
        _wrap('md · 40', const CpfSeguroLoadingSpinner()),
        _wrap('lg · 60', const CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.lg)),
      ]),
    );
  }

  Widget _wrap(String label, Widget child) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      child,
      const SizedBox(height: 8),
      Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PageTitle
// ═══════════════════════════════════════════════════════════════════════════

class _PageTitleSection extends StatelessWidget {
  const _PageTitleSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'PAGETITLE · h1 22/32 + subtitle opcional',
      specId: 'design-system-page-title',
      whenUse: 'o título (h1) + subtítulo opcional do conteúdo, logo abaixo do '
          'appbar. Um por tela.',
      dos: const [
        'Um PageTitle por tela.',
        'Subtítulo curto orientando o que fazer ali.',
      ],
      donts: const [
        'PageTitle dentro de card/sheet-title/appbar (esses têm o próprio).',
        'Vários títulos h1 competindo na mesma tela.',
      ],
      role: 'Título + subtítulo no topo do corpo da tela.',
      composedOf: const ['Color', 'Typography'],
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: CpfSeguroColors.neutral10, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CpfSeguroPageTitle(title: 'Só título'),
            CpfSeguroPageTitle(title: 'Nome', subtitle: 'Atualize seu nome completo. Vamos usá-lo na sua identificação.'),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MenuSection
// ═══════════════════════════════════════════════════════════════════════════

// NOTA — _MenuSectionSection foi removida. `CpfSeguroMenuSection` foi
// consolidada como prop `title: String?` da coleção CpfSeguroAppList
// (.carded/.plain/.menu). Demo do title está na section AppList abaixo.

// ═══════════════════════════════════════════════════════════════════════════
// Action
// ═══════════════════════════════════════════════════════════════════════════

class _ActionSection extends StatelessWidget {
  const _ActionSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ACTION · 7 direções',
      role: 'O chevron de "abre isto" — o affordance de navegar dentro de uma row.',
      composedOf: const ['Icon', 'Color'],
      specId: 'design-system-action',
      whenUse: 'como affordance ("abre/expande isto") no fim de uma row tocável: '
          'right = entrar, up/down = colapsar/expandir, ellipsis = menu.',
      dos: const [
        'A row inteira é o alvo de toque; o Action só sinaliza.',
        'right pra navegar, up/down pra expandir/colapsar.',
        'Cor neutra — é affordance, não CTA.',
      ],
      donts: const [
        'Action como botão de ação real (isso é Button/IconButton).',
        'Action numa row que não é tocável (afordância falsa).',
      ],
      child: Wrap(spacing: 24, runSpacing: 12, children: [
        for (final d in CpfSeguroActionDirection.values)
          Column(mainAxisSize: MainAxisSize.min, children: [
            CpfSeguroAction(direction: d),
            const SizedBox(height: 4),
            Text(d.name, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// StatusTag
// ═══════════════════════════════════════════════════════════════════════════

class _StatusTagSection extends StatelessWidget {
  const _StatusTagSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'STATUSTAG · 5 tones',
      specId: 'design-system-status-tag',
      whenUse: 'para rotular um ESTADO semântico (Pago, Pendente, Erro) '
          'numa linha ou card. O tone carrega o significado.',
      dos: const [
        'tone casa com o significado (success/danger/warning...).',
        'Texto curto — o estado em 1-2 palavras.',
        'Deixe o ícone default do tone falar junto.',
      ],
      donts: const [
        'StatusTag como filtro removível (isso é InputChip).',
        'StatusTag decorativo sem estado (isso é InfoChip).',
        'tone que não bate com a mensagem (verde num erro).',
      ],
      role: 'Pill de estado — "Pendente", "Verificado", "Convite enviado". A cor é o tom semântico (warning/success/danger).',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: Wrap(spacing: 8, runSpacing: 8, children: const [
        CpfSeguroStatusTag(label: 'warning', tone: CpfSeguroStatusTone.warning),
        CpfSeguroStatusTag(label: 'neutral', tone: CpfSeguroStatusTone.neutral),
        CpfSeguroStatusTag(label: 'primary', tone: CpfSeguroStatusTone.primary),
        CpfSeguroStatusTag(label: 'success', tone: CpfSeguroStatusTone.success),
        CpfSeguroStatusTag(label: 'danger', tone: CpfSeguroStatusTone.danger),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Amount
// ═══════════════════════════════════════════════════════════════════════════

class _AmountSection extends StatelessWidget {
  const _AmountSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'AMOUNT · valor compacto de linha',
      specId: 'design-system-amount',
      whenUse: 'o valor monetário COMPACTO numa linha de lista/pagamento (cashIn '
          'verde / cashOut − / cashBack tachado / obscured).',
      dos: const [
        'right.amount na AppListRow.',
        'Sinal/cor pelo tipo (cashIn/cashOut/cashBack).',
      ],
      donts: const [
        'Amount como hero de saldo (isso é AmountDisplay).',
        'Formatar cor/sinal na mão fora do componente.',
      ],
      role: 'Valor monetário inline do extrato/lista. cashIn = chip verde "+", '
          'cashOut = "−", cashBack = tachado. Consumido por right.amount.',
      composedOf: const ['Color', 'Typography', 'Radius'],
      child: Wrap(spacing: 16, runSpacing: 8, children: const [
        CpfSeguroAmount.cashIn(value: 'R\$ 560,00'),
        CpfSeguroAmount.cashOut(value: 'R\$ 560,00'),
        CpfSeguroAmount.cashBack(value: 'R\$ 560,00'),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppList
// ═══════════════════════════════════════════════════════════════════════════

class _AppListSection extends StatelessWidget {
  const _AppListSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'APPLIST · AppListRow (row) + AppList.carded/.plain/.menu (coleção)',
      specId: 'design-system-app-list',
      whenUse: 'a lista padrão do app: AppListRow (linha left/middle/right) '
          'dentro de AppList (a coleção, dona única do separador).',
      dos: const [
        'AppListRow é row PURA — sem separador/posição própria.',
        'AppList decide o separador (.carded/.plain/.menu).',
        'Slots left/middle/right pros accessories (avatar, amount, action...).',
      ],
      donts: const [
        'Montar linha de lista na mão (Row + Divider) em vez de AppListRow.',
        'Colocar separador dentro da row.',
      ],
      role: 'AppListRow = a linha (3 slots left/middle/right), pura. AppList = a coleção, dona única do separador (.carded com stroke, .plain sem stroke, .menu divisor sob cada row).',
      composedOf: const ['AppListRow', 'SpotIcon', 'Avatar', 'Icon', 'StatusTag', 'Action', 'Checkbox', 'ToggleSwitch', 'IconButton', 'Color', 'Typography', 'Radius'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AppListRow · composição explícita (Left · Middle · Right)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: CpfSeguroAppList.carded(children: [
              const CpfSeguroAppListRow(
                left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(title: 'Ana Maria', subtitle: 'CPF 086.111.111-49'),
                right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
              ),
              CpfSeguroAppListRow(
                left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.shieldUserSolidFull, state: CpfSeguroSpotState.success),
                middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Login em Banco Aurora', subtitle: 'Por mim · Biometria'),
                right: CpfSeguroRightAccessory.time(time: '14min'),
              ),
              const CpfSeguroAppListRow(
                left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.xmarkSolid, state: CpfSeguroSpotState.error),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(title: 'Login negado em NovaPay', subtitle: 'Bloqueado por Pausa CPF'),
                right: CpfSeguroRightAccessory.status(label: 'Bloqueado', tone: CpfSeguroStatusTone.danger),
              ),
              CpfSeguroAppListRow(
                left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.clockLight, state: CpfSeguroSpotState.warning),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(title: 'Documento em análise', subtitle: 'Aguardando revisão'),
                right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.clock),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Factory .menuItem — menu de 3 (uso mais comum)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: CpfSeguroAppList.carded(
              title: 'Meus dados',
              children: [
                CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.userLight, title: 'Dados pessoais', subtitle: 'Nome, CPF, nascimento', onTap: () {}),
                CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.lockLight, title: 'Segurança', subtitle: 'Senha e biometria', onTap: () {}),
                CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.fileLight, title: 'Documentos', subtitle: 'Termos, privacidade e IR', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Factory .activityItem — histórico', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: CpfSeguroAppList.carded(
              title: 'Atividade recente',
              children: [
                CpfSeguroAppListRow.activityItem(
                  icon: CpfSeguroIcons.shieldUserSolidFull,
                  iconState: CpfSeguroSpotState.success,
                  title: 'Login em Banco Aurora',
                  subtitle: 'Por mim · Biometria',
                  time: '14min',
                ),
                CpfSeguroAppListRow.activityItem(
                  icon: CpfSeguroIcons.xmarkSolid,
                  iconState: CpfSeguroSpotState.error,
                  title: 'Login negado em NovaPay',
                  subtitle: 'Bloqueado por Pausa CPF',
                  status: CpfSeguroStatusTagData(label: 'Bloqueado', tone: CpfSeguroStatusTone.danger),
                ),
                CpfSeguroAppListRow.activityItem(
                  icon: CpfSeguroIcons.clockLight,
                  iconState: CpfSeguroSpotState.warning,
                  title: 'Documento em análise',
                  subtitle: 'Aguardando revisão',
                  time: '2h',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Factory .transactionItem — extrato da Carteira', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: CpfSeguroAppList.carded(children: [
              CpfSeguroAppListRow.transactionItem(
                title: 'Pague menos',
                source: 'CPF Seguro',
                time: '12:04',
                amount: 'R\$ 560,00',
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Factory .profileBanner — banner de perfil (standalone, bg primary-08)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: CpfSeguroAppListRow.profileBanner(
              initials: 'AM',
              name: 'Ana Maria',
              subtitle: 'CPF 086.***.***-49',
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OtpInput
// ═══════════════════════════════════════════════════════════════════════════

class _OtpSection extends StatelessWidget {
  const _OtpSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'OTPINPUT · 6 boxes 40×40 · default/focused/filled/error',
      role: 'Código de verificação — SMS, e-mail (dígitos separados).',
      specId: 'design-system-otp-input',
      whenUse: 'para código de verificação curto (SMS/e-mail) em dígitos '
          'separados. Não é campo de senha nem de texto livre.',
      dos: const [
        'length casando com o código enviado (4/6 dígitos).',
        'onCompleted dispara a verificação automática.',
        'error inline quando o código falha.',
        'autofocus + autofill de SMS quando a plataforma permite.',
      ],
      donts: const [
        'OtpInput pra senha (isso é Input/ChatInput password).',
        'Forçar o usuário a apertar "enviar" — complete no último dígito.',
        'length diferente do código real.',
      ],
      composedOf: const ['Color', 'Typography', 'Radius'],
      child: Wrap(spacing: 24, runSpacing: 24, children: const [
        _OtpLabeled(value: '', label: 'empty (focus na 1ª)'),
        _OtpLabeled(value: '123', label: '3 dígitos'),
        _OtpLabeled(value: '123456', label: 'completo'),
        _OtpLabeled(value: '1234', error: 'Código incorreto', label: 'erro'),
      ]),
    );
  }
}

class _OtpLabeled extends StatelessWidget {
  const _OtpLabeled({required this.value, required this.label, this.error});
  final String value;
  final String label;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      CpfSeguroOtpInput(value: value, error: error),
      const SizedBox(height: 8),
      Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MenuButton
// ═══════════════════════════════════════════════════════════════════════════

class _MenuButtonSection extends StatelessWidget {
  const _MenuButtonSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'MENUBUTTON · vertical (rail) × horizontal (contextual) × 3 states',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      specId: 'design-system-menu-button',
      whenUse: 'item de menu ou atalho: rail vertical (vertical), menu '
          'horizontal/contextual (horizontal) ou card de atalho sólido 97×97 da '
          'home pix (tile).',
      dos: const [
        'Escolha a variant pelo contexto (vertical/horizontal/tile).',
        'active só no item atual do menu.',
        'tile para ação one-shot da home (sem estado active/hover).',
      ],
      donts: const [
        'MenuButton como CTA principal — isso é Button.',
        'tile com estado active (ele é one-shot).',
        'Misturar variants na mesma lista de menu.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('vertical (rail)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          Row(children: const [
            CpfSeguroMenuButton(icon: CpfSeguroIcons.chartLineSolid, label: 'Dashboard'),
            SizedBox(width: 8),
            CpfSeguroMenuButton(icon: CpfSeguroIcons.userLight, label: 'Usuários', active: true),
            SizedBox(width: 8),
            CpfSeguroMenuButton(icon: CpfSeguroIcons.fileLight, label: 'Arquivos'),
          ]),
          const SizedBox(height: 16),
          Text('horizontal (menu contextual)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: const [
            CpfSeguroMenuButton(icon: CpfSeguroIcons.chartLineSolid, label: 'Dashboard', variant: CpfSeguroMenuButtonVariant.horizontal),
            CpfSeguroMenuButton(icon: CpfSeguroIcons.userLight, label: 'Usuários', variant: CpfSeguroMenuButtonVariant.horizontal, active: true),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Logo
// ═══════════════════════════════════════════════════════════════════════════

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'LOGO · mark / full',
      specId: 'design-system-logo',
      whenUse: 'a marca CPF Seguro: mark (só símbolo) em espaços apertados, full '
          '(símbolo + wordmark) em splash/topo.',
      dos: const [
        'full em splash/boas-vindas; mark em barras/espaços pequenos.',
        'Cor da marca via token.',
      ],
      donts: const [
        'Recolorir/distorcer/rotacionar a marca.',
        'Logo do parceiro aqui (isso é cobrand).',
      ],
      role: 'A marca CPF SEGURO — full ou compacto, conforme o espaço.',
      composedOf: const ['Color'],
      child: Wrap(spacing: 32, runSpacing: 16, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Column(mainAxisSize: MainAxisSize.min, children: const [
          CpfSeguroLogo(size: 48),
          SizedBox(height: 8),
          Text('mark · 48', style: CpfSeguroType.labelSm),
        ]),
        Column(mainAxisSize: MainAxisSize.min, children: const [
          CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 40),
          SizedBox(height: 8),
          Text('full · 40', style: CpfSeguroType.labelSm),
        ]),
        Container(
          padding: const EdgeInsets.all(12),
          color: CpfSeguroColors.primary04,
          child: Column(mainAxisSize: MainAxisSize.min, children: const [
            CpfSeguroLogo(size: 40, color: CpfSeguroColors.white),
            SizedBox(height: 8),
            Text('mark white', style: TextStyle(fontSize: 11, color: CpfSeguroColors.white)),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TopAppBar
// ═══════════════════════════════════════════════════════════════════════════

class _TopAppBarSection extends StatelessWidget {
  const _TopAppBarSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'TOPAPPBAR · organismo unificado com 3 factories',
      specId: 'design-system-top-app-bar',
      whenUse: 'a barra superior da tela. .app = glass + inset REAL da status bar '
          '(telas do app); .stepper = fluxo com progresso; .defaultVariant = mock '
          '9:41 só do catálogo.',
      dos: const [
        '.app nas telas do app (glass + safe area real).',
        'Compor NavigationTopBar dentro (left/title/right).',
        'extendBodyBehindAppBar pra o conteúdo passar sob o glass.',
      ],
      donts: const [
        '.defaultVariant (mock 9:41) numa tela real.',
        'Reimplementar appbar por tela em vez de usar as factories.',
      ],
      role: 'Barra do topo — back/close + título + ação. Onde você está e como sair.',
      composedOf: const ['GlassSurface', 'StatusBar', 'NavigationTopBar', 'Stepper', 'Color'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _phone('.default(navBar:) · com back', CpfSeguroTopAppBar.defaultVariant(
            navBar: CpfSeguroNavigationTopBar(
              left: CpfSeguroNavigationLeftAccessory.back(),
              title: 'Alterar senha',
              right: CpfSeguroNavigationRightAccessory.icons(icons: [
                CpfSeguroNavRightIcon(icon: CpfSeguroIcons.circleQuestionLight, semanticLabel: 'Ajuda'),
              ]),
            ),
          )),
          _phone('.default(navBar:) · home + bell', CpfSeguroTopAppBar.defaultVariant(
            navBar: CpfSeguroNavigationTopBar(
              left: CpfSeguroNavigationLeftAccessory.home(firstName: 'Ana'),
              centerAlign: TextAlign.start,
              right: CpfSeguroNavigationRightAccessory.icons(icons: [
                CpfSeguroNavRightIcon(icon: CpfSeguroIcons.eyeLight, semanticLabel: 'Saldo'),
                CpfSeguroNavRightIcon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações', badge: true),
              ]),
            ),
          )),
          _phone('.bottomsheet(navBar:) · grip + close + título', CpfSeguroTopAppBar.bottomsheet(
            navBar: CpfSeguroNavigationTopBar(
              left: CpfSeguroNavigationLeftAccessory.close(),
              title: 'Editar CPF',
            ),
          )),
          _phone('.stepper(navBar:, stepper:) · chat SDK', CpfSeguroTopAppBar.stepper(
            navBar: const CpfSeguroNavigationTopBar(title: 'Criar sua senha'),
            stepper: const CpfSeguroStepper(
              current: 2,
              total: 5,
              labelText: 'CRIAR SENHA',
            ),
          )),
        ],
      ),
    );
  }

  Widget _phone(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        const SizedBox(height: 4),
        SizedBox(width: 393, child: child),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BottomApp
// ═══════════════════════════════════════════════════════════════════════════

class _BottomAppSection extends StatelessWidget {
  const _BottomAppSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'BOTTOMAPP · organismo unificado com 7 factories',
      specId: 'design-system-bottom-app',
      whenUse: 'o slot inferior da tela (região bottom da Surface). Cada factory '
          '(nav/button/keyboard/chatInput/...) compõe as moléculas em glass + '
          'home indicator.',
      dos: const [
        'Escolher a factory pelo conteúdo (nav/button/chatInput).',
        'Deixar o BottomApp prover glass + home indicator + safe area.',
      ],
      donts: const [
        'Montar barra inferior própria por tela.',
        'Empilhar duas barras inferiores.',
      ],
      role: 'Rodapé do app — CTA, nav ou teclado, em glass, ancorado embaixo.',
      composedOf: const ['GlassSurface', 'BottomHomeIndicator', 'Nav', 'NavigationButton', 'Keyboard', 'ChatInput', 'Color'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _phone('.default() · só HomeIndicator sem fundo', const CpfSeguroBottomApp.defaultVariant()),
          _phone('.nav(nav:) · Nav + indicator (glass)', CpfSeguroBottomApp.nav(nav: const CpfSeguroNav(activeTab: CpfSeguroNavTab.home))),
          _phone('.button(button:) · 1 CTA', CpfSeguroBottomApp.button(
            button: const CpfSeguroNavigationButton(primary: CpfSeguroNavigationAction(label: 'Continuar')),
          )),
          _phone('.button(button:) · 2 CTAs', CpfSeguroBottomApp.button(
            button: const CpfSeguroNavigationButton(
              primary: CpfSeguroNavigationAction(label: 'Salvar'),
              secondary: CpfSeguroNavigationAction(label: 'Cancelar'),
            ),
          )),
        ],
      ),
    );
  }

  Widget _phone(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        const SizedBox(height: 4),
        SizedBox(
          width: 393,
          child: DecoratedBox(
            decoration: BoxDecoration(color: CpfSeguroColors.neutral10, borderRadius: BorderRadius.circular(8)),
            child: child,
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Toast
// ═══════════════════════════════════════════════════════════════════════════

class _ToastSection extends StatelessWidget {
  const _ToastSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'TOAST · 4 states · glass 70% + border tint',
      specId: 'design-system-toast',
      whenUse: 'feedback TRANSITÓRIO do resultado de uma ação (copiado, salvo, '
          'falhou) — aparece e some sozinho. Via helper showToast.',
      dos: const [
        'Mensagem curta de resultado.',
        'state casa (success/error/warning/info).',
        'Efêmero — some sem exigir interação.',
      ],
      donts: const [
        'Toast pra info persistente (use banner).',
        'Ação crítica dentro do toast (ele desaparece).',
        'Empilhar vários toasts ao mesmo tempo.',
      ],
      role: 'Feedback efêmero — sucesso/erro que aparece e some.',
      composedOf: const ['SpotIcon', 'GlassSurface', 'Color', 'Typography', 'Radius', 'Shadow'],
      child: SizedBox(
        width: 361,
        child: Column(children: const [
          CpfSeguroToast(title: 'Oi, Ana!', subtitle: 'Que bom te ver aqui de novo.'),
          SizedBox(height: 12),
          CpfSeguroToast(state: CpfSeguroToastState.success, title: 'Senha alterada!', subtitle: 'Use a nova senha de agora em diante.'),
          SizedBox(height: 12),
          CpfSeguroToast(state: CpfSeguroToastState.error, title: 'Falha ao enviar', subtitle: 'Verifique sua conexão.'),
          SizedBox(height: 12),
          CpfSeguroToast(state: CpfSeguroToastState.warning, title: 'Documento vence em 7 dias'),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Chat
// ═══════════════════════════════════════════════════════════════════════════

class _ChatSection extends StatelessWidget {
  const _ChatSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'CHAT · Bubble align + BottomChatBar glass (1 fundo único)',
      specId: 'design-system-chat-bubble',
      whenUse: 'a superfície de chat do onboarding: bolhas (bot esquerda / user '
          'direita) + input glass no rodapé, tudo num fundo único.',
      dos: const [
        'ChatBubble por fala (from bot/user + tone).',
        'ChatInput ancorado no bottom (BottomApp.chatInput).',
        'TypingIndicator na espera do bot.',
      ],
      donts: const [
        'Montar bolha/typing na mão.',
        'Fundos diferentes por região (é um fundo só).',
      ],
      composedOf: const ['GlassSurface', 'StatusBar', 'TopAppBar', 'ChatProgress', 'CobrandMark', 'ChatBubble', 'ChatInput', 'BottomHomeIndicator', 'Color', 'Typography', 'Radius'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bubbles · bot=left/74.8%max · user=right/85%max · gap 8', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 12),
          SizedBox(
            width: 393,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: CpfSeguroColors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: CpfSeguroColors.neutral09)),
              child: CpfSeguroChatScroll(children: const [
                CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: Text('Oi, Ana! Sou o CPF SEGURO.')),
                CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: Text('Vamos criar sua senha em 5 passos.')),
                CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: Text('086.***.***-49')),
                CpfSeguroChatCriteriaBubble(
                  title: 'Sua senha precisa ter:',
                  items: [
                    CpfSeguroCriteriaItem(label: '6 dígitos', status: CpfSeguroCriteriaStatus.ok),
                    CpfSeguroCriteriaItem(label: 'Não sequencial', status: CpfSeguroCriteriaStatus.ok),
                    CpfSeguroCriteriaItem(label: 'Não repetir dígitos', status: CpfSeguroCriteriaStatus.fail),
                    CpfSeguroCriteriaItem(label: 'Não ser data de nascimento'),
                  ],
                ),
                CpfSeguroChatTypingIndicator(),
              ]),
            ),
          ),
          const SizedBox(height: 32),
          Text('BottomApp.chatInput · fundo único glassy (input mantém bg próprio)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 12),
          _GlassSurface(
            width: 393,
            child: CpfSeguroBottomApp.chatInput(
              input: CpfSeguroChatInput(
                controller: TextEditingController(text: 'olá!'),
                sendReady: true,
                onSend: () {},
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('BottomApp.chatInputAndKeyboard · glass no input, cinza sólido no keyboard', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 12),
          _GlassSurface(
            width: 393,
            child: CpfSeguroBottomApp.chatInputAndKeyboard(
              input: CpfSeguroChatInput(
                controller: TextEditingController(text: '123456'),
                type: CpfSeguroChatInputType.numeric,
                password: true,
                maxLength: 6,
                sendDisabled: false,
              ),
              keyboard: CpfSeguroKeyboard(
                onKey: (_) {},
                onBackspace: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Superfície colorida (bg gradient primary) usada como fundo pra demonstrar
/// que o glass do BottomChatBar é transparente — o gradient passa por baixo.
class _GlassSurface extends StatelessWidget {
  const _GlassSurface({required this.child, required this.width});
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: CpfSeguroGradients.brandLift),
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 120),
              child,
            ]),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Radius scale
// ═══════════════════════════════════════════════════════════════════════════

class _RadiusSection extends StatelessWidget {
  const _RadiusSection();

  // Uso-derivado: pill (22), all8 (16) e all24 (20) dominam.
  static const _scale = <(String, BorderRadius)>[
    ('all2 · 2 · hairline — bateria, divisória', CpfSeguroRadius.all2),
    ('all8 · 8 · chip, input, card pequeno', CpfSeguroRadius.all8),
    ('all16 · 16 · card médio', CpfSeguroRadius.all16),
    ('all24 · 24 · card grande, sheet, grupo de lista', CpfSeguroRadius.all24),
    ('all40 · 40 · nav flutuante, moldura grande', CpfSeguroRadius.all40),
    ('all200 · 200 · pill total — botão, chip, badge, avatar', CpfSeguroRadius.all200),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'RADIUS · 5 tokens padronizados (2 · 8 · 16 · 24 · 200)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escala fechada — se um contexto pedir 12, arredonda pro mais '
            'próximo (16). Consistência > precisão. Semânticos: chatBubble '
            '(24), chatAnchor (0), chatButton (24), card (16), sheet (24), '
            'pill (200).',
            style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final r in _scale) _RadiusSwatch(name: r.$1, radius: r.$2),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadiusSwatch extends StatelessWidget {
  const _RadiusSwatch({required this.name, required this.radius});
  final String name;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 130,
            height: 60,
            decoration: BoxDecoration(
              color: CpfSeguroColors.primary08,
              border: Border.all(color: CpfSeguroColors.primary04, width: 1),
              borderRadius: radius,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral03),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Shadows scale
// ═══════════════════════════════════════════════════════════════════════════

class _ShadowsSection extends StatelessWidget {
  const _ShadowsSection();

  static const _shadows = <(String, Color, Offset, double, String)>[
    ('blackAlpha20', CpfSeguroColors.blackAlpha20, Offset(0, 4), 10, 'tooltip, gap marker'),
    ('blackAlpha40', CpfSeguroColors.blackAlpha40, Offset(0, 4), 12, 'sheet scrim, biometria overlay'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SHADOWS · tokens por contexto',
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          for (final s in _shadows)
            SizedBox(
              width: 160,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 8, top: 4, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: CpfSeguroColors.white,
                      borderRadius: CpfSeguroRadius.all8,
                      boxShadow: [BoxShadow(color: s.$2, offset: s.$3, blurRadius: s.$4)],
                    ),
                  ),
                  Text(s.$1, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral02)),
                  Text('uso: ${s.$5}', style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral05)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Gradients
// ═══════════════════════════════════════════════════════════════════════════

class _GradientsSection extends StatelessWidget {
  const _GradientsSection();

  static const _list = <(String, Gradient, String)>[
    ('brandLift',  CpfSeguroGradients.brandLift,
        'primary-05 → primary-03 · banner'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'GRADIENTS (degrades) · azul brand',
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          for (final g in _list)
            SizedBox(
              width: 260,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: g.$2,
                      borderRadius: CpfSeguroRadius.all16,
                      border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(g.$1, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral02)),
                  Text(g.$3, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral05)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Átomos sem section dedicada (adicionados por composedOf hierárquico)
// ═══════════════════════════════════════════════════════════════════════════

class _IconSection extends StatelessWidget {
  const _IconSection();

  // O VOCABULÁRIO real: dos 345 tokens, ~61 são de fato falados. Estes são o
  // núcleo, agrupados por função e com o sentido que têm NO PRODUTO — derivado
  // do uso (onde cada um aparece nas telas/componentes).
  static const _vocab = <(String, List<(String, String)>)>[
    ('IDENTIDADE & SEGURANÇA', [
      (CpfSeguroIcons.lockLight, 'Trava/segurança — login, acesso protegido.'),
      (CpfSeguroIcons.fingerprintLight, 'Biometria — Sou eu!, autenticador.'),
      (CpfSeguroIcons.idCardLight, 'CPF / documento — identidade, botão de pânico.'),
      (CpfSeguroIcons.shieldUserSolidFull, 'CPF protegido — o escudo da marca.'),
      (CpfSeguroIcons.pauseLightFull, 'Pausar CPF — modo segurança.'),
      (CpfSeguroIcons.keyLight, 'Senha / chave de acesso.'),
    ]),
    ('PESSOA & CONTATOS', [
      (CpfSeguroIcons.userLight, 'Pessoa — avatar, apelido, dados pessoais.'),
      (CpfSeguroIcons.usersLight, 'Vários — contatos, lista de pessoas.'),
      (CpfSeguroIcons.handshakeLight, 'Confiança — contato de confiança.'),
    ]),
    ('PAGAMENTO & CARTEIRA', [
      (CpfSeguroIcons.creditCardLight, 'Cartão — forma de pagamento, carteira.'),
      (CpfSeguroIcons.walletLight, 'Carteira digital.'),
      (CpfSeguroIcons.receiptLight, 'Comprovante / histórico de atividades.'),
      (CpfSeguroIcons.qrcodeLight, 'QR — ler código, aproximar.'),
      (CpfSeguroIcons.mobileLight, 'Celular — pagamento por aproximação.'),
    ]),
    ('DOCUMENTO & CAPTURA', [
      (CpfSeguroIcons.fileLight, 'Documento / arquivo.'),
      (CpfSeguroIcons.cameraLight, 'Selfie / foto do documento.'),
    ]),
    ('STATUS & FEEDBACK', [
      (CpfSeguroIcons.circleCheckLight, 'OK / aprovado / verificado.'),
      (CpfSeguroIcons.triangleExclamationLight, 'Atenção / erro.'),
      (CpfSeguroIcons.clockLight, 'Tempo / pendente.'),
      (CpfSeguroIcons.bellLight, 'Notificação / aviso.'),
    ]),
    ('AÇÃO & NAVEGAÇÃO', [
      (CpfSeguroIcons.angleRightLight, 'Navegar / abrir — chevron de row.'),
      (CpfSeguroIcons.plusLight, 'Adicionar.'),
      (CpfSeguroIcons.xmarkSolid, 'Fechar / remover.'),
      (CpfSeguroIcons.eyeLight, 'Ver / mostrar.'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ICON · o vocabulário real — dos 345 tokens, ~61 são falados; núcleo por função',
      role: 'O glyph SVG recolorido pelo scheme. Quase sempre consumido via IconAccessory.',
      composedOf: const ['Color'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final g in _vocab) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(g.$1,
                  style: CpfSeguroType.labelSm.copyWith(
                      color: CpfSeguroColors.primary04,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2)),
            ),
            for (final i in g.$2)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CpfSeguroColors.white,
                        borderRadius: CpfSeguroRadius.all8,
                        border: Border.all(color: CpfSeguroColors.neutral09),
                      ),
                      child: CpfSeguroIcon(
                          name: i.$1, size: 20, color: CpfSeguroColors.neutral02),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 150,
                      child: Text(i.$1,
                          style: CpfSeguroType.labelSm.copyWith(
                              color: CpfSeguroColors.neutral03,
                              fontFamily: 'monospace',
                              letterSpacing: 0)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(i.$2,
                          style: CpfSeguroType.bodySm.copyWith(
                              color: CpfSeguroColors.neutral04, height: 1.3)),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _IllustrationSection extends StatelessWidget {
  const _IllustrationSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'ILLUSTRATIONACCESSORY · dimensiona o token de ilustração',
      role: 'Átomo que consome o token Illustration e só o dimensiona '
          '(sm/md/lg/xl). Hero de vazio/sucesso/erro. Igual Icon ↔ IconAccessory.',
      composedOf: const ['Illustration', 'Color'],
      child: const CpfSeguroIllustrationAccessory(
          illustration: CpfSeguroIllustration.fingerprint,
          size: CpfSeguroIllustrationSize.md),
    );
  }
}

class _GlassSurfaceSection extends StatelessWidget {
  const _GlassSurfaceSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'GLASSSURFACE · white 80% + blur 10 (característica de containers)',
      specId: 'design-system-glass-surface',
      whenUse: 'como fill de CONTAINER de chrome (top bar, bottom bar, toast, '
          'sheet) — nunca de um elemento solto. Glass é característica do '
          'container acima do elemento.',
      dos: const [
        'Aplicar no container (via TopAppBar.app / BottomApp / Toast).',
        'Garantir conteúdo ROLANDO ATRÁS pra ter o que desfocar.',
        'extendBody / extendBodyBehindAppBar pra o conteúdo passar sob a barra.',
      ],
      donts: const [
        'Glass num elemento isolado (StatusBar/HomeIndicator sozinhos não são glass).',
        'Glass sem conteúdo atrás (fica branco no branco).',
      ],
      role: 'Superfície de vidro (white 80% + blur 10) — característica de container (top/bottom app), não de elemento.',
      composedOf: const ['Color'],
      child: SizedBox(
        width: 393, height: 120,
        child: Stack(children: [
          Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: CpfSeguroGradients.brandLift))),
          const Center(
            child: SizedBox(
              width: 300, height: 60,
              child: CpfSeguroGlassSurface(child: Center(child: Text('CpfSeguroGlassSurface', style: TextStyle(color: CpfSeguroColors.neutral02)))),
            ),
          ),
        ]),
      ),
    );
  }
}

class _StatusBarSection extends StatelessWidget {
  const _StatusBarSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'STATUSBAR · 9:41 + signal/wifi/battery (elemento iOS)',
      composedOf: const ['Color', 'Typography'],
      child: SizedBox(
        width: 393,
        child: DecoratedBox(
          decoration: BoxDecoration(color: CpfSeguroColors.white, borderRadius: CpfSeguroRadius.all8),
          child: const CpfSeguroStatusBar(),
        ),
      ),
    );
  }
}

class _BottomHomeIndicatorSection extends StatelessWidget {
  const _BottomHomeIndicatorSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'BOTTOMHOMEINDICATOR · pill do gesto iOS (bg opcional)',
      specId: 'design-system-bottom-home-indicator',
      whenUse: 'o slot do gesture bar do iOS no rodapé das barras. Adaptativo: no '
          'device usa o inset REAL do SO; no catálogo desenha o pill de fidelidade.',
      dos: const [
        'Deixar o BottomApp gerenciar (não usar solto).',
        'Recolher com o teclado aberto (já é automático).',
      ],
      donts: const [
        'Desenhar pill fake no device (duplica o gesture bar do SO).',
        'Usar como espaçador genérico.',
      ],
      composedOf: const ['Color', 'Radius'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('standalone (sem bg)', style: TextStyle(fontSize: 11, color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 4),
          SizedBox(width: 393, child: DecoratedBox(
            decoration: BoxDecoration(color: CpfSeguroColors.neutral10, borderRadius: CpfSeguroRadius.all8),
            child: const CpfSeguroBottomHomeIndicator(),
          )),
          const SizedBox(height: 16),
          const Text('sobre numpad (background: neutral08)', style: TextStyle(fontSize: 11, color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 4),
          const SizedBox(width: 393, child: CpfSeguroBottomHomeIndicator(background: CpfSeguroColors.neutral08)),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'AVATAR · círculo 40 com iniciais',
      specId: 'design-system-avatar',
      whenUse: 'representar a PESSOA — foto do perfil, ou iniciais quando não há '
          'foto.',
      dos: const [
        'Iniciais do nome (até 2 letras) quando sem foto.',
        'Tamanho consistente com o contexto.',
      ],
      donts: const [
        'Avatar pra ícone genérico (isso é SpotIcon).',
        'Mais de 2 letras nas iniciais.',
      ],
      role: 'Iniciais em círculo — pessoa/contato sem foto.',
      composedOf: const ['Color', 'Typography'],
      child: Wrap(
        spacing: 12,
        children: const [
          CpfSeguroAvatar(initials: 'AM'),
          CpfSeguroAvatar(initials: 'JS', variant: CpfSeguroAvatarVariant.solid),
        ],
      ),
    );
  }
}

class _SpotIconSection extends StatelessWidget {
  const _SpotIconSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SPOTICON · círculo colorido (fill/outline × 8 states)',
      specId: 'design-system-spot-icon',
      whenUse: 'ícone em círculo colorido de destaque (accessory de linha, marcador '
          'semântico). fill/outline × 8 states de cor.',
      dos: const [
        'state casa com o tom semântico.',
        'fill pra ênfase; outline pra leve.',
        'Usar como left accessory da AppListRow.',
      ],
      donts: const [
        'SpotIcon como botão de ação (é identidade/decorativo).',
        'Cor fora dos states.',
      ],
      role: 'Ícone em círculo colorido — o ornamento à esquerda de row/menu; a cor carrega o estado.',
      composedOf: const ['Icon', 'Color'],
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: const [
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight),
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, state: CpfSeguroSpotState.primary),
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, state: CpfSeguroSpotState.error),
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, state: CpfSeguroSpotState.success),
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, state: CpfSeguroSpotState.warning),
          CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, type: CpfSeguroSpotType.outline, state: CpfSeguroSpotState.primary),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Moléculas que compõem os organismos TopAppBar e BottomApp
// ═══════════════════════════════════════════════════════════════════════════

class _NavSection extends StatelessWidget {
  const _NavSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'NAV · tabs do rodapé (4 tabs · cada uma selectable)',
      specId: 'design-system-nav',
      whenUse: 'a navegação GLOBAL entre raízes (Home, Sou eu, Carteira, CPF '
          'Seguro). Vive na bottom bar em glass, com pop-out no item ativo.',
      dos: const [
        '.items pra tabs configuráveis + activeIndex + onIndexChanged.',
        'Até ~5 tabs (idioma de bottom nav).',
      ],
      donts: const [
        'Nav pra uma ação (navegação, não CTA).',
        'Muitas tabs — repense a IA acima de 5.',
      ],
      composedOf: const ['Icon', 'Color', 'Typography'],
      child: SizedBox(
        width: 393,
        child: const CpfSeguroNav(activeTab: CpfSeguroNavTab.home),
      ),
    );
  }
}

class _KeyboardSection extends StatelessWidget {
  const _KeyboardSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'KEYBOARD · numpad iOS (0-9 + labels ABC/DEF + backspace)',
      composedOf: const ['Color', 'Typography', 'Radius', 'Shadow'],
      child: SizedBox(
        width: 393,
        child: CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
      ),
    );
  }
}

class _ChatInputSection extends StatelessWidget {
  const _ChatInputSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'CHATINPUT · input + eye + send + errorText + checkbox (5 variantes)',
      composedOf: const ['Field', 'Icon', 'StatusTag', 'Checkbox', 'Color', 'Typography', 'Radius', 'Shadow'],
      specId: 'design-system-chat-input',
      whenUse: 'a barra de entrada dos fluxos de chat/onboarding — um campo por '
          'vez com botão enviar. Vive no bottom via BottomApp.chatInput.',
      dos: const [
        'Uma pergunta por vez (o chat guia o preenchimento).',
        'Validação/erro resolvidos no wrapper; passe só errorText.',
        'password + eye pra campos sensíveis (senha).',
        'Ancorar em BottomApp.chatInput (glass + home indicator).',
      ],
      donts: const [
        'Empilhar vários ChatInput na mesma tela (não é formulário).',
        'Montar EditableText/overlay na mão — o átomo Field resolve.',
        'Deixar o send ativo sem valor válido (use sendDisabled).',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('default (fill white)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(controller: TextEditingController(text: 'olá'), sendReady: true),
          )),
          const SizedBox(height: 16),
          Text('password (com toggle eye)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(controller: TextEditingController(text: '••••••'), password: true, sendReady: true),
          )),
          const SizedBox(height: 16),
          Text('disabled (fill neutral-10)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(controller: TextEditingController(text: 'olá'), disabled: true),
          )),
          const SizedBox(height: 16),
          Text('error (errorText → StatusTag danger em cima + border error)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(
              controller: TextEditingController(),
              placeholder: 'Envie seus dados',
              errorText: 'A data é inválida. Confira e tente novamente.',
            ),
          )),
          const SizedBox(height: 16),
          Text('checkbox (chip abaixo do input, ex: "Não há X")', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(
              controller: TextEditingController(),
              placeholder: 'Envie seus dados',
              checkbox: CpfSeguroChatInputCheckbox(
                label: 'Não há nome da mãe no documento',
                checked: false,
                onChanged: (_) {},
              ),
            ),
          )),
          const SizedBox(height: 16),
          Text('error + checkbox (combinação)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CpfSeguroChatInput(
              controller: TextEditingController(),
              placeholder: 'Envie seus dados',
              errorText: 'A data é inválida. Confira e tente novamente.',
              checkbox: CpfSeguroChatInputCheckbox(
                label: 'Não há nome da mãe no documento',
                checked: false,
                onChanged: (_) {},
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _NavigationButtonSection extends StatelessWidget {
  const _NavigationButtonSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'NAVIGATIONBUTTON · 1/2/3 CTAs empilhados (conteúdo do BottomApp.button)',
      composedOf: const ['Button'],
      specId: 'design-system-navigation-button',
      whenUse: 'o rodapé de ação de um fluxo — 1 a 3 CTAs empilhados. Sempre '
          'dentro de CpfSeguroBottomApp.button (ele dá o glass + safe area).',
      dos: const [
        'primary no topo; secondary/tertiary abaixo.',
        'Máximo 3 ações — acima disso, repense a tela.',
        'Envolva em BottomApp.button pra virar rodapé real.',
      ],
      donts: const [
        'Usar solto no meio do content (é rodapé fixo).',
        'Duas primary competindo.',
        'Empilhar Buttons na mão em vez de usar este contrato.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1 CTA (primary)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const SizedBox(width: 393, child: CpfSeguroNavigationButton(
            primary: CpfSeguroNavigationAction(label: 'Continuar'),
          )),
          const SizedBox(height: 24),
          Text('2 CTAs (primary + secondary)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const SizedBox(width: 393, child: CpfSeguroNavigationButton(
            primary: CpfSeguroNavigationAction(label: 'Salvar'),
            secondary: CpfSeguroNavigationAction(label: 'Cancelar'),
          )),
          const SizedBox(height: 24),
          Text('3 CTAs (primary + secondary + tertiary)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const SizedBox(width: 393, child: CpfSeguroNavigationButton(
            primary: CpfSeguroNavigationAction(label: 'Confirmar'),
            secondary: CpfSeguroNavigationAction(label: 'Editar'),
            tertiary: CpfSeguroNavigationAction(label: 'Cancelar'),
          )),
        ],
      ),
    );
  }
}

class _NavigationLeftAccessorySection extends StatelessWidget {
  const _NavigationLeftAccessorySection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'NAVIGATIONLEFTACCESSORY · back / close / home',
      specId: 'design-system-navigation-left-accessory',
      whenUse: 'o acessório esquerdo da top bar: back (voltar na pilha), close '
          '(fechar sheet/fluxo) ou home (saudação + avatar/perfil na raiz).',
      dos: const [
        'back pra navegação de pilha; close pra sheet/modal/fluxo.',
        'home só na tela raiz (saudação + acesso ao perfil).',
      ],
      donts: const [
        'back e close ao mesmo tempo.',
        'home fora da raiz.',
      ],
      composedOf: const ['IconButton', 'Avatar', 'Icon', 'Typography'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('.back()', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const CpfSeguroNavigationLeftAccessory.back(),
          const SizedBox(height: 16),
          Text('.close()', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const CpfSeguroNavigationLeftAccessory.close(),
          const SizedBox(height: 16),
          Text('.home(firstName: "Ana")', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const CpfSeguroNavigationLeftAccessory.home(firstName: 'Ana'),
        ],
      ),
    );
  }
}

class _NavigationRightAccessorySection extends StatelessWidget {
  const _NavigationRightAccessorySection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'NAVIGATIONRIGHTACCESSORY · 1/2/3 icons ou buttonTertiarySmall',
      specId: 'design-system-navigation-right-accessory',
      whenUse: 'os acessórios direitos da top bar: até 3 ícones de ação (sino, '
          'olho) OU um botão tertiary small.',
      dos: const [
        'Máximo 3 ícones; semanticLabel em cada.',
        'Ação secundária como buttonTertiarySmall.',
      ],
      donts: const [
        'Mais de 3 ícones (polui o topo).',
        'CTA principal aqui — a ação principal vive na bottom bar.',
      ],
      composedOf: const ['IconButton', 'Button'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('.icons([1])', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          CpfSeguroNavigationRightAccessory.icons(icons: [
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações'),
          ]),
          const SizedBox(height: 16),
          Text('.icons([2])', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          CpfSeguroNavigationRightAccessory.icons(icons: [
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.eyeLight, semanticLabel: 'Ocultar'),
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações', badge: true),
          ]),
          const SizedBox(height: 16),
          Text('.icons([3])', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          CpfSeguroNavigationRightAccessory.icons(icons: [
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.magnifyingGlassLight, semanticLabel: 'Buscar'),
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.eyeLight, semanticLabel: 'Ocultar'),
            CpfSeguroNavRightIcon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações'),
          ]),
          const SizedBox(height: 16),
          Text('.buttonTertiarySmall(label: "Ajuda")', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const CpfSeguroNavigationRightAccessory.buttonTertiarySmall(label: 'Ajuda'),
        ],
      ),
    );
  }
}

class _NavigationTopBarSection extends StatelessWidget {
  const _NavigationTopBarSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'NAVIGATIONTOPBAR · linha left + title + right (altura 52, sem glass)',
      specId: 'design-system-navigation-top-bar',
      whenUse: 'o CONTEÚDO da top bar: acessório esquerdo + título + acessórios '
          'direitos. Sem glass (o glass vem do TopAppBar/Surface).',
      dos: const [
        'left = NavigationLeftAccessory; right = NavigationRightAccessory.',
        'Título curto e central quando houver.',
      ],
      donts: const [
        'Montar a linha na mão (Row de ícones + texto).',
        'Aplicar glass aqui (é do container acima).',
      ],
      composedOf: const ['NavigationLeftAccessory', 'NavigationRightAccessory', 'Typography'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('back + title + button tertiary small', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: DecoratedBox(
            decoration: BoxDecoration(color: CpfSeguroColors.white, borderRadius: BorderRadius.circular(8)),
            child: const CpfSeguroNavigationTopBar(
              left: CpfSeguroNavigationLeftAccessory.back(),
              title: 'Alterar senha',
              right: CpfSeguroNavigationRightAccessory.buttonTertiarySmall(label: 'Salvar'),
            ),
          )),
          const SizedBox(height: 16),
          Text('home + right icons (2)', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          SizedBox(width: 393, child: DecoratedBox(
            decoration: BoxDecoration(color: CpfSeguroColors.white, borderRadius: BorderRadius.circular(8)),
            child: CpfSeguroNavigationTopBar(
              left: const CpfSeguroNavigationLeftAccessory.home(firstName: 'Ana'),
              centerAlign: TextAlign.start,
              right: CpfSeguroNavigationRightAccessory.icons(icons: const [
                CpfSeguroNavRightIcon(icon: CpfSeguroIcons.eyeLight, semanticLabel: 'Ocultar'),
                CpfSeguroNavRightIcon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações', badge: true),
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

class _StepperSection extends StatelessWidget {
  const _StepperSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'STEPPER · "{label} · Passo X de Y" + segmentos coloridos',
      composedOf: const ['Color', 'Typography', 'Radius'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('com labelText simples', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 8),
          const SizedBox(width: 393, child: CpfSeguroStepper(
            current: 3,
            total: 4,
            labelText: 'CADASTRO',
          )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SectionHeader
// ═══════════════════════════════════════════════════════════════════════════

class _SectionHeaderSection extends StatelessWidget {
  const _SectionHeaderSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SECTIONHEADER · eyebrow de seção + trailing opcional',
      specId: 'design-system-section-header',
      whenUse: 'o cabeçalho (label em caps) acima de uma lista/seção, com ação '
          'trailing opcional ("Ver tudo").',
      dos: const [
        'Label curto em caps.',
        'trailing = SeeAllLink pra "ver tudo".',
      ],
      donts: const [
        'SectionHeader como título de tela (isso é PageTitle).',
        'Usar em empty-state/appbar/interior de card.',
      ],
      role: 'Eyebrow de seção — nomeia um grupo de rows.',
      composedOf: const ['Color', 'Typography'],
      child: SizedBox(
        width: 393,
        child: Column(children: const [
          CpfSeguroSectionHeader(label: 'ACESSO RÁPIDO'),
          SizedBox(height: 8),
          CpfSeguroSectionHeader(label: 'PARA VOCÊ', trailing: CpfSeguroSeeAllLink()),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FeatureCard
// ═══════════════════════════════════════════════════════════════════════════

class _FeatureCardSection extends StatelessWidget {
  const _FeatureCardSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'FEATURECARD · card 150×150 do carrossel "PARA VOCÊ"',
      specId: 'design-system-feature-card',
      whenUse: 'card de destaque do carrossel "PARA VOCÊ" (tile de ícone + '
          'título + estado em overlay). Não é item de lista.',
      dos: const [
        'statusOverlay pra o estado (a máquina de estado fica no wrapper).',
        'brandColor alimentado pelo state.',
        'Título curto.',
      ],
      donts: const [
        'FeatureCard pra linha de lista repetível (isso é AppListRow).',
        'Texto longo que estoura o card.',
      ],
      composedOf: const ['Icon', 'StatusTag', 'Color', 'Gradients', 'Typography', 'Radius'],
      child: Wrap(spacing: 12, runSpacing: 12, children: const [
        CpfSeguroFeatureCard(
          icon: CpfSeguroIcons.fingerprintLight,
          title: 'Sou eu!',
          brandColor: CpfSeguroColors.primary04,
          status: CpfSeguroStatusTagData(label: 'Limitado', tone: CpfSeguroStatusTone.warning),
          description: 'Login · Autenticar',
          actionLabel: 'Ativar login por código',
        ),
        CpfSeguroFeatureCard(
          icon: CpfSeguroIcons.idCardLight,
          title: 'CPF Seguro',
          brandColor: CpfSeguroColors.neutral04,
          status: CpfSeguroStatusTagData(label: 'Te esperando', tone: CpfSeguroStatusTone.neutral, icon: CpfSeguroIcons.lockLight),
          description: 'Pausar CPF',
          actionLabel: 'Ativar Pausa',
        ),
        CpfSeguroFeatureCard(
          icon: CpfSeguroIcons.walletLight,
          title: 'Carteira',
          brandColor: CpfSeguroColors.warning04,
          status: CpfSeguroStatusTagData(label: 'Em breve', tone: CpfSeguroStatusTone.warning, icon: CpfSeguroIcons.lockLight),
          description: 'Cartões num só lugar.',
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QuickAccessCard
// ═══════════════════════════════════════════════════════════════════════════

class _QuickAccessCardSection extends StatelessWidget {
  const _QuickAccessCardSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'QUICKACCESSCARD · mini card 75×84 "ACESSO RÁPIDO" · 2 states',
      specId: 'design-system-quick-access-card',
      whenUse: 'mini-card de atalho (ícone + label curto) da grade "ACESSO '
          'RÁPIDO". 2 states: active (disponível) / inactive.',
      dos: const [
        'Label curto (nowrap; quebra só com \\n).',
        'state active no disponível; lock badge no inactive.',
      ],
      donts: const [
        'QuickAccessCard como CTA principal (é atalho).',
        'Label longo que não cabe no 75×84.',
      ],
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: Wrap(spacing: 16, runSpacing: 16, children: [
        _labeled('active', const CpfSeguroQuickAccessCard(
          icon: CpfSeguroIcons.receiptLight, label: 'Histórico', state: CpfSeguroQuickAccessState.active)),
        _labeled('inactive + lock', const CpfSeguroQuickAccessCard(
          icon: CpfSeguroIcons.usersLight, label: 'Contatos', state: CpfSeguroQuickAccessState.inactive)),
      ]),
    );
  }

  Widget _labeled(String label, Widget child) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      child,
      const SizedBox(height: 6),
      Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EmptyState
// ═══════════════════════════════════════════════════════════════════════════

class _CriteriaListSection extends StatelessWidget {
  const _CriteriaListSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'CRITERIALIST · regras/validações com estado',
      specId: 'design-system-criteria-list',
      whenUse: 'lista de regras/validações com estado (ok/fail/pending) — '
          'critérios de senha. Reage à digitação.',
      dos: const [
        'marker por estado (ok/fail/pending).',
        'Atualizar o estado conforme o usuário digita.',
      ],
      donts: const [
        'CriteriaList como checklist interativo (isso é Checkbox).',
        'Estado estático quando deveria reagir à entrada.',
      ],
      role: 'Lista de critérios com marker (ok/fail/pending) — requisitos de '
          'senha, checagens de formulário. Extraído do ChatCriteriaBubble; '
          'consumido também por ele e pelo PasswordBottomSheet.',
      composedOf: const ['IconAccessory', 'Color', 'Typography'],
      child: const SizedBox(
        width: 280,
        child: CpfSeguroCriteriaList(items: [
          CpfSeguroCriteriaItem(
              label: 'Mínimo 8 caracteres',
              status: CpfSeguroCriteriaStatus.ok),
          CpfSeguroCriteriaItem(
              label: 'Uma letra maiúscula',
              status: CpfSeguroCriteriaStatus.ok),
          CpfSeguroCriteriaItem(
              label: 'Um número', status: CpfSeguroCriteriaStatus.fail),
          CpfSeguroCriteriaItem(label: 'Um caractere especial'),
        ]),
      ),
    );
  }
}

class _EmptyStateSection extends StatelessWidget {
  const _EmptyStateSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'EMPTYSTATE · card de lista vazia (Atividade Recente)',
      specId: 'design-system-empty-state',
      whenUse: 'estado vazio ou de erro de uma lista/tela (Atividade vazia, sem '
          'conexão) — ilustração + texto que orienta + ação opcional de saída.',
      dos: const [
        'Ilustração por token + mensagem que orienta o próximo passo.',
        'Ação de saída quando faz sentido (tentar de novo, criar).',
      ],
      donts: const [
        'EmptyState como loading (isso é Skeleton).',
        'Mensagem que culpa o usuário; prefira orientar.',
      ],
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: const SizedBox(
        width: 360,
        child: CpfSeguroEmptyState(
          title: 'Nenhuma ação ainda',
          caption: 'Quando o CPF for usado em um parceiro, o registro aparece aqui.',
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OfflinePill
// ═══════════════════════════════════════════════════════════════════════════

class _OfflinePillSection extends StatelessWidget {
  const _OfflinePillSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'OFFLINEPILL · aviso de conectividade acima do banner',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: const SizedBox(width: 360, child: CpfSeguroOfflinePill()),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// InputChip
// ═══════════════════════════════════════════════════════════════════════════

class _InfoChipSection extends StatelessWidget {
  const _InfoChipSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'INFOCHIP · pill informativo (light / onColor)',
      specId: 'design-system-info-chip',
      whenUse: 'para um pill DECORATIVO/informativo sobre uma superfície (badge '
          '"Novo", rótulo curto), sem semântica de estado nem filtro.',
      dos: const [
        'light em superfície clara; onColor sobre cor.',
        'Texto curto (uma palavra/rótulo).',
      ],
      donts: const [
        'InfoChip pra estado semântico (isso é StatusTag).',
        'InfoChip pra filtro removível (isso é InputChip).',
      ],
      role: 'Badge decorativo (ícone + label), não-interativo. Distinto do '
          'StatusTag (estado semântico) e do InputChip (filtro). onColor assenta '
          'sobre superfície colorida (card de nível, banner).',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: Row(
        children: [
          const CpfSeguroInfoChip(
              label: 'Nível 2', icon: CpfSeguroIcons.circleCheckSolid),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CpfSeguroColors.primary04,
              borderRadius: CpfSeguroRadius.all16,
            ),
            child: const CpfSeguroInfoChip(
              label: 'Próximo nível',
              icon: CpfSeguroIcons.lockLight,
              tone: CpfSeguroInfoChipTone.onColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputChipSection extends StatelessWidget {
  const _InputChipSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'INPUTCHIP · dropdown de contexto + filtro removível',
      role: 'Chip de contexto/filtro — dropdown "Meu CPF", filtro removível "15 dias".',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      specId: 'design-system-input-chip',
      whenUse: 'para um filtro/contexto ativo e removível (período, categoria) ou '
          'um seletor compacto inline. filled = selecionado.',
      dos: const [
        'trailIcon x pra remover o filtro; leadIcon pra ícone de contexto.',
        'filled quando ativo/selecionado; outline quando não.',
        'Texto curto (o valor do filtro), não uma frase.',
      ],
      donts: const [
        'InputChip como CTA (é filtro/contexto, não ação).',
        'Confundir com InfoChip (decorativo) ou StatusTag (semântico).',
      ],
      child: Wrap(spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
        CpfSeguroInputChip(label: 'Meu CPF', trailIcon: CpfSeguroIcons.chevronDownLight, onTap: _noop),
        CpfSeguroInputChip(label: 'Esposa', trailIcon: CpfSeguroIcons.chevronDownLight, onTap: _noop),
        CpfSeguroInputChip(label: '15 dias', trailIcon: CpfSeguroIcons.circleMinusLight, filled: true, onTap: _noop),
        const CpfSeguroInputChip(label: 'sem ícone'),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SearchInput
// ═══════════════════════════════════════════════════════════════════════════

class _SearchInputSection extends StatefulWidget {
  const _SearchInputSection();
  @override
  State<_SearchInputSection> createState() => _SearchInputSectionState();
}

class _SearchInputSectionState extends State<_SearchInputSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SEARCHINPUT · busca com ícone (lista de Atividade)',
      role: 'Busca — filtrar histórico, lista.',
      composedOf: const ['Field', 'Icon', 'Color', 'Typography', 'Radius'],
      specId: 'design-system-search-input',
      whenUse: 'para filtrar uma lista/histórico por texto. É busca, não um campo '
          'de formulário — sem label, com ícone de lupa e placeholder.',
      dos: const [
        'Placeholder que diz o que busca ("Buscar atividade").',
        'Filtra a lista ao digitar (onChanged) — resultado imediato.',
        'Um por contexto de lista.',
      ],
      donts: const [
        'Usar SearchInput pra entrada de formulário (isso é Input).',
        'Colar um label em cima — busca não leva label.',
        'Deixar sem feedback quando não há resultado (use EmptyState).',
      ],
      child: SizedBox(width: 360, child: CpfSeguroSearchInput(controller: _controller)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Tooltip
// ═══════════════════════════════════════════════════════════════════════════

class _TooltipSection extends StatelessWidget {
  const _TooltipSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'TOOLTIP · dark/light × small/large × 4 sides',
      specId: 'design-system-tooltip',
      whenUse: 'explicação curta ancorada num alvo (o "?" ao lado de um label). '
          'Modo interativo (child) embrulha o gatilho.',
      dos: const [
        'Texto curto e complementar.',
        'side que não cobre o alvo.',
        'child pra usar o engine de tooltip da plataforma.',
      ],
      donts: const [
        'Conteúdo ESSENCIAL num tooltip (fica escondido).',
        'Texto longo — vira sheet/página.',
      ],
      composedOf: const ['Color', 'Typography', 'Radius'],
      child: Wrap(spacing: 24, runSpacing: 16, crossAxisAlignment: WrapCrossAlignment.center, children: const [
        CpfSeguroTooltip(label: 'dark · top'),
        CpfSeguroTooltip(label: 'bottom', side: CpfSeguroTooltipSide.bottom),
        CpfSeguroTooltip(label: 'light', style: CpfSeguroTooltipStyle.light),
        CpfSeguroTooltip(label: 'sem tail', tail: false),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// StatusBanner (organismo)
// ═══════════════════════════════════════════════════════════════════════════

class _PickersSection extends StatefulWidget {
  const _PickersSection();
  @override
  State<_PickersSection> createState() => _PickersSectionState();
}

class _PickersSectionState extends State<_PickersSection> {
  String? _tipo;
  DateTime? _data;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'DROPDOWN & DATA · seleção de lista / de data',
      role: 'Dropdown = OUTRA forma de entrada: escolher de uma lista fechada '
          '(não digitar). Gatilho com cara de Input + chevron; seleção num '
          'bottomsheet (idioma mobile, HIG/Material). DateField = Input + ícone '
          'de calendário que abre o Calendar (grid mensal, Flutter puro).',
      composedOf: const ['Input', 'Calendar', 'Icon', 'Color', 'Typography', 'Radius', 'Motion'],
      whenUse: 'Dropdown = escolher de lista FECHADA (não digitar); DateField = '
          'escolher data. Ambos são Input readOnly + gatilho que abre um '
          'bottomsheet. Contratos: design-system-{dropdown,date-field,calendar}.',
      dos: const [
        'Dropdown pra conjunto fechado de opções (não texto livre).',
        'DateField pra data — nunca peça o usuário digitar dd/mm/aaaa à mão.',
        'sheetTitle dizendo a decisão no bottomsheet.',
        'error inline igual ao Input (mesma gramática de campo).',
      ],
      donts: const [
        'Dropdown pra texto livre (isso é Input).',
        'Reimplementar o campo readOnly na mão — reuse Dropdown/DateField.',
        'Calendar solto sem o gatilho DateField num formulário.',
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CpfSeguroDropdown(
            label: 'Tipo de chave',
            placeholder: 'Selecione',
            value: _tipo,
            items: const ['CPF', 'Celular', 'E-mail', 'Chave aleatória'],
            onChanged: (v) => setState(() => _tipo = v),
          ),
          const SizedBox(height: 16),
          CpfSeguroDateField(
            label: 'Data de nascimento',
            value: _data,
            firstDay: DateTime(1900),
            lastDay: DateTime.now(),
            onChanged: (d) => setState(() => _data = d),
          ),
          const SizedBox(height: 24),
          Text('Calendar embutido:', style: CpfSeguroType.label.copyWith(color: CpfSeguroColors.neutral03)),
          const SizedBox(height: 8),
          CpfSeguroCalendar(
            selectedDate: _data,
            firstDay: DateTime(1900),
            lastDay: DateTime.now(),
            onDateSelected: (d) => setState(() => _data = d),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Sheets e overlays
// ═══════════════════════════════════════════════════════════════════════════

class _SheetsSection extends StatelessWidget {
  const _SheetsSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'SHEETS · ExitConfirm / PasswordBottomSheet / BiometriaOverlay',
      specId: 'design-system-sheet-overlay',
      whenUse: 'sheets/overlays modais (confirmar saída, senha, biometria). Todos '
          'são a mesma gramática Surface.sheet sobre um overlay (scrim + slide).',
      dos: const [
        'Reusar a gramática Surface.sheet (top grip+close / content / bottom).',
        'Scrim que fecha ao tocar fora, quando não-bloqueante.',
        'CTA no bottom via NavigationButton.',
      ],
      donts: const [
        'Reimplementar scaffold de sheet por tela (use o overlay do DS).',
        'Empilhar sheets sem hierarquia clara.',
      ],
      composedOf: const ['GlassSurface', 'Button', 'OtpInput', 'Keyboard', 'Icon', 'Color', 'Radius'],
      child: Wrap(spacing: 24, runSpacing: 24, children: [
        _framed('ExitConfirmSheet', CpfSeguroExitConfirmSheet(open: true, onClose: _noop, onConfirm: _noop)),
        _framed('PasswordBottomSheet', CpfSeguroPasswordBottomSheet(open: true, onClose: _noop, onSubmit: (_) {})),
        _framed('BiometriaOverlay', CpfSeguroBiometriaOverlay(open: true, autoSuccess: false, onSuccess: _noop, onCancel: _noop)),
      ]),
    );
  }

  Widget _framed(String label, Widget sheet) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 320,
        height: 560,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: CpfSeguroColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
        ),
        // O sheet já é Positioned.fill-rooted (CpfSeguroSheetOverlay); embrulhar
        // em outro Positioned.fill criava dois Positioned competindo no mesmo
        // RenderObject e quebrava o layout. Vai direto como filho do Stack.
        child: Stack(children: [sheet]),
      ),
      const SizedBox(height: 8),
      Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AmountDisplay
// ═══════════════════════════════════════════════════════════════════════════

class _AmountDisplaySection extends StatelessWidget {
  const _AmountDisplaySection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'AMOUNTDISPLAY · valor entre hairlines (detalhe de transação)',
      specId: 'design-system-amount-display',
      whenUse: 'o valor em DESTAQUE (hero, entre hairlines) num detalhe de '
          'transação/saldo, com onTap/chevron opcional.',
      dos: const [
        'Hero do valor no detalhe/saldo.',
        'obscure/format/loading resolvidos no consumidor.',
      ],
      donts: const [
        'AmountDisplay numa linha de lista (isso é Amount).',
      ],
      composedOf: const ['Color', 'Typography'],
      child: const SizedBox(
        width: 360,
        child: CpfSeguroAmountDisplay(value: 'R\$ 560,00', timestamp: '13/10/2023 as 14:25'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DetailRow
// ═══════════════════════════════════════════════════════════════════════════

class _DetailRowSection extends StatelessWidget {
  const _DetailRowSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'DETAILROW · label/descrição + hairline · chevron opcional',
      specId: 'design-system-detail-row',
      whenUse: 'linha label/valor de um comprovante ou bloco de detalhe '
          '(horizontal: label esquerda, valor direita), hairline entre linhas.',
      dos: const [
        'label à esquerda, valor à direita.',
        'chevron opcional só se a linha for tocável.',
      ],
      donts: const [
        'DetailRow como item de lista navegável repetível (isso é AppListRow).',
        'Muitos DetailRows onde uma tabela comunica melhor.',
      ],
      composedOf: const ['Icon', 'Color', 'Typography'],
      child: SizedBox(
        width: 360,
        child: Column(children: [
          const CpfSeguroDetailRow(title: 'Rede', description: 'Mastercard'),
          const CpfSeguroDetailRow(icon: CpfSeguroIcons.mobileLight, title: '•••• 7654', description: 'Com spot icon à esquerda'),
          const CpfSeguroDetailRow(
            title: '•••• 7665',
            description: 'Use os quatro últimos dígitos para identificar as transações feitas com o cartão físico',
          ),
          CpfSeguroDetailRow(title: 'Entre em contato com Swile', chevron: true, onTap: _noop, hairline: false),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// InfoCard
// ═══════════════════════════════════════════════════════════════════════════

class _InfoCardSection extends StatelessWidget {
  const _InfoCardSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'INFOCARD · card borda · ícone + título + StatusTag opcional + descrição',
      specId: 'design-system-info-card',
      whenUse: 'bloco informativo destacado com borda: ícone + título + '
          'StatusTag opcional + descrição. Um destaque, não uma lista.',
      dos: const [
        'StatusTag opcional pra estado do bloco.',
        'Título + descrição curta.',
      ],
      donts: const [
        'InfoCard repetido como se fosse lista (isso é AppList).',
        'InfoCard sem título (vira card vazio).',
      ],
      composedOf: const ['Icon', 'StatusTag', 'Color', 'Typography'],
      child: SizedBox(
        width: 420,
        child: Column(children: const [
          CpfSeguroInfoCard(
            icon: CpfSeguroIcons.walletLight,
            title: 'Carteira digital',
            description: 'Todos os seus cartões num só lugar, com segurança.',
            status: CpfSeguroStatusTagData(label: 'Disponível', tone: CpfSeguroStatusTone.success),
          ),
          SizedBox(height: 12),
          CpfSeguroInfoCard(
            icon: CpfSeguroIcons.usersLight,
            title: 'Sou eu',
            description: 'Autentique-se de forma rápida e sem fricção.',
            status: CpfSeguroStatusTagData(label: 'Em breve', tone: CpfSeguroStatusTone.primary),
          ),
          SizedBox(height: 12),
          CpfSeguroInfoCard(
            icon: CpfSeguroIcons.lockLight,
            title: 'CPF Seguro',
            description: 'Pause e despause seu CPF para evitar golpes e uso indevido dos seus dados.',
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FaceIdCard
// ═══════════════════════════════════════════════════════════════════════════

class _FaceIdCardSection extends StatelessWidget {
  const _FaceIdCardSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'FACEIDCARD · biometria inline do fluxo Pagar',
      composedOf: const ['Icon', 'Color', 'Typography', 'Radius'],
      child: const CpfSeguroFaceIdCard(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppListDayGroup
// ═══════════════════════════════════════════════════════════════════════════

class _DayGroupSection extends StatelessWidget {
  const _DayGroupSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'APPLISTDAYGROUP · grupo flat por dia · divider entre itens e no item único',
      specId: 'design-system-day-group',
      whenUse: 'agrupar linhas de lista por DIA (extrato, atividade), com header '
          'de data e divider entre os itens do grupo.',
      dos: const [
        'Header com a data do grupo.',
        'AppListRows agrupadas sob o dia.',
      ],
      donts: const [
        'DayGroup pra agrupamento não-temporal (use as seções do AppList).',
        'Grupo sem data.',
      ],
      composedOf: const ['AppList', 'Color', 'Typography'],
      child: SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CpfSeguroAppListDayGroup(label: 'Hoje', children: [
              CpfSeguroAppListRow.transactionItem(
                icon: CpfSeguroIcons.creditCardLight,
                title: 'Compra em Pague menos',
                source: 'Cartão •••• 7654',
                time: '12:04',
                amount: 'R\$ 560,00',
              ),
              CpfSeguroAppListRow.transactionItem(
                title: 'Pix aproximação',
                source: 'Directo Pagamentos',
                time: '11:32',
                amount: 'R\$ 35,00',
              ),
            ]),
            const SizedBox(height: 24),
            CpfSeguroAppListDayGroup(label: '14/05 · item único fecha com divider', children: [
              CpfSeguroAppListRow.transactionItem(
                title: 'Pix aproximação',
                source: 'Pague menos',
                time: '18:22',
                amount: 'R\$ 560,00',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Receipt (comprovante)
// ═══════════════════════════════════════════════════════════════════════════

class _ReceiptSection extends StatelessWidget {
  const _ReceiptSection();
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'RECEIPT · comprovante (compra no cartão / Pix aproximação)',
      specId: 'design-system-receipt',
      whenUse: 'o comprovante de uma transação (compra no cartão, Pix aproximação): '
          'cabeçalho + linhas label/valor + marca CPF.',
      dos: const [
        'DetailRow pras linhas label/valor.',
        'Marca CPF Seguro no rodapé do comprovante.',
      ],
      donts: const [
        'Receipt como card informativo genérico (isso é InfoCard).',
        'Montar as linhas na mão em vez de DetailRow.',
      ],
      composedOf: const ['Icon', 'Logo', 'Color', 'Typography', 'Radius'],
      child: SizedBox(
        width: 360,
        child: CpfSeguroReceipt(
          title: 'Comprovante\nde compra',
          timestamp: '13 Out 2023 - 17:43:12',
          rows: const [
            CpfSeguroReceiptRow(label: 'Valor', value: 'R\$ 560,00'),
            CpfSeguroReceiptRow(label: 'Tipo de pagamento', value: 'Cartão CPF Seguro'),
          ],
          sections: const [
            CpfSeguroReceiptSection(
              icon: CpfSeguroIcons.receiptLight,
              title: 'Estabelecimento',
              rows: [
                CpfSeguroReceiptRow(label: 'Nome', value: 'Pague menos'),
                CpfSeguroReceiptRow(label: 'CNPJ', value: '06.626.253/0001-51'),
              ],
            ),
            CpfSeguroReceiptSection(
              icon: CpfSeguroIcons.creditCardLight,
              title: 'Cartão',
              rows: [
                CpfSeguroReceiptRow(label: 'Origem', value: 'CPF Seguro •••• 7654'),
                CpfSeguroReceiptRow(label: 'Bandeira', value: 'Mastercard'),
              ],
            ),
          ],
          footerLines: const [
            'CPF Seguro - Instituição de pagamento',
            'CNPJ: 12.234.456.123/0001-58',
          ],
          transactionId: 'e00343456542444324453455666e3555434554',
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════

void _noop() {}
