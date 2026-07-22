import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_logo.dart';

/// CPF SEGURO — CobrandMark.
///
/// Selo passivo de cobranding: "{PARCEIRO} + logo CPF SEGURO". Usar em
/// contextos SDK dentro do app do parceiro pra reforçar branding CPF SEGURO
/// sem competir com o título.
///
/// NÃO usar em "Login protegido por [logo]" — esse é CobrandedBadge.
class CpfSeguroCobrandMark extends StatelessWidget {
  const CpfSeguroCobrandMark({
    super.key,
    this.partnerName = 'BANCO AURORA',
    this.partnerColor = CpfSeguroColors.partnerPrimary,
    this.logoSize = 44,
    this.textSize = 13,
    this.center = true,
  });

  final String partnerName;
  final Color partnerColor;
  final double logoSize;
  final double textSize;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Row(
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          partnerName,
          style: TextStyle(
            color: partnerColor,
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '+',
          style: TextStyle(
            color: s.textPlaceholder,
            fontSize: textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: logoSize, color: s.primary),
      ],
    );
  }
}
