import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Lado do tooltip relativo ao elemento origem.
enum CpfSeguroTooltipSide { top, right, bottom, left }

/// Tamanho do tooltip.
enum CpfSeguroTooltipSize { big, small, xsmall }

/// Estilo (paleta).
enum CpfSeguroTooltipStyle { dark, light }

/// CPF SEGURO — Tooltip.
///
/// Label flutuante ao lado de um elemento. Node Figma 1541:3154.
///
/// - big:    pad 12/8, radius 8, maxWidth 200 (multi-line)
/// - small:  pad 12/4, radius 8 (single-line)
/// - xsmall: pad 8/2,  radius 6 (menor)
///
/// - dark:  bg neutral-01, texto branco (default)
/// - light: bg neutral-10, texto neutral-01
///
/// Tail (setinha 8×8 rotacionado 45°) opt-in.
class CpfSeguroTooltip extends StatelessWidget {
  const CpfSeguroTooltip({
    super.key,
    required this.label,
    this.side = CpfSeguroTooltipSide.top,
    this.size = CpfSeguroTooltipSize.small,
    this.style = CpfSeguroTooltipStyle.dark,
    this.tail = true,
    this.child,
  });

  final String label;
  final CpfSeguroTooltipSide side;
  final CpfSeguroTooltipSize size;
  final CpfSeguroTooltipStyle style;
  final bool tail;

  /// Quando setado, o tooltip vira INTERATIVO: embrulha [child] no engine do
  /// [Tooltip] da plataforma (overlay por long-press/hover, posicionamento e
  /// dismiss resolvidos), vestido com a estética do chip do DS. Sem [child], é
  /// o chip presentacional (sempre-visível). Decisão: manter a estética do DS,
  /// ganhar o comportamento.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = CpfSeguroTheme.schemeOf(context);
    final s = _sizeSpec(size);
    final v = _styleSpec(style, scheme);

    if (child != null) {
      return Tooltip(
        message: label,
        preferBelow: side == CpfSeguroTooltipSide.bottom,
        padding: EdgeInsets.symmetric(horizontal: s.padX, vertical: s.padY),
        decoration: BoxDecoration(
          color: v.bg,
          borderRadius: BorderRadius.circular(s.radius),
          boxShadow: const [
            BoxShadow(
                color: CpfSeguroColors.blackAlpha20,
                offset: Offset(0, 4),
                blurRadius: 10),
          ],
        ),
        textStyle: CpfSeguroType.caption.copyWith(color: v.color),
        child: child,
      );
    }

    return CpfSeguroDevInfo(
      component: 'CpfSeguroTooltip',
      props: {'label': "'$label'", 'side': side.name, 'style': style.name, 'size': size.name},
      tokens: const ['dark: neutral-01 · light: white+border · tail opcional'],
      child: IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: s.maxWidth ?? double.infinity),
            padding: EdgeInsets.symmetric(horizontal: s.padX, vertical: s.padY),
            decoration: BoxDecoration(
              color: v.bg,
              borderRadius: BorderRadius.circular(s.radius),
              boxShadow: const [
                BoxShadow(color: CpfSeguroColors.blackAlpha20, offset: Offset(0, 4), blurRadius: 10),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: s.maxWidth != null,
              overflow: s.maxWidth == null ? TextOverflow.visible : TextOverflow.clip,
              style: CpfSeguroType.caption.copyWith(color: v.color),
            ),
          ),
          if (tail) _Tail(side: side, color: v.bg),
        ],
      ),
    ),
    );
  }
}

class _TooltipSize {
  const _TooltipSize({required this.padX, required this.padY, required this.radius, this.maxWidth});
  final double padX;
  final double padY;
  final double radius;
  final double? maxWidth;
}

_TooltipSize _sizeSpec(CpfSeguroTooltipSize s) => switch (s) {
      CpfSeguroTooltipSize.big => const _TooltipSize(padX: 12, padY: 8, radius: 8, maxWidth: 200),
      CpfSeguroTooltipSize.small => const _TooltipSize(padX: 12, padY: 4, radius: 8),
      CpfSeguroTooltipSize.xsmall => const _TooltipSize(padX: 8, padY: 2, radius: 6),
    };

class _TooltipStyle {
  const _TooltipStyle({required this.bg, required this.color});
  final Color bg;
  final Color color;
}

_TooltipStyle _styleSpec(CpfSeguroTooltipStyle style, CpfSeguroScheme s) => switch (style) {
      // dark = superfície onDark (bg escuro + texto branco). Mantém 1:1 nos 2 modos.
      CpfSeguroTooltipStyle.dark => const _TooltipStyle(bg: CpfSeguroColors.neutral01, color: CpfSeguroColors.white),
      // light: no dark, chip claro vira neutral-02 com texto s.fg (evita claro-no-claro).
      // No light, mantém EXATO (bg neutral-10, texto neutral-01).
      CpfSeguroTooltipStyle.light => _TooltipStyle(
          bg: s.isDark ? CpfSeguroColors.neutral02 : CpfSeguroColors.neutral10,
          color: s.isDark ? s.fg : CpfSeguroColors.neutral01,
        ),
    };

class _Tail extends StatelessWidget {
  const _Tail({required this.side, required this.color});
  final CpfSeguroTooltipSide side;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final rot = Transform.rotate(
      angle: 3.1415926535 / 4,
      child: Container(width: 8, height: 8, color: color),
    );
    return Positioned(
      top: switch (side) { CpfSeguroTooltipSide.bottom => -4, _ => null },
      bottom: switch (side) { CpfSeguroTooltipSide.top => -4, _ => null },
      left: switch (side) { CpfSeguroTooltipSide.right => -4, _ => null },
      right: switch (side) { CpfSeguroTooltipSide.left => -4, _ => null },
      child: rot,
    );
  }
}
