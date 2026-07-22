import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';

/// Preset de animação — casos de uso nomeados que já vêm com posicionamento
/// + keyframe embutidos (paridade com [Animation] do React DS).
enum CpfSeguroAnimationPreset {
  /// Toast/aviso deslizando do topo (top:48, left/right:16).
  topNotification,

  /// Bottomsheet subindo do rodapé.
  bottomSheet,

  /// Scrim/overlay fade-in cobrindo o parent.
  scrim,

  /// Slide horizontal (push) — filho occupa Positioned.fill.
  slideInRight,

  /// Slide horizontal (pop) — filho occupa Positioned.fill.
  slideOutRight,

  /// Fade-in puro, sem positioning.
  fadeIn,
}

/// CPF SEGURO — Animation.
///
/// Wrapa [child] com uma animação de entrada nomeada. Posicionamento
/// vem embutido nos presets fixed-position (topNotification, bottomSheet,
/// scrim, slideIn/OutRight) — nesse caso precisa de um [Stack] ancestral.
///
/// ```dart
/// CpfSeguroAnimation(preset: CpfSeguroAnimationPreset.topNotification, child: CpfSeguroToast(...)),
/// ```
class CpfSeguroAnimation extends StatefulWidget {
  const CpfSeguroAnimation({
    super.key,
    required this.preset,
    required this.child,
  });

  final CpfSeguroAnimationPreset preset;
  final Widget child;

  @override
  State<CpfSeguroAnimation> createState() => _CpsAnimationState();
}

class _CpsAnimationState extends State<CpfSeguroAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: _durationFor(widget.preset),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animated = _wrap(widget.preset, _c, widget.child);
    return _positioned(widget.preset, animated);
  }
}

Duration _durationFor(CpfSeguroAnimationPreset p) => switch (p) {
      CpfSeguroAnimationPreset.topNotification => CpfSeguroMotion.toast.duration,
      CpfSeguroAnimationPreset.bottomSheet => CpfSeguroMotion.sheet.duration,
      CpfSeguroAnimationPreset.scrim => CpfSeguroMotion.fade.duration,
      CpfSeguroAnimationPreset.slideInRight => CpfSeguroMotion.page.duration,
      CpfSeguroAnimationPreset.slideOutRight => CpfSeguroMotion.page.duration,
      CpfSeguroAnimationPreset.fadeIn => CpfSeguroMotion.fade.duration,
    };

Widget _wrap(CpfSeguroAnimationPreset p, AnimationController c, Widget child) {
  final ease = CurvedAnimation(parent: c, curve: CpfSeguroMotion.enter);
  final easeIn = CurvedAnimation(parent: c, curve: CpfSeguroMotion.exit);

  switch (p) {
    case CpfSeguroAnimationPreset.topNotification:
      final slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(ease);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: ease, child: child),
      );
    case CpfSeguroAnimationPreset.bottomSheet:
      final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(ease);
      return SlideTransition(position: slide, child: child);
    case CpfSeguroAnimationPreset.scrim:
      return FadeTransition(opacity: ease, child: child);
    case CpfSeguroAnimationPreset.slideInRight:
      final slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(easeIn);
      return SlideTransition(position: slide, child: child);
    case CpfSeguroAnimationPreset.slideOutRight:
      final slide = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0)).animate(easeIn);
      return SlideTransition(position: slide, child: child);
    case CpfSeguroAnimationPreset.fadeIn:
      return FadeTransition(opacity: ease, child: child);
  }
}

Widget _positioned(CpfSeguroAnimationPreset p, Widget child) {
  switch (p) {
    case CpfSeguroAnimationPreset.topNotification:
      return Positioned(top: 48, left: 16, right: 16, child: child);
    case CpfSeguroAnimationPreset.bottomSheet:
      return Positioned(bottom: 0, left: 0, right: 0, child: child);
    case CpfSeguroAnimationPreset.scrim:
      return Positioned.fill(child: child);
    case CpfSeguroAnimationPreset.slideInRight:
    case CpfSeguroAnimationPreset.slideOutRight:
      return Positioned.fill(child: child);
    case CpfSeguroAnimationPreset.fadeIn:
      return child;
  }
}
