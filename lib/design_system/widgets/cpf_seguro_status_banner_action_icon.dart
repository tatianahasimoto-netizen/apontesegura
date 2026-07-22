import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// CPF SEGURO — StatusBannerActionIcon.
///
/// Ícone 40×40 quadrado com bg semi-transparente branco — helper pro
/// `leftAccessory` do [CpfSeguroStatusBanner] (ex: câmera, id-card, shield).
///
/// [bg]/[borderColor]/[iconColor] parametrizáveis pra variar o tom —
/// ex: amarelo secure na pausa ativa:
/// ```dart
/// CpfSeguroStatusBannerActionIcon(
///   icon: CpfSeguroIcons.lockLight,
///   bg: CpfSeguroColors.secure04,
///   borderColor: CpfSeguroColors.secure07Alpha38,
/// )
/// ```
class CpfSeguroStatusBannerActionIcon extends StatelessWidget {
  const CpfSeguroStatusBannerActionIcon({
    super.key,
    required this.icon,
    this.bg = CpfSeguroColors.whiteAlpha24,
    this.borderColor = CpfSeguroColors.whiteAlpha38,
    this.iconColor = CpfSeguroColors.white,
  });

  final String icon;
  final Color bg;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: CpfSeguroRadius.all8,
      ),
      child: CpfSeguroIconAccessory(icon: icon, padding: 0, size: 18, color: iconColor),
    );
  }
}
