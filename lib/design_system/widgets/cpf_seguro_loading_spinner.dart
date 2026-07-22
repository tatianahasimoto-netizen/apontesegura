import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tamanho do LoadingSpinner — mirror do Figma DS (node 1539:3239).
enum CpfSeguroSpinnerSize { sm, md, lg }

/// CPF SEGURO — LoadingSpinner.
///
/// Indicador de carregamento circular: track neutral-07 + arco 75% primary-04.
/// Rotação contínua 900ms linear infinite.
///
/// ```dart
/// CpfSeguroLoadingSpinner(),                                  // md · 40
/// CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.sm),      // 22
/// CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.lg),      // 60
/// ```
class CpfSeguroLoadingSpinner extends StatefulWidget {
  const CpfSeguroLoadingSpinner({
    super.key,
    this.size = CpfSeguroSpinnerSize.md,
    this.semanticLabel = 'Carregando',
  });

  final CpfSeguroSpinnerSize size;
  final String semanticLabel;

  @override
  State<CpfSeguroLoadingSpinner> createState() => _CpsLoadingSpinnerState();
}

class _CpsLoadingSpinnerState extends State<CpfSeguroLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: CpfSeguroMotion.spinner,
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec(widget.size);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroLoadingSpinner',
      props: {'size': widget.size.name},
      tokens: const ['track neutral-07 · arco 75% primary-04'],
      child: Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: RotationTransition(
        turns: _c,
        child: SizedBox(
          width: spec.d,
          height: spec.d,
          child: CustomPaint(painter: _SpinnerPainter(spec: spec)),
        ),
      ),
    ),
    );
  }
}

class _Spec {
  const _Spec({required this.d, required this.stroke});
  final double d;
  final double stroke;
}

_Spec _spec(CpfSeguroSpinnerSize size) => switch (size) {
      CpfSeguroSpinnerSize.sm => const _Spec(d: 22, stroke: 2),
      CpfSeguroSpinnerSize.md => const _Spec(d: 40, stroke: 3),
      CpfSeguroSpinnerSize.lg => const _Spec(d: 60, stroke: 4),
    };

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.spec});
  final _Spec spec;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(spec.d / 2, spec.d / 2);
    final radius = (spec.d - spec.stroke) / 2;

    // Só o arco azul em degrade: cauda transparente afinando até a cabeça
    // opaca. Sem track cinza, sem dot.
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Arco longo (90%) → fade bem gradual, sem cara de "bloco".
    const sweep = 2 * math.pi * 0.9;
    final shader = SweepGradient(
      colors: [
        CpfSeguroColors.primary04.withValues(alpha: 0),
        CpfSeguroColors.primary04,
      ],
      stops: const [0.0, 0.9],
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);
    final comet = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = spec.stroke
      // butt (não round): sem a bolinha sólida na ponta opaca do degrade.
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, comet);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) => false;
}
