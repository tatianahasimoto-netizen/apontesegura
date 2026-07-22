import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_elevation.dart';

/// CPF SEGURO — Dev Inspect (infra de handoff, estilo Figma dev mode).
///
/// Com o [CpfSeguroDevMode] habilitado, todo widget do DS embrulhado em
/// [CpfSeguroDevInfo] ganha hover: outline primary no componente + painel
/// escuro seguindo o cursor com TUDO que o dev precisa pra reproduzir —
/// nome do component, props, tokens de cor/typo/radius e icons.
///
/// Quando componentes se aninham (Icon dentro de Button dentro de Banner),
/// o MAIS INTERNO vence — decidido pela profundidade do RenderObject.
class CpfSeguroDevMode extends InheritedWidget {
  const CpfSeguroDevMode({super.key, required this.enabled, required super.child});

  final bool enabled;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CpfSeguroDevMode>()?.enabled ?? false;

  @override
  bool updateShouldNotify(CpfSeguroDevMode old) => old.enabled != enabled;
}

/// Nome do token de cor do DS pra um [Color] (fallback = hex).
String cpfSeguroColorToken(Color? c) {
  if (c == null) return 'herdada';
  const map = <int, String>{
    0xFF002CA8: 'primary-03',
    0xFF003BE0: 'primary-04',
    0xFF2861FF: 'primary-05',
    0xFFB8CAFF: 'primary-07',
    0xFFF2F5FF: 'primary-08',
    0xFF3D3939: 'neutral-01',
    0xFF525252: 'neutral-02',
    0xFF737373: 'neutral-03',
    0xFF8F8F8F: 'neutral-04',
    0xFFA0A0A0: 'neutral-05',
    0xFFB3B3B3: 'neutral-06',
    0xFFC6C6C6: 'neutral-07',
    0xFFDBDBDB: 'neutral-08',
    0xFFECECEC: 'neutral-09',
    0xFFF6F6F6: 'neutral-10',
    0xFFFFFFFF: 'white',
    0xFF000000: 'black',
    0xFFB42318: 'error-03',
    0xFFF04438: 'error-04',
    0xFFF3AAA5: 'error-06',
    0xFFFEF3F2: 'error-07',
    0xFF12B76A: 'success-04',
    0xFFF79009: 'warning-04',
    0xFF272727: 'cardDark',
    0xFFA23737: 'errorBanner',
  };
  return map[c.value] ?? '#${(c.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

class _Candidate {
  _Candidate({required this.id, required this.depth, required this.component, required this.props, required this.tokens});
  final int id;
  final int depth;
  final String component;
  final Map<String, String> props;
  final List<String> tokens;
}

/// Controller global — mantém os candidatos sob o cursor e mostra o painel
/// do mais profundo (mais interno) num OverlayEntry que segue o mouse.
class _Inspector {
  static final Map<int, _Candidate> _candidates = {};
  static final ValueNotifier<int?> topId = ValueNotifier<int?>(null);
  static OverlayEntry? _entry;
  static Offset _cursor = Offset.zero;

  static void enter(BuildContext context, _Candidate c) {
    _candidates[c.id] = c;
    _refresh(context);
  }

  static void move(Offset globalPos) {
    _cursor = globalPos;
    _entry?.markNeedsBuild();
  }

  static void exit(BuildContext context, int id) {
    _candidates.remove(id);
    _refresh(context);
  }

  static void _refresh(BuildContext context) {
    if (_candidates.isEmpty) {
      topId.value = null;
      _entry?.remove();
      _entry = null;
      return;
    }
    final top = _candidates.values.reduce((a, b) => a.depth >= b.depth ? a : b);
    topId.value = top.id;
    if (_entry == null) {
      _entry = OverlayEntry(builder: (_) => _panel());
      Overlay.of(context, rootOverlay: true).insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }
  }

  static Widget _panel() {
    final id = topId.value;
    final c = id == null ? null : _candidates[id];
    if (c == null) return const SizedBox.shrink();
    return Positioned(
      left: _cursor.dx + 16,
      top: _cursor.dy + 16,
      child: IgnorePointer(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(CpfSeguroSpacing.s3),
          decoration: BoxDecoration(
            color: CpfSeguroColors.neutral01,
            borderRadius: CpfSeguroRadius.all8,
            boxShadow: CpfSeguroElevation.overlayLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                c.component,
                style: const TextStyle(
                  color: CpfSeguroColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              for (final e in c.props.entries)
                Text(
                  '${e.key}: ${e.value}',
                  style: const TextStyle(
                    color: CpfSeguroColors.neutral08,
                    fontSize: 11,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              if (c.tokens.isNotEmpty) ...[
                const SizedBox(height: 6),
                for (final t in c.tokens)
                  Text(
                    '· $t',
                    style: const TextStyle(
                      color: CpfSeguroColors.primary07,
                      fontSize: 11,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Embrulha um widget do DS com metadata de inspeção. Sem dev mode, é
/// transparente (retorna o child direto).
class CpfSeguroDevInfo extends StatefulWidget {
  const CpfSeguroDevInfo({
    super.key,
    required this.component,
    this.props = const {},
    this.tokens = const [],
    required this.child,
  });

  final String component;
  final Map<String, String> props;
  final List<String> tokens;
  final Widget child;

  @override
  State<CpfSeguroDevInfo> createState() => _CpfSeguroDevInfoState();
}

class _CpfSeguroDevInfoState extends State<CpfSeguroDevInfo> {
  static int _nextId = 0;
  final int _id = _nextId++;
  bool _inside = false;

  @override
  void deactivate() {
    if (_inside) {
      _Inspector.exit(context, _id);
      _inside = false;
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (!CpfSeguroDevMode.of(context)) return widget.child;

    return MouseRegion(
      onEnter: (e) {
        _inside = true;
        _Inspector.move(e.position);
        _Inspector.enter(
          context,
          _Candidate(
            id: _id,
            depth: (context as Element).depth,
            component: widget.component,
            props: widget.props,
            tokens: widget.tokens,
          ),
        );
      },
      onHover: (e) => _Inspector.move(e.position),
      onExit: (_) {
        _inside = false;
        _Inspector.exit(context, _id);
      },
      child: ValueListenableBuilder<int?>(
        valueListenable: _Inspector.topId,
        builder: (_, top, __) => Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            if (top == _id)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: CpfSeguroColors.primary04, width: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Nome do preset de tipografia do DS pra um [TextStyle] — match por
/// fontSize + fontWeight (fallback = "custom Npx/weight"). Usado pelo
/// [CpfSeguroText] pra o dev saber EXATAMENTE qual estilo reproduzir.
String cpfSeguroTypeToken(TextStyle? s) {
  if (s == null) return 'herdada';
  const presets = <(String, double, int)>[
    ('displayLg', 57, 400), ('displayMd', 45, 400), ('displaySm', 36, 400),
    ('headlineLg', 32, 400), ('headlineMd', 28, 400), ('headlineSm', 24, 400),
    ('headline', 22, 600), ('titleLg', 22, 500),
    ('chatCompletionTitle', 26, 600),
    ('titleMd', 16, 500), ('bodyLg', 16, 400),
    ('labelLg', 14, 600), ('titleSm', 14, 500), ('bodyMd', 14, 400), ('body', 14, 400),
    ('chatButtonLabel', 15, 600),
    ('chatBubble', 13, 700),
    ('labelMd', 12, 500), ('bodySm', 12, 400),
    ('eyebrow', 11, 600), ('labelSm', 11, 500),
  ];
  final size = s.fontSize;
  final w = s.fontWeight == null ? null : ((s.fontWeight!.index + 1) * 100);
  for (final (name, ps, pw) in presets) {
    if (size == ps && w == pw) return name;
  }
  final wStr = w == null ? '' : '/$w';
  return size == null ? 'custom' : 'custom ${size.toInt()}px$wStr';
}
