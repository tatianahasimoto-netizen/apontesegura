import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Direção/tipo semântico da Action.
enum CpfSeguroActionDirection {
  /// Chevron right (16px, neutral-04) — navegação ("tap to enter").
  right,

  /// Chevron up (16px, neutral-04) — colapsar.
  up,

  /// Chevron down (16px, neutral-04) — expandir.
  down,

  /// Ellipsis vertical (16px, neutral-04) — menu de opções.
  more,

  /// Círculo check preenchido (22px, success-04) — confirmação.
  check,

  /// Clock outline (22px, neutral-04) — pending/em andamento.
  clock,

  /// Círculo X preenchido (22px, error-04) — erro.
  error,
}

/// CPF SEGURO — Action.
///
/// Primitivo pro slot direito de AppList, banners, cards. 7 direções com
/// icon+size+color pré-configurados. Pode ser puramente decorativo ou
/// clicável (vira botão sem chrome).
///
/// ```dart
/// CpfSeguroAction(direction: CpfSeguroActionDirection.right),               // chevron
/// CpfSeguroAction(direction: CpfSeguroActionDirection.check),               // sucesso
/// CpfSeguroAction(direction: CpfSeguroActionDirection.more, onPressed: openMenu, semanticLabel: 'Mais opções'),
/// ```
class CpfSeguroAction extends StatelessWidget {
  const CpfSeguroAction({
    super.key,
    this.direction = CpfSeguroActionDirection.right,
    this.onPressed,
    this.semanticLabel,
  });

  final CpfSeguroActionDirection direction;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final cfg = _configFor(direction, s);
    final glyph = CpfSeguroIconAccessory(icon: cfg.icon, padding: 0, size: cfg.size, color: cfg.color);

    if (onPressed == null) {
      return CpfSeguroDevInfo(
      component: 'CpfSeguroAction',
      props: {'direction': direction.name},
      tokens: const ['glifo direcional · cor/size por direção'],
      child: ExcludeSemantics(child: glyph),
    );
    }
    return CpfSeguroDevInfo(
      component: 'CpfSeguroAction',
      props: {'direction': direction.name},
      tokens: const ['glifo direcional · cor/size por direção'],
      child: Semantics(
      button: true,
      label: semanticLabel ?? direction.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: glyph,
        ),
      ),
    ),
    );
  }
}

class _ActionConfig {
  const _ActionConfig({required this.icon, required this.size, required this.color});
  final String icon;
  final double size;
  final Color color;
}

_ActionConfig _configFor(CpfSeguroActionDirection d, CpfSeguroScheme s) => switch (d) {
      CpfSeguroActionDirection.right => _ActionConfig(icon: CpfSeguroIcons.angleRightLight, size: 16, color: s.textMuted),
      CpfSeguroActionDirection.up => _ActionConfig(icon: CpfSeguroIcons.angleUpLight, size: 16, color: s.textMuted),
      CpfSeguroActionDirection.down => _ActionConfig(icon: CpfSeguroIcons.angleDownLight, size: 16, color: s.textMuted),
      CpfSeguroActionDirection.more => _ActionConfig(icon: CpfSeguroIcons.ellipsisVerticalLight, size: 16, color: s.textMuted),
      CpfSeguroActionDirection.check => const _ActionConfig(icon: CpfSeguroIcons.circleCheckSolid, size: 22, color: CpfSeguroColors.success04),
      CpfSeguroActionDirection.clock => _ActionConfig(icon: CpfSeguroIcons.clockLight, size: 22, color: s.textMuted),
      CpfSeguroActionDirection.error => const _ActionConfig(icon: CpfSeguroIcons.circleXmarkSolid, size: 22, color: CpfSeguroColors.error04),
    };
