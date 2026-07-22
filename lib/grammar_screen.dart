import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';

/// Aba GRAMÁTICA — as regras de COMPOSIÇÃO do DS (como as peças se juntam).
///
/// Quatro gramáticas:
/// 1. Camadas (composição vertical): token → átomo → molécula → organismo.
/// 2. Regra de ouro: componente consome role/intent, nunca cor crua.
/// 3. Superfície: CpfSeguroSurface(top/content/bottom).
/// 4. Linha: CpfSeguroAppListRow(left/middle/right).
class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CpfSeguroColors.neutral10,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 32, 40, 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gramática · a lógica de composição',
                    style: CpfSeguroType.title.copyWith(color: CpfSeguroColors.neutral01)),
                const SizedBox(height: 6),
                Text(
                  'Não é a lista de peças (isso é o Preview), é como elas se JUNTAM. '
                  'O DS tem regras de composição: as camadas atômicas, o consumo por role, '
                  'e duas gramáticas de layout (superfície e linha).',
                  style: CpfSeguroType.bodyMd.copyWith(color: CpfSeguroColors.neutral04, height: 1.5),
                ),
                const SizedBox(height: 32),

                const _LanguageModelBanner(),
                const SizedBox(height: 36),

                _SectionHead('1 · CAMADAS', 'Composição vertical — cada camada CONSOME a de baixo. Palavra maior é feita de palavras menores.'),
                const _Card(child: _LayersFlow()),
                const SizedBox(height: 36),

                _SectionHead('2 · REGRA DE OURO', 'Componente consome role/intent (semântica), nunca cor crua. É o que deixa dark/flavor/tema trocarem sem tocar no componente.'),
                const _Card(child: _RoleRule()),
                const SizedBox(height: 36),

                _SectionHead('3 · GRAMÁTICA DE SUPERFÍCIE', 'CpfSeguroSurface(top/content/bottom). Screen, modal e sheet são a mesma gramática com top/bottom diferentes.'),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 32, runSpacing: 24, crossAxisAlignment: WrapCrossAlignment.start, children: const [
                        _RegionDiagram(),
                        _RegionLegend(),
                      ]),
                      const SizedBox(height: 32),
                      Text('MESMA GRAMÁTICA, SUPERFÍCIES DIFERENTES',
                          style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral03)),
                      const SizedBox(height: 16),
                      Wrap(spacing: 32, runSpacing: 32, children: const [
                        _Example(
                          label: 'Screen',
                          caption: 'top: TopAppBar · content: rolável · bottom: Nav',
                          height: 560,
                          child: _ScreenExample(),
                        ),
                        _Example(
                          label: 'Sheet / Modal',
                          caption: 'top: grip+close · content · bottom: NavigationButton',
                          height: 440,
                          child: _SheetExample(),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                _SectionHead('4 · GRAMÁTICA DE LINHA', 'CpfSeguroAppListRow(left/middle/right). Cada slot recebe um átomo/sub-molécula. É a gramática por trás de AppList, MenuItem, ReadOnlyInput e InfoCard.'),
                const _Card(child: _RowGrammar()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Chrome compartilhado
// ═══════════════════════════════════════════════════════════════════════════

/// Modelo da linguagem em 3 camadas (Airbnb DLS / A Pattern Language): as 3
/// existem de verdade hoje — vocabulário (tokens DTCG), gramática (esta página),
/// dicionário (contratos OpenSpec + guidelines).
class _LanguageModelBanner extends StatelessWidget {
  const _LanguageModelBanner();

  static const _layers = <(String, String, String, Color)>[
    ('VOCABULÁRIO', 'tokens semânticos', 'DTCG · gerado (fonte única). "vermelho = erro" mora aqui.', CpfSeguroColors.primary04),
    ('GRAMÁTICA', 'composição', 'como as peças se juntam: camadas, role, superfície, linha. É esta página.', CpfSeguroColors.success04),
    ('DICIONÁRIO', 'contratos + guidelines', '1 spec OpenSpec por componente + quando usar / do & don\'t no catálogo.', CpfSeguroColors.warning04),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UM DS É UMA LINGUAGEM, NÃO UM CATÁLOGO',
              style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral03)),
          const SizedBox(height: 4),
          Text(
            'Três camadas — e as três existem hoje no DS:',
            style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final l in _layers)
                SizedBox(
                  width: 320,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CpfSeguroColors.neutral10,
                      borderRadius: CpfSeguroRadius.all8,
                      border: Border(left: BorderSide(color: l.$4, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(l.$1, style: CpfSeguroType.label.copyWith(color: l.$4, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Text(l.$2, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
                        ]),
                        const SizedBox(height: 6),
                        Text(l.$3, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03, height: 1.4)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead(this.over, this.desc);
  final String over;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(over, style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.primary04)),
        const SizedBox(height: 6),
        Text(desc, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.5)),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 1 · Camadas
// ═══════════════════════════════════════════════════════════════════════════

class _LayersFlow extends StatelessWidget {
  const _LayersFlow();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 16,
      children: const [
        _LayerNode(
          layer: 'TOKEN',
          example: 'Palette · Scheme\nRadius · Type',
          bg: CpfSeguroColors.neutral09,
          fg: CpfSeguroColors.neutral04,
        ),
        _Consome(),
        _LayerNode(
          layer: 'ÁTOMO',
          example: 'Icon · Button\nStatusTag · Avatar',
          bg: CpfSeguroColors.primary08,
          fg: CpfSeguroColors.primary04,
        ),
        _Consome(),
        _LayerNode(
          layer: 'MOLÉCULA',
          example: 'AppList · InfoCard\nDetailRow',
          bg: CpfSeguroColors.secure08,
          fg: CpfSeguroColors.secure03,
        ),
        _Consome(),
        _LayerNode(
          layer: 'ORGANISMO',
          example: 'Surface · TopAppBar\nSheet · Nav',
          bg: CpfSeguroColors.success07,
          fg: CpfSeguroColors.success04,
        ),
      ],
    );
  }
}

class _LayerNode extends StatelessWidget {
  const _LayerNode({required this.layer, required this.example, required this.bg, required this.fg});
  final String layer;
  final String example;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(layer, style: CpfSeguroType.labelMd.copyWith(color: fg, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(example, style: CpfSeguroType.bodySm.copyWith(color: fg, height: 1.4)),
      ]),
    );
  }
}

class _Consome extends StatelessWidget {
  const _Consome();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('consome', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        Text('→', style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral05)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 2 · Regra de ouro (role, não cor crua)
// ═══════════════════════════════════════════════════════════════════════════

class _RoleRule extends StatelessWidget {
  const _RoleRule();
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 20, runSpacing: 20, children: const [
      _RuleCard(
        ok: false,
        title: 'Nunca',
        code: "color: Color(0xFF003BE0)\ncolor: primary04  // cru",
        why: 'Prende o componente a um valor. Dark, flavor e tema não conseguem trocar.',
      ),
      _RuleCard(
        ok: true,
        title: 'Sempre',
        code: "color: scheme.primary\ntone: StatusTone.danger",
        why: 'Consome a role. O Scheme resolve por tema/flavor — o componente nem sabe a cor final.',
      ),
    ]);
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.ok, required this.title, required this.code, required this.why});
  final bool ok;
  final String title;
  final String code;
  final String why;
  @override
  Widget build(BuildContext context) {
    final accent = ok ? CpfSeguroColors.success04 : CpfSeguroColors.error04;
    final bg = ok ? CpfSeguroColors.success07 : CpfSeguroColors.error07;
    return Container(
      width: 460,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CpfSeguroColors.neutral10,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
          child: Text('${ok ? '✓' : '✕'}  $title',
              style: CpfSeguroType.labelSm.copyWith(color: accent, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: CpfSeguroColors.neutral01, borderRadius: CpfSeguroRadius.all8),
          child: Text(code, style: CpfSeguroType.caption.copyWith(color: CpfSeguroColors.white, height: 1.6)),
        ),
        const SizedBox(height: 10),
        Text(why, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.5)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 3 · Superfície (top/content/bottom)
// ═══════════════════════════════════════════════════════════════════════════

class _RegionDiagram extends StatelessWidget {
  const _RegionDiagram();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(children: const [
        _RegionBox('TOP', 'StatusBar + NavigationTopBar (+ Stepper)', CpfSeguroColors.primary04, 56),
        SizedBox(height: 6),
        _RegionBox('CONTENT', 'slot rolável', CpfSeguroColors.neutral04, 180),
        SizedBox(height: 6),
        _RegionBox('BOTTOM', 'Nav · Button · Keyboard · ChatInput', CpfSeguroColors.secure03, 72),
      ]),
    );
  }
}

class _RegionBox extends StatelessWidget {
  const _RegionBox(this.label, this.desc, this.color, this.height);
  final String label;
  final String desc;
  final Color color;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // minHeight (não altura fixa): a caixa cresce se a desc quebrar em 2
      // linhas, sem estourar.
      constraints: BoxConstraints(minHeight: height),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: CpfSeguroRadius.all8,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: CpfSeguroType.labelMd.copyWith(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(desc, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04)),
      ]),
    );
  }
}

