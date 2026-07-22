import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_sheet_overlay.dart';

/// CPF SEGURO — ExitConfirmSheet.
///
/// Bottomsheet reusable pra confirmar saída sem salvar. Grip + xmark ·
/// título · subtítulo · CTA destrutivo · CTA cancelar · home indicator.
/// Figma node 14860:158616.
///
/// Precisa de um [Stack] ancestral (é `Positioned.fill` internamente).
///
/// ```dart
/// CpfSeguroExitConfirmSheet(
///   open: showExit,
///   onClose: () => setState(() => showExit = false),
///   onConfirm: () => navigator.pop(),
/// ),
/// ```
class CpfSeguroExitConfirmSheet extends StatelessWidget {
  const CpfSeguroExitConfirmSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.onConfirm,
    this.title = 'Sair sem salvar?',
    this.subtitle = 'Ao sair sem salvar, suas alterações serão descartadas',
    this.confirmLabel = 'Sair',
    this.cancelLabel = 'Cancelar',
  });

  final bool open;
  final VoidCallback onClose;
  final VoidCallback onConfirm;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroSheetOverlay(
      open: open,
      onScrimTap: onClose,
      child: Container(
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: const BorderRadius.only(
            topLeft: CpfSeguroRadius.r24,
            topRight: CpfSeguroRadius.r24,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CpfSeguroTopAppBar.bottomsheet(
              navBar: CpfSeguroNavigationTopBar(
                left: CpfSeguroNavigationLeftAccessory.close(onPressed: onClose),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: CpfSeguroSpacing.s6, right: CpfSeguroSpacing.s6, top: CpfSeguroSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: CpfSeguroType.title.copyWith(color: s.fg)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: CpfSeguroSpacing.s6, right: CpfSeguroSpacing.s6, top: CpfSeguroSpacing.s6, bottom: CpfSeguroSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CpfSeguroButton(
                    label: confirmLabel,
                    type: CpfSeguroButtonType.primary,
                    state: CpfSeguroButtonState.error,
                    size: CpfSeguroButtonSize.lg,
                    fullWidth: true,
                    onPressed: onConfirm,
                  ),
                  const SizedBox(height: 8),
                  CpfSeguroButton(
                    label: cancelLabel,
                    type: CpfSeguroButtonType.secondary,
                    size: CpfSeguroButtonSize.lg,
                    fullWidth: true,
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            const CpfSeguroBottomHomeIndicator(),
          ],
        ),
      ),
    );
  }
}
