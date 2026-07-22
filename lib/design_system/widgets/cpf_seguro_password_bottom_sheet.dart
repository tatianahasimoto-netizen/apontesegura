import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_keyboard.dart';
import 'cpf_seguro_sheet_overlay.dart';

/// CPF SEGURO — PasswordBottomSheet.
///
/// Confirmação de senha via bottomsheet: título · 6 pin dots · "Esqueci
/// minha senha" · CTA Continuar · numpad iOS + home indicator.
/// Figma node 14860:158730.
///
/// Digitação vem do numpad interno; [value] é controlado externamente. O
/// pai valida a senha após [onSubmit] disparar.
class CpfSeguroPasswordBottomSheet extends StatefulWidget {
  const CpfSeguroPasswordBottomSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.onSubmit,
    this.onForgot,
    this.length = 6,
  });

  final bool open;
  final VoidCallback onClose;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onForgot;
  final int length;

  @override
  State<CpfSeguroPasswordBottomSheet> createState() => _CpsPasswordBottomSheetState();
}

class _CpsPasswordBottomSheetState extends State<CpfSeguroPasswordBottomSheet> {
  String _digits = '';

  @override
  void didUpdateWidget(covariant CpfSeguroPasswordBottomSheet old) {
    super.didUpdateWidget(old);
    if (widget.open && !old.open) _digits = '';
  }

  bool get _canSubmit => _digits.length == widget.length;

  void _append(String d) {
    if (_digits.length >= widget.length) return;
    setState(() => _digits += d);
  }

  void _backspace() {
    if (_digits.isEmpty) return;
    setState(() => _digits = _digits.substring(0, _digits.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroSheetOverlay(
      open: widget.open,
      onScrimTap: widget.onClose,
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
                left: CpfSeguroNavigationLeftAccessory.close(onPressed: widget.onClose),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: CpfSeguroSpacing.s6, right: CpfSeguroSpacing.s6, top: CpfSeguroSpacing.s4, bottom: CpfSeguroSpacing.s10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Digite sua senha',
                    textAlign: TextAlign.center,
                    style: CpfSeguroType.title.copyWith(color: s.fg),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < widget.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _PinDot(filled: i < _digits.length),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            _ForgotButton(onPressed: widget.onForgot),
            _ContinueBar(canSubmit: _canSubmit, onSubmit: () => widget.onSubmit(_digits)),
            CpfSeguroKeyboard(onKey: _append, onBackspace: _backspace),
            const CpfSeguroKeyboardIndicator(),
          ],
        ),
      ),
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CpfSeguroColors.neutral07, width: 1.5),
      ),
      child: filled
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: s.textSecondary, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class _ForgotButton extends StatelessWidget {
  const _ForgotButton({required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Text(
              'Esqueci minha senha',
              style: CpfSeguroType.subheading.copyWith(color: s.textTertiary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.canSubmit, required this.onSubmit});
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroGlassSurface(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
        child: CpfSeguroButton(
          label: 'Continuar',
          fullWidth: true,
          size: CpfSeguroButtonSize.lg,
          disabled: !canSubmit,
          onPressed: canSubmit ? onSubmit : null,
        ),
      ),
    );
  }
}
