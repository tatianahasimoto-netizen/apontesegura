import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// CPF SEGURO — StatusBannerButton.
///
/// CTA pill full-width dentro do banner — "Ver detalhes", "Reenviar documento".
/// Bg branco, h 28, radius pill, label label-md primary-04 + arrow 12.
/// Usar via `button` do [CpfSeguroStatusBanner].
class CpfSeguroStatusBannerButton extends StatelessWidget {
  const CpfSeguroStatusBannerButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s3),
          decoration: const BoxDecoration(
            color: CpfSeguroColors.white,
            borderRadius: CpfSeguroRadius.pillAll,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: CpfSeguroType.label.copyWith(color: CpfSeguroColors.primary04),
              ),
              const SizedBox(width: 8),
              const CpfSeguroIconAccessory(
                icon: CpfSeguroIcons.arrowRightLongLight,
                padding: 0,
                size: 12,
                color: CpfSeguroColors.primary04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