class _RegionLegend extends StatelessWidget {
  const _RegionLegend();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _legendRow('top', 'O que a tela é / onde estou. Navegação, título, progresso.'),
        _legendRow('content', 'O assunto. Único slot que rola. Consome roles, nunca cor crua.'),
        _legendRow('bottom', 'O que faço agora. Nav global, CTA, teclado ou input de chat.'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CpfSeguroColors.primary09,
            borderRadius: CpfSeguroRadius.all8,
          ),
          child: Text(
            'Web (webadmin / IB): entra a 4ª região "side" + breakpoints e densidade. '
            'Por isso top/content/bottom é primitivo, não raiz.',
            style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.primary03, height: 1.5),
          ),
        ),
      ]),
    );
  }

  Widget _legendRow(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 78,
            child: Text(k, style: CpfSeguroType.label.copyWith(color: CpfSeguroColors.primary04)),
          ),
          Expanded(
            child: Text(v, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03, height: 1.45)),
          ),
        ]),
      );
}

class _Example extends StatelessWidget {
  const _Example({required this.label, required this.caption, required this.height, required this.child});
  final String label;
  final String caption;
  final double height;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral01)),
        const SizedBox(height: 2),
        Text(caption, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        const SizedBox(height: 10),
        Container(
          width: 300,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: CpfSeguroRadius.all24,
            border: Border.all(color: CpfSeguroColors.neutral08),
          ),
          child: child,
        ),
      ]),
    );
  }
}

