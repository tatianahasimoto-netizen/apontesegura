import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator, AlwaysStoppedAnimation;
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — ProgressRing (átomo).
///
/// Anel de progresso circular com label central. Distinto do
/// [CpfSeguroProgressBar] (linear). Usado em linhas de serviço (% restante).
///
/// - [progress] 0..1 (fração preenchida).
/// - [label] texto central opcional (ex. dias restantes).
///
/// **Composição** — só tokens.
class CpfSeguroProgressRing extends StatelessWidget {
  const CpfSeguroProgressRing({
    super.key,
    required this.progress,
    this.label,
    this.size = 40,
  });

  /// Fração preenchida (0..1).
  final double progress;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroDevInfo(
      component: 'CpfSeguroProgressRing',
      props: {'progress': progress.toStringAsFixed(2), if (label != null) 'label': "'$label'"},
      tokens: const ['track primary-07 · valor primary-04 · label bodySm primary-04 · strokeCap round'],
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -math.pi / 2,
              child: CircularProgressIndicator(
                value: progress.clamp(0, 1),
                backgroundColor: CpfSeguroColors.primary07,
                valueColor: const AlwaysStoppedAnimation(CpfSeguroColors.primary04),
                strokeCap: StrokeCap.round,
              ),
            ),
            if (label != null)
              Text(
                label!,
                maxLines: 1,
                style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.primary04),
              ),
          ],
        ),
      ),
    );
  }
}
