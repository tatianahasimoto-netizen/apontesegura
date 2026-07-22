import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Stepper (molécula).
///
/// "{label} · Passo X de Y" + linha de N segmentos coloridos. Segmentos
/// passados = primary-04, futuros = primary-07.
///
/// [label] aceita widget (ex: CobrandMark) além de texto via [labelText].
///
/// Antes chamado de `CpfSeguroChatProgress` — consolidado como molécula
/// genérica que pode viver no `CpfSeguroTopAppBar.stepper(...)` ou standalone.
class CpfSeguroStepper extends StatelessWidget {
  const CpfSeguroStepper({
    super.key,
    required this.current,
    required this.total,
    this.label,
    this.labelText,
  }) : assert(
          label != null || labelText != null,
          'Passe label (widget) OU labelText (string).',
        );

  final int current;
  final int total;
  final Widget? label;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final labelStyle = CpfSeguroType.labelSm.copyWith(
      color: s.textPlaceholder,
      letterSpacing: 0,
    );
    final leftWidget = label ?? Text(labelText!, style: labelStyle);

    return CpfSeguroDevInfo(
      component: 'CpfSeguroStepper',
      props: {'current': '$current', 'total': '$total', if (labelText != null) 'labelText': "'$labelText'"},
      tokens: const ['trilho neutral-09 · progresso primary-04 · labelSm'],
      child: Padding(
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s6, right: CpfSeguroSpacing.s6, top: CpfSeguroSpacing.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: leftWidget),
                Text('Passo $current de $total', style: labelStyle),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < total; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: i < current ? s.primary : CpfSeguroColors.primary07,
                      borderRadius: CpfSeguroRadius.all2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
    );
  }
}
