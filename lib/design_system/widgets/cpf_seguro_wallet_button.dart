import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Variantes do [CpfSeguroWalletButton].
enum CpfSeguroWalletButtonVariant {
  /// "Pagar com CPF Seguro" — abre o PaymentSheet.
  pay,

  /// "Carteira CPF Seguro" — abre a gestão da carteira.
  manage,
}

/// CPF SEGURO — WalletButton (molécula).
///
/// O ÚNICO ponto de contato que o parceiro embeda no app dele (padrão
/// "Buy with Apple Pay"): um botão brandado que abre o fluxo de pagamento
/// ([CpfSeguroWalletButtonVariant.pay] → PaymentSheet) ou a gestão da
/// carteira ([CpfSeguroWalletButtonVariant.manage]).
///
/// Pill h56 · bg primary-04 · logo branco + label. Não expõe customização
/// de cor — a marca é o contrato visual do botão.
///
/// **Composição** — Logo (átomo) + tokens.
class CpfSeguroWalletButton extends StatelessWidget {
  const CpfSeguroWalletButton({
    super.key,
    this.variant = CpfSeguroWalletButtonVariant.pay,
    this.onPressed,
    this.disabled = false,
  });

  final CpfSeguroWalletButtonVariant variant;
  final VoidCallback? onPressed;

  /// Disabled é estado explícito — onPressed null não muda o visual.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final label = switch (variant) {
      CpfSeguroWalletButtonVariant.pay => 'Pagar com CPF Seguro',
      CpfSeguroWalletButtonVariant.manage => 'Carteira CPF Seguro',
    };
    final bg = disabled ? CpfSeguroColors.neutral08 : CpfSeguroColors.primary04;
    final fg = disabled ? CpfSeguroColors.neutral05 : CpfSeguroColors.white;

    Widget button = Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: CpfSeguroRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CpfSeguroLogo(size: 22, color: fg),
          const SizedBox(width: 8),
          Text(
            label,
            style: CpfSeguroType.button.copyWith(color: fg),
          ),
        ],
      ),
    );

    if (!disabled && onPressed != null) {
      button = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onPressed, child: button),
      );
    }
    return CpfSeguroDevInfo(
      component: 'CpfSeguroWalletButton',
      props: {'variant': variant.name, 'disabled': '$disabled'},
      tokens: ['h56 · radius pill · bg ${disabled ? "neutral-08" : "primary-04"} · logo + label'],
      child: Semantics(button: true, label: label, child: button),
    );
  }
}
