import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// CPF SEGURO — StatusBannerCTA.
///
/// CTA circular 40×40 bg branco + ícone primary-04 — helper pro
/// `rightAccessory` do [CpfSeguroStatusBanner] (chama a ação principal).
///
/// [rotate] em graus (útil pra reusar arrow-left-light com rotate 180 =
/// arrow-right visual, mesmo padrão do React banner).
class CpfSeguroStatusBannerCTA extends StatelessWidget {
  const CpfSeguroStatusBannerCTA({
    super.key,
    this.onPressed,
    this.icon = 'arrow-left-light',
    this.rotate = 180,
  });

  final VoidCallback? onPressed;
  final String icon;
  final double rotate;

  @override
  Widget build(BuildContext context) {
    Widget glyph = CpfSeguroIconAccessory(icon: icon, padding: 0, size: 18, color: CpfSeguroColors.primary04);
    if (rotate != 0) {
      glyph = Transform.rotate(angle: rotate * 3.1415926535 / 180, child: glyph);
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: CpfSeguroColors.white,
            shape: BoxShape.circle,
          ),
          child: glyph,
        ),
      ),
    );
  }
}
