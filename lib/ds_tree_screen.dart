import 'package:flutter/material.dart';
import 'design_system/cpf_seguro_design_system.dart';

/// Aba "Árvore" — MAPA de dependências do DS. Cada nó é um token/átomo/
/// molécula/organismo; cada aresta liga um componente ao que ele CONSOME.
/// Colunas = camadas atômicas (esquerda→direita: tokens → organismos), então
/// as arestas fluem da direita (consumidor) pra esquerda (matéria-prima).
/// Tocar num nó acende a rede dele (deps + dependentes); resto apaga.
class DsTreeScreen extends StatefulWidget {
  const DsTreeScreen({super.key});
  @override
  State<DsTreeScreen> createState() => _DsTreeScreenState();
}

/// Nó do grafo: nome, camada, e o que consome (nomes de outros nós).
class _N {
  const _N(this.name, this.tier, [this.deps = const []]);
  final String name;
  final String tier;
  final List<String> deps;
}

// Arestas DERIVADAS do código (varredura de `CpfSeguro*` por arquivo em
// lib/design_system/) — não hand-authored. Se a relação não existe no DS, não
// existe aqui. Token consumido = família referenciada no arquivo do componente.
const _nodes = <_N>[
  // ── TOKENS — 3 camadas: primitivo (Palette) → semântico (Scheme/Roles) → uso ──
  _N('Palette', 'TOKENS'),
  _N('Scheme', 'TOKENS', ['Palette']),
  _N('Roles', 'TOKENS', ['Scheme']),
  _N('Gradients', 'TOKENS', ['Palette']),
  _N('Typography', 'TOKENS'),
  _N('Radius', 'TOKENS'),
  _N('Spacing', 'TOKENS'),
  _N('Breakpoints', 'TOKENS'),
  _N('Elevation', 'TOKENS', ['Palette']),
  _N('Motion', 'TOKENS'),
  _N('Icon', 'TOKENS'),
  _N('Illustration', 'TOKENS'),
  // ── ATOMS ──
  _N('IconAccessory', 'ATOMS', ['Icon', 'Spacing']),
  _N('IllustrationAccessory', 'ATOMS', ['Illustration', 'Palette', 'Radius']),
  _N('Logo', 'ATOMS', ['Palette']),
  _N('GlassSurface', 'ATOMS', ['Scheme']),
  _N('StatusBar', 'ATOMS', ['Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('BottomHomeIndicator', 'ATOMS', ['Palette', 'Scheme', 'Radius', 'Spacing']),
  _N('Avatar', 'ATOMS', ['Palette', 'Radius', 'Spacing']),
  _N('Checkbox', 'ATOMS', ['Palette', 'Scheme', 'Typography', 'Motion']),
  _N('ToggleSwitch', 'ATOMS', ['Palette', 'Scheme', 'Radius', 'Elevation']),
  _N('LoadingSpinner', 'ATOMS', ['Palette']),
  _N('Skeleton', 'ATOMS', ['Palette', 'Radius']),
  _N('Shimmer', 'ATOMS', ['Skeleton', 'Motion']),
  // Fundação de texto: TextField da plataforma stripado do Material, estilado
  // por tokens. Todo input (Input/SearchInput/ChatInput) recompõe sobre ele.
  _N('Field', 'ATOMS', ['Scheme', 'Typography', 'Motion']),
  // ── MOLECULES ──
  _N('SpotIcon', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Spacing']),
  _N('Action', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme']),
  _N('StatusTag', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Typography', 'Spacing']),
  _N('Amount', 'ATOMS', ['Palette', 'Scheme', 'Typography', 'Radius', 'Spacing']),
  _N('PageTitle', 'MOLECULES', ['Scheme', 'Typography', 'Spacing']),
  _N('SectionHeader', 'MOLECULES', ['Scheme', 'Typography']),
  _N('Button', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Elevation', 'Motion']),
  _N('IconButton', 'MOLECULES', ['IconAccessory', 'Button', 'Palette', 'Scheme', 'Radius', 'Motion']),
  _N('Input', 'MOLECULES', ['Field', 'Palette', 'Scheme', 'Radius', 'Elevation', 'Typography', 'Motion', 'Spacing']),
  _N('SearchInput', 'MOLECULES', ['Field', 'IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('InputChip', 'MOLECULES', ['IconAccessory', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('InfoChip', 'MOLECULES', ['Icon', 'Palette', 'Radius', 'Typography', 'Spacing']),
  _N('RadioList', 'MOLECULES', ['Palette', 'Scheme', 'Typography', 'Motion']),
  _N('OtpInput', 'MOLECULES', ['Palette', 'Scheme', 'Radius', 'Typography', 'Motion']),
  _N('MenuButton', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography', 'Motion', 'Spacing']),
  _N('Keyboard', 'MOLECULES', ['Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('ChatInput', 'MOLECULES', ['Field', 'IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('Nav', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Elevation', 'Typography', 'Spacing']),
  _N('NavigationButton', 'MOLECULES', ['Button']),
  _N('NavigationTopBar', 'MOLECULES', ['IconButton', 'IconAccessory', 'InputChip', 'Button', 'Scheme', 'Typography', 'Spacing']),
  _N('Stepper', 'MOLECULES', ['Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('FeatureCard', 'MOLECULES', ['IconAccessory', 'StatusTag', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('QuickAccessCard', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('EmptyState', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('CriteriaList', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Typography', 'Spacing']),
  _N('Dropdown', 'MOLECULES', ['Input', 'Icon', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('Calendar', 'MOLECULES', ['Icon', 'Motion', 'Palette', 'Scheme', 'Typography', 'Spacing']),
  _N('DateField', 'MOLECULES', ['Input', 'Calendar', 'Icon', 'Scheme', 'Radius', 'Typography']),
  _N('AppListRow', 'MOLECULES',
      ['SpotIcon', 'Avatar', 'IconAccessory', 'StatusTag', 'Action', 'IconButton', 'Checkbox', 'ToggleSwitch', 'Amount', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('AppList', 'MOLECULES', ['AppListRow', 'Scheme', 'Radius', 'Spacing']),
  _N('DayGroup', 'MOLECULES', ['AppListRow', 'Scheme', 'Typography', 'Spacing']),
  _N('DetailRow', 'MOLECULES', ['IconAccessory', 'Scheme', 'Typography', 'Spacing']),
  _N('InfoCard', 'MOLECULES', ['IconAccessory', 'StatusTag', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('OfflinePill', 'MOLECULES', ['IconAccessory', 'Palette', 'Radius', 'Typography', 'Spacing']),
  _N('AmountDisplay', 'MOLECULES', ['Scheme', 'Typography', 'Spacing']),
  _N('FaceIdCard', 'MOLECULES', ['IconAccessory', 'Palette', 'Scheme', 'Radius', 'Typography']),
  _N('Receipt', 'MOLECULES', ['IconAccessory', 'Logo', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('Toast', 'MOLECULES', ['Palette', 'Radius', 'Elevation', 'Typography', 'Spacing']),
  _N('Tooltip', 'MOLECULES', ['Palette', 'Scheme', 'Elevation', 'Typography']),
  // ── ORGANISMS ──
  _N('TopAppBar', 'ORGANISMS', ['NavigationTopBar', 'StatusBar', 'Stepper', 'GlassSurface', 'Scheme', 'Radius']),
  _N('BottomApp', 'ORGANISMS', ['Nav', 'NavigationButton', 'Keyboard', 'ChatInput', 'BottomHomeIndicator', 'GlassSurface', 'Palette', 'Spacing']),
  _N('Chat', 'ORGANISMS', ['TopAppBar', 'Stepper', 'Logo', 'IconAccessory', 'StatusTag', 'Palette', 'Scheme', 'Typography', 'Spacing']),
  _N('Sheets', 'ORGANISMS',
      ['AppList', 'Button', 'Checkbox', 'FaceIdCard', 'GlassSurface', 'IconAccessory', 'Input', 'LoadingSpinner', 'NavigationTopBar', 'TopAppBar', 'Keyboard', 'BottomHomeIndicator', 'Palette', 'Scheme', 'Radius', 'Elevation', 'Typography', 'Spacing']),
  // Gramática — Surface enquadra top/content/bottom (screen/modal/sheet).
  _N('SeeAllLink', 'ATOMS', ['Scheme', 'Typography']),
  _N('ChatBubble', 'ORGANISMS', ['Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('ChatCriteriaBubble', 'ORGANISMS', ['IconAccessory', 'StatusTag', 'Palette', 'Scheme', 'Radius', 'Typography', 'Spacing']),
  _N('ChatTypingIndicator', 'ORGANISMS', ['Palette', 'Scheme', 'Spacing']),
  _N('BiometriaOverlay', 'ORGANISMS', ['FaceIdCard', 'Scheme', 'Spacing']),
  _N('ExitConfirmSheet', 'ORGANISMS', ['Button', 'Scheme', 'Radius', 'Spacing']),
  _N('PasswordBottomSheet', 'ORGANISMS', ['Input', 'Button', 'Keyboard', 'Scheme', 'Spacing']),
  _N('Surface', 'ORGANISMS', ['TopAppBar', 'BottomApp', 'Scheme', 'Gradients', 'Spacing']),
];

const _tiers = ['TOKENS', 'ATOMS', 'MOLECULES', 'ORGANISMS'];
const _colX = {'TOKENS': 150.0, 'ATOMS': 480.0, 'MOLECULES': 890.0, 'ORGANISMS': 1310.0};

// Cor por camada (ink, bg-claro).
const _tierInk = {
  'TOKENS': CpfSeguroColors.neutral02,
  'ATOMS': CpfSeguroColors.primary04,
  'MOLECULES': CpfSeguroColors.success04,
  'ORGANISMS': CpfSeguroColors.warning04,
};
const _tierBg = {
  'TOKENS': CpfSeguroColors.neutral10,
  'ATOMS': CpfSeguroColors.primary08,
  'MOLECULES': CpfSeguroColors.success07,
  'ORGANISMS': CpfSeguroColors.warning07,
};

const double _spacing = 33;
const double _canvasH = 1420;
const double _canvasW = 1480;
const double _nodeW = 158;
const double _nodeH = 24;

class _DsTreeScreenState extends State<DsTreeScreen> {
  String? _sel;

  Map<String, Offset> _positions() {
    final pos = <String, Offset>{};
    for (final t in _tiers) {
      final list = _nodes.where((n) => n.tier == t).toList();
      final startY = (_canvasH - list.length * _spacing) / 2 + _spacing / 2;
      for (var i = 0; i < list.length; i++) {
        pos[list[i].name] = Offset(_colX[t]!, startY + i * _spacing);
      }
    }
    return pos;
  }

  Set<String> _network(String sel) {
    final byName = {for (final n in _nodes) n.name: n};
    final set = <String>{sel};
    void down(String name) {
      for (final d in byName[name]?.deps ?? const <String>[]) {
        if (set.add(d)) down(d);
      }
    }
    void up(String name) {
      for (final n in _nodes) {
        if (n.deps.contains(name) && set.add(n.name)) up(n.name);
      }
    }
    down(sel);
    up(sel);
    return set;
  }

  @override
  Widget build(BuildContext context) {
    final pos = _positions();
    final hl = _sel == null ? null : _network(_sel!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 12),
          child: Row(
            children: [
              Text('Design System · Mapa de dependências',
                  style: CpfSeguroType.heading.copyWith(
                      color: CpfSeguroColors.neutral01, fontWeight: FontWeight.w700)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _sel == null
                      ? 'Cada aresta = "consome". Toque num nó pra acender a rede dele (mão pra arrastar, scroll pra zoom).'
                      : 'Rede de "$_sel" — ${hl!.length} nós conectados. Toque de novo pra limpar.',
                  style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04),
                ),
              ),
              for (final t in _tiers) ...[
                _LegendDot(color: _tierInk[t]!, label: t),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
        Expanded(
          child: ClipRect(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.3,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(500),
              child: SizedBox(
                width: _canvasW,
                height: _canvasH,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _EdgePainter(pos: pos, hl: hl)),
                    ),
                    // labels de coluna
                    for (final t in _tiers)
                      Positioned(
                        left: _colX[t]! - _nodeW / 2,
                        top: 12,
                        child: Text(t,
                            style: CpfSeguroType.overline
                                .copyWith(color: _tierInk[t], fontWeight: FontWeight.w700)),
                      ),
                    // nós
                    for (final n in _nodes)
                      Positioned(
                        left: pos[n.name]!.dx - _nodeW / 2,
                        top: pos[n.name]!.dy - _nodeH / 2,
                        child: _NodeChip(
                          node: n,
                          selected: _sel == n.name,
                          dimmed: hl != null && !hl.contains(n.name),
                          onTap: () => setState(
                              () => _sel = _sel == n.name ? null : n.name),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EdgePainter extends CustomPainter {
  _EdgePainter({required this.pos, required this.hl});
  final Map<String, Offset> pos;
  final Set<String>? hl;

  @override
  void paint(Canvas canvas, Size size) {
    for (final n in _nodes) {
      final to = pos[n.name];
      if (to == null) continue;
      for (final d in n.deps) {
        final from = pos[d];
        if (from == null) continue;
        // Só liga da direita (consumidor n) pra esquerda (dep d).
        final active = hl != null && hl!.contains(n.name) && hl!.contains(d);
        final faded = hl != null && !active;
        final color = active
            ? (_tierInk[n.tier] ?? CpfSeguroColors.neutral04)
            : CpfSeguroColors.neutral05;
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = active ? 1.8 : 1
          ..color = color.withValues(alpha: active ? 0.85 : (faded ? 0.04 : 0.08));

        final start = Offset(from.dx + _nodeW / 2, from.dy); // right edge do dep
        final end = Offset(to.dx - _nodeW / 2, to.dy); // left edge do consumidor
        final dx = (end.dx - start.dx) * 0.5;
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(start.dx + dx, start.dy, end.dx - dx, end.dy, end.dx, end.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter old) => old.hl != hl;
}

class _NodeChip extends StatelessWidget {
  const _NodeChip({
    required this.node,
    required this.selected,
    required this.dimmed,
    required this.onTap,
  });
  final _N node;
  final bool selected;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = _tierInk[node.tier]!;
    final bg = _tierBg[node.tier]!;
    return Opacity(
      opacity: dimmed ? 0.28 : 1,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: _nodeW,
            height: _nodeH,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? ink : bg,
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: ink, width: selected ? 1.5 : 1),
            ),
            child: Text(
              node.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CpfSeguroType.labelSm.copyWith(
                color: selected ? CpfSeguroColors.white : ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04, letterSpacing: 0.5)),
      ],
    );
  }
}
