import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — PartnerButton.
///
/// CTA primário com a cor do PARCEIRO (não do CPF SEGURO). Usado nas telas
/// do SDK dentro do app do parceiro — mantém a identidade visual dele.
///
/// Sempre size lg (56h), pill radius, disabled = neutral-08 + neutral-04.
///
/// ```dart
/// CpfSeguroPartnerButton(label: 'Continuar no Banco Aurora', onPressed: submit),
/// ```
class CpfSeguroPartnerButton extends StatelessWidget {
  const CpfSeguroPartnerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    // Disabled só quando explícito — onPressed null não muda o visual.
    final effectivelyDisabled = disabled;
    final bg = effectivelyDisabled ? CpfSeguroColors.neutral08 : CpfSeguroColors.partnerPrimary;
    final color = effectivelyDisabled ? CpfSeguroColors.neutral04 : CpfSeguroColors.partnerOnPrimary;
    return CpfSeguroDevInfo(
      component: 'CpfSeguroPartnerButton',
      props: {'label': "'$label'", 'disabled': '$effectivelyDisabled'},
      tokens: const ['h56 · radius pill · bg partner-primary'],
      child: Semantics(
      button: true,
      enabled: !effectivelyDisabled,
      label: label,
      child: MouseRegion(
        cursor: effectivelyDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: effectivelyDisabled ? null : onPressed,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: CpfSeguroRadius.pillAll,
            ),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              style: CpfSeguroType.subheading.copyWith(color: color),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
