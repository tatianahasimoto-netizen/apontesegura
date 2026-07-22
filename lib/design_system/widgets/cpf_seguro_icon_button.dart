import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Peso visual do IconButton (mesmas opções do CpfSeguroButton).
enum CpfSeguroIconButtonType {
  primary,
  secondary,
  secondaryPrimary,
  tertiary,
  tertiaryPrimary,
}

/// Tamanho canônico do IconButton.
enum CpfSeguroIconButtonSize { sm, md, lg }

/// Estado semântico — `error` adota paleta destrutiva.
enum CpfSeguroIconButtonState { normal, error }

/// CPF SEGURO — IconButton.
///
/// Botão só com glyph. Match direto com o Figma (mesmas props que
/// CpfSeguroButton, sem label). Radius 12 (não pill — regra do DS).
///
/// - `size` sm(32) · md(40) · lg(56).
/// - `iconSize` opcional pra override (defaults 14/18/22).
/// - `badge=true` desenha um dot vermelho canto superior direito.
/// - `rotate` gira o glyph em graus (útil pra reusar seta).
/// - `flush` encosta o glyph no edge (compensa padding do botão).
///
/// ```dart
/// CpfSeguroIconButton(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações'),
/// CpfSeguroIconButton(
///   icon: CpfSeguroIcons.angleRightLight,
///   semanticLabel: 'Voltar',
///   type: CpfSeguroIconButtonType.tertiary,
///   rotate: 180,
///   flush: CpfSeguroIconFlush.left,
///   onPressed: goBack,
/// ),
/// ```
class CpfSeguroIconButton extends StatefulWidget {
  const CpfSeguroIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.type = CpfSeguroIconButtonType.secondary,
    this.size = CpfSeguroIconButtonSize.md,
    this.state = CpfSeguroIconButtonState.normal,
    this.iconSize,
    this.disabled = false,
    this.onPressed,
    this.badge = false,
    this.rotate,
    this.flush,
  });

  final String icon;
  final String semanticLabel;
  final CpfSeguroIconButtonType type;
  final CpfSeguroIconButtonSize size;
  final CpfSeguroIconButtonState state;

  /// Override de tamanho do glyph. Se null, usa default por [size].
  final double? iconSize;

  final bool disabled;
  final VoidCallback? onPressed;

  /// Dot vermelho canto superior direito.
  final bool badge;

  /// Rotação em graus (só o glyph, não o box).
  final double? rotate;

  /// Encosta o glyph no edge esquerdo/direito (compensa padding interno).
  /// Útil pra back-button num TopAppBar com edge padding 24.
  final CpfSeguroIconFlush? flush;

  @override
  State<CpfSeguroIconButton> createState() => _CpsIconButtonState();
}

enum CpfSeguroIconFlush { left, right }

class _CpsIconButtonState extends State<CpfSeguroIconButton> {
  bool _hover = false;
  bool _pressed = false;

  // Disabled é ESTADO EXPLÍCITO — onPressed null significa só
  // não-interativo (mocks/handoff), não muda o visual.
  bool get _disabled => widget.disabled;

  @override
  Widget build(BuildContext context) {
    final s = _sizeSpec(widget.size);
    final iconSize = widget.iconSize ?? s.icon;
    final status = _resolveStatus();
    final v = _resolveStyle(widget.type, widget.state, status, CpfSeguroTheme.schemeOf(context));
    final innerPad = (s.box - iconSize) / 2;

    Widget glyph = CpfSeguroIconAccessory(icon: widget.icon, padding: 0, size: iconSize, color: v.color);
    if (widget.rotate != null) {
      glyph = Transform.rotate(angle: widget.rotate! * 3.1415926535 / 180, child: glyph);
    }

    Widget box = AnimatedContainer(
      duration: CpfSeguroMotion.micro,
      width: s.box,
      height: s.box,
      decoration: BoxDecoration(
        color: v.bg,
        borderRadius: CpfSeguroRadius.pillAll,
        border: v.border == null ? null : Border.all(color: v.border!, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(child: glyph),
          if (widget.badge)
            const Positioned(
              top: 6,
              right: 6,
              child: _BadgeDot(),
            ),
        ],
      ),
    );

    if (widget.flush != null) {
      box = Transform.translate(
        offset: widget.flush == CpfSeguroIconFlush.left
            ? Offset(-innerPad, 0)
            : Offset(innerPad, 0),
        child: box,
      );
    }

    return CpfSeguroDevInfo(
      component: 'CpfSeguroIconButton',
      props: {'icon': widget.icon, 'type': widget.type.name, 'size': widget.size.name, 'state': widget.state.name, if (widget.disabled) 'disabled': 'true'},
      tokens: const ['radius pill · sm 32 / md 40 / lg 56 · secondary bg white border neutral-08'],
      child: Semantics(
      button: true,
      enabled: !_disabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() {
          _hover = false;
          _pressed = false;
        }),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _disabled ? null : (_) => setState(() => _pressed = true),
          onTapUp: _disabled ? null : (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: _disabled ? null : widget.onPressed,
          child: box,
        ),
      ),
    ),
    );
  }

  _Status _resolveStatus() {
    if (_disabled) return _Status.disabled;
    if (_pressed) return _Status.pressed;
    if (_hover) return _Status.hover;
    return _Status.normal;
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: CpfSeguroColors.error04,
        shape: BoxShape.circle,
        border: Border.all(color: CpfSeguroColors.white, width: 1.5),
      ),
    );
  }
}

