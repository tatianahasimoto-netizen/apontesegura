import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

enum _Kind { cashIn, cashOut, cashBack }

/// CPF SEGURO — Amount (átomo).
///
/// Valor monetário COMPACTO de linha ("chip de valor" do extrato/lista). Recebe
/// o valor já formatado ("R$ 560,00"); o construtor nomeado resolve o estilo.
/// Figma "Amount-chips" (2415:36885).
///
/// ```dart
/// CpfSeguroAmount.cashIn(value: 'R$ 560,00')   // chip verde + "+"
/// CpfSeguroAmount.cashOut(value: 'R$ 560,00')  // "−"
/// CpfSeguroAmount.cashBack(value: 'R$ 560,00') // tachado
/// ```
///
/// NÃO é [CpfSeguroAmountDisplay] (bloco grande centralizado entre hairlines).
/// Este é o valor inline consumido por `CpfSeguroRightAccessory.amount`.
///
/// **Composição** — só tokens.
class CpfSeguroAmount extends StatelessWidget {
  /// Entrada — chip verde (success) + prefixo "+".
  const CpfSeguroAmount.cashIn({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashIn;

  /// Saída — prefixo "−", sem chip.
  const CpfSeguroAmount.cashOut({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashOut;

  /// Retorno — valor tachado (strikethrough).
  const CpfSeguroAmount.cashBack({super.key, required this.value, this.obscured = false}) : _kind = _Kind.cashBack;

  /// Valor já formatado ("R$ 560,00").
  final String value;

  /// Saldo oculto — mascara o valor ("••••"), ignora sinal/chip.
  final bool obscured;
  final _Kind _kind;

  @override
  Widget build(BuildContext context) {
    final base = CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral02);

    if (obscured) {
      return CpfSeguroDevInfo(
        component: 'CpfSeguroAmount',
        props: {'obscured': 'true'},
        tokens: const ['labelSm neutral-02 · valor mascarado'],
        child: Text('••••', maxLines: 1, style: base),
      );
    }

    late final Widget child;
    switch (_kind) {
      case _Kind.cashIn:
        child = Container(
          padding: const EdgeInsets.symmetric(
              horizontal: CpfSeguroSpacing.s2, vertical: CpfSeguroSpacing.s1),
          decoration: BoxDecoration(
            color: CpfSeguroColors.success07,
            borderRadius: CpfSeguroRadius.pillAll,
          ),
          child: Text('+ $value',
              maxLines: 1, style: base.copyWith(color: CpfSeguroColors.success04)),
        );
      case _Kind.cashOut:
        child = Text('− $value', maxLines: 1, style: base);
      case _Kind.cashBack:
        child = Text(
          value,
          maxLines: 1,
          style: base.copyWith(
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.lineThrough,
          ),
        );
    }

    return CpfSeguroDevInfo(
      component: 'CpfSeguroAmount',
      props: {'value': "'$value'", 'kind': _kind.name},
      tokens: const [
        'labelSm neutral-02 · cashIn: chip success-07 + success-04 "+" · cashOut: "−" · cashBack: strikethrough',
      ],
      child: child,
    );
  }
}