class _ScreenExample extends StatelessWidget {
  const _ScreenExample();
  @override
  Widget build(BuildContext context) {
    return CpfSeguroSurface(
      top: CpfSeguroTopAppBar.defaultVariant(
        navBar: CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.home(firstName: 'Ana', onOpenProfile: () {}),
          centerAlign: TextAlign.start,
        ),
      ),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        CpfSeguroPageTitle(title: 'Início', subtitle: 'Seu CPF, protegido.'),
        SizedBox(height: 12),
        CpfSeguroSectionHeader(label: 'PARA VOCÊ'),
        SizedBox(height: 12),
        Row(children: [
          CpfSeguroQuickAccessCard(
            icon: CpfSeguroIcons.fingerprintLight,
            label: 'Sou eu!',
            state: CpfSeguroQuickAccessState.active,
          ),
          SizedBox(width: 8),
          CpfSeguroQuickAccessCard(
            icon: CpfSeguroIcons.idCardLight,
            label: 'CPF Seguro',
            state: CpfSeguroQuickAccessState.inactive,
          ),
        ]),
      ]),
      bottom: CpfSeguroBottomApp.nav(
        nav: CpfSeguroNav(activeTab: CpfSeguroNavTab.home, onTabChanged: (_) {}),
      ),
    );
  }
}

class _SheetExample extends StatelessWidget {
  const _SheetExample();
  @override
  Widget build(BuildContext context) {
    return CpfSeguroSurface.sheet(
      top: CpfSeguroTopAppBar.bottomsheet(
        navBar: CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.close(onPressed: () {}),
          title: 'Confirmar',
        ),
      ),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        CpfSeguroPageTitle(
          title: 'Pausar seu CPF?',
          subtitle: 'Enquanto pausado, nenhuma consulta é autorizada.',
        ),
      ]),
      bottom: CpfSeguroBottomApp.button(
        button: CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Pausar agora', onPressed: () {}),
          secondary: CpfSeguroNavigationAction(label: 'Cancelar', onPressed: () {}),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 4 · Linha (AppList left/middle/right)
// ═══════════════════════════════════════════════════════════════════════════

class _RowGrammar extends StatelessWidget {
  const _RowGrammar();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Diagrama dos 3 slots
      Row(children: const [
        Expanded(flex: 2, child: _SlotBox('LEFT', 'spotIcon · avatar\niconAccessory · custom', CpfSeguroColors.primary04)),
        SizedBox(width: 8),
        Expanded(flex: 4, child: _SlotBox('MIDDLE', 'title · titleSubtitle\nlabelTitleSubtitle · custom', CpfSeguroColors.secure03)),
        SizedBox(width: 8),
        Expanded(flex: 2, child: _SlotBox('RIGHT', 'action · icon · toggle\ncheckbox · amount', CpfSeguroColors.success04)),
      ]),
      const SizedBox(height: 24),
      Text('MESMA GRAMÁTICA, LINHAS DIFERENTES',
          style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral03)),
      const SizedBox(height: 16),
      // Exemplos reais
      _rowDemo(
        'left: spotIcon · middle: titleSubtitle · right: action',
        CpfSeguroAppListRow(
          left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
          middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Perfil', subtitle: 'Seus dados'),
          right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
          onTap: () {},
        ),
      ),
      _rowDemo(
        'left: spotIcon · middle: title · right: toggle',
        CpfSeguroAppListRow(
          left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.bellLight),
          middle: const CpfSeguroMiddleAccessory.title(title: 'Notificações'),
          right: CpfSeguroRightAccessory.toggle(value: true, onChanged: (_) {}),
        ),
      ),
      _rowDemo(
        'left: avatar · middle: titleSubtitle · right: icon',
        CpfSeguroAppListRow(
          left: const CpfSeguroLeftAccessory.avatar(initials: 'HC'),
          middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Hunter Carmo', subtitle: 'Meu CPF'),
          right: const CpfSeguroRightAccessory.icon(icon: CpfSeguroIcons.penToSquareLight, semanticLabel: 'Editar'),
        ),
      ),
    ]);
  }

  Widget _rowDemo(String caption, Widget row) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(caption, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
          const SizedBox(height: 6),
          SizedBox(width: 420, child: row),
        ]),
      );
}

class _SlotBox extends StatelessWidget {
  const _SlotBox(this.label, this.opts, this.color);
  final String label;
  final String opts;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: CpfSeguroRadius.all8,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: CpfSeguroType.labelMd.copyWith(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(opts, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.4)),
      ]),
    );
  }
}
