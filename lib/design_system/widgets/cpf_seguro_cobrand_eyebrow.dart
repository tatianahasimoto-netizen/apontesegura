import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';

/// CPF SEGURO — CobrandEyebrow.
///
/// Selo "{PARCEIRO} + logo CPF SEGURO" no topo de telas SDK. Tipografia
/// mais compacta que [CpfSeguroCobrandMark] pra não competir com top bar. Usado
/// em T2 Welcome (alto) e T3 telas de chat (lembrete sutil).
class CpfSeguroCobrandEyebrow extends StatelessWidget {
  const CpfSeguroCobrandEyebrow({
    super.key,
    required this.partnerName,
    this.partnerColor = CpfSeguroColors.partnerPrimary,
  });

  final String partnerName;
  final Color partnerColor;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            partnerName,
            style: CpfSeguroType.label.copyWith(
              color: partnerColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Text('+', style: CpfSeguroType.label.copyWith(color: s.textPlaceholder)),
          const SizedBox(width: 8),
          CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 44, color: s.primary),
        ],
      ),
    );
  }
}