// ============================================================================
// Style resolvers (compartilha lógica com CpfSeguroButton — poderia extrair depois)
// ============================================================================

enum _Status { normal, hover, pressed, disabled }

class _Palette {
  const _Palette({
    required this.base,
    required this.hover,
    required this.pressed,
    required this.onBase,
    required this.bgHoverGhost,
  });
  final Color base;
  final Color hover;
  final Color pressed;
  final Color onBase;
  final Color bgHoverGhost;
}

const _Palette _defaultPalette = _Palette(
  base: CpfSeguroColors.primary04,
  hover: CpfSeguroColors.primary03,
  pressed: CpfSeguroColors.primary02,
  onBase: CpfSeguroColors.brandOnPrimary,
  bgHoverGhost: CpfSeguroColors.primary08,
);

const _Palette _errorPalette = _Palette(
  base: CpfSeguroColors.error03,
  hover: CpfSeguroColors.error02,
  pressed: CpfSeguroColors.error01,
  onBase: CpfSeguroColors.white,
  bgHoverGhost: CpfSeguroColors.error07,
);

class _StyleShape {
  const _StyleShape({required this.bg, required this.color, this.border});
  final Color bg;
  final Color color;
  final Color? border;
}

_StyleShape _resolveStyle(CpfSeguroIconButtonType type, CpfSeguroIconButtonState state, _Status status, CpfSeguroScheme sc) {
  final bool isError = state == CpfSeguroIconButtonState.error;
  final p = isError ? _errorPalette : _defaultPalette;
  // Marca "resting": no dark clareia (sc.primary); error mantém a paleta destrutiva.
  final Color brand = isError ? p.base : sc.primary;
  final Color brandGhost = isError ? p.bgHoverGhost : sc.primarySubtle;

  if (status == _Status.disabled) {
    final isSecondary = type == CpfSeguroIconButtonType.secondary || type == CpfSeguroIconButtonType.secondaryPrimary;
    return _StyleShape(
      bg: type == CpfSeguroIconButtonType.primary
          ? CpfSeguroColors.neutral08
          : isSecondary
              ? sc.surface
              : CpfSeguroColors.transparent,
      color: sc.textPlaceholder,
      border: isSecondary ? sc.border : null,
    );
  }

  switch (type) {
    case CpfSeguroIconButtonType.primary:
      final bg = status == _Status.hover
          ? p.hover
          : status == _Status.pressed
              ? p.pressed
              : brand;
      return _StyleShape(bg: bg, color: isError ? p.onBase : sc.onPrimary);
    case CpfSeguroIconButtonType.secondary:
      final bg = status == _Status.hover
          ? sc.surfaceMuted
          : status == _Status.pressed
              ? sc.border
              : sc.surface;
      // Icon = fg, border = border. Puxa do scheme pra virar no dark.
      return _StyleShape(bg: bg, color: sc.fg, border: sc.border);
    case CpfSeguroIconButtonType.secondaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : sc.surface;
      return _StyleShape(bg: bg, color: brand, border: brand);
    case CpfSeguroIconButtonType.tertiary:
      final bg = status == _Status.hover
          ? sc.surfaceMuted
          : status == _Status.pressed
              ? sc.border
              : CpfSeguroColors.transparent;
      return _StyleShape(bg: bg, color: sc.textTertiary);
    case CpfSeguroIconButtonType.tertiaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : CpfSeguroColors.transparent;
      return _StyleShape(bg: bg, color: brand);
  }
}

class _SizeSpec {
  const _SizeSpec({required this.box, required this.icon});
  final double box;
  final double icon;
}

_SizeSpec _sizeSpec(CpfSeguroIconButtonSize size) => switch (size) {
      CpfSeguroIconButtonSize.sm => const _SizeSpec(box: 32, icon: 14),
      CpfSeguroIconButtonSize.md => const _SizeSpec(box: 40, icon: 18),
      CpfSeguroIconButtonSize.lg => const _SizeSpec(box: 56, icon: 22),
    };
