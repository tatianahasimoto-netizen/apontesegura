import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// Capability (ícone + label) listada no [CpfSeguroChatCompletionCard].
class CpfSeguroCompletionCapability {
  const CpfSeguroCompletionCapability({required this.icon, required this.label});
  final String icon;
  final String label;
}

/// CTA (label + callback) dos botões do [CpfSeguroChatCompletionCard].
class CpfSeguroCtaAction {
  const CpfSeguroCtaAction({required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;
}

/// Progresso de nível ("Nível X de Y") do [CpfSeguroChatCompletionCard].
class CpfSeguroLevelProgress {
  const CpfSeguroLevelProgress({required this.current, required this.total});
  final int current;
  final int total;
}

/// CPF SEGURO — ChatCompletionCard.
///
/// Card azul gradient de conclusão. Reutilizado em:
/// - Onboarding standalone (com level chip + capabilities + nextLevel)
/// - Migração SDK T5 (só title + CTA)
///
/// Mostra o que precisar, esconde o resto. TUDO opt-in: sem [primary] nem
/// [secondary] o card não renderiza botão (ex.: nível topo, ou fluxo que ainda
/// não libera as ações). [nextLevel] é um slot custom (acima dos botões) pra
/// quem precisa de uma seção de próximo-nível mais rica que o [nextLevelLabel]
/// estático (ex.: expansível do onboarding).
class CpfSeguroChatCompletionCard extends StatelessWidget {
  const CpfSeguroChatCompletionCard({
    super.key,
    required this.title,
    this.primary,
    this.levelChip,
    this.eyebrow,
    this.capabilities,
    this.nextLevelLabel,
    this.nextLevel,
    this.secondary,
    this.footer,
  });

  final String title;
  final CpfSeguroCtaAction? primary;
  final CpfSeguroLevelProgress? levelChip;
  final String? eyebrow;
  final List<CpfSeguroCompletionCapability>? capabilities;
  final String? nextLevelLabel;
  final Widget? nextLevel;
  final CpfSeguroCtaAction? secondary;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s6, right: CpfSeguroSpacing.s6, top: CpfSeguroSpacing.s6, bottom: CpfSeguroSpacing.s4),
      decoration: BoxDecoration(
        gradient: CpfSeguroGradients.brandLift,
        borderRadius: CpfSeguroRadius.all24,
        boxShadow: CpfSeguroElevation.brandHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (levelChip != null) _LevelChip(chip: levelChip!),
          if (eyebrow != null) ...[
            if (levelChip != null) const SizedBox(height: 16),
            Text(
              eyebrow!.toUpperCase(),
              style: CpfSeguroType.label.copyWith(
                color: CpfSeguroColors.primary07,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
          if (levelChip != null || eyebrow != null) const SizedBox(height: 16),
          Text(
            title,
            style: CpfSeguroType.title.copyWith(color: CpfSeguroColors.white),
          ),
          if (capabilities != null && capabilities!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < capabilities!.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _CapabilityPill(cap: capabilities![i]),
                ],
              ],
            ),
          ],
          // Próximo nível: slot custom [nextLevel] tem prioridade sobre o label
          // estático [nextLevelLabel].
          if (nextLevel != null) ...[
            const SizedBox(height: 16),
            nextLevel!,
          ] else if (nextLevelLabel != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: CpfSeguroSpacing.s3),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: CpfSeguroColors.whiteAlpha32, width: 1)),
              ),
              child: Row(
                children: [
                  const CpfSeguroIconAccessory(icon: CpfSeguroIcons.angleDownLight, padding: 0, size: 14, color: CpfSeguroColors.primary07),
                  const SizedBox(width: 8),
                  Text(
                    nextLevelLabel!,
                    style: CpfSeguroType.label.copyWith(
                      color: CpfSeguroColors.primary07,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Botões só quando há CTA (sem primary/secondary → card sem botão).
          if (primary != null || secondary != null) ...[
            const SizedBox(height: 20),
            if (primary != null) _CtaPrimary(cta: primary!),
            if (secondary != null) ...[
              if (primary != null) const SizedBox(height: 8),
              _CtaSecondary(cta: secondary!),
            ],
          ],
          if (footer != null) Padding(padding: const EdgeInsets.only(top: CpfSeguroSpacing.s1), child: footer!),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.chip});
  final CpfSeguroLevelProgress chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s3, vertical: CpfSeguroSpacing.s1),
      decoration: BoxDecoration(
        color: CpfSeguroColors.whiteAlpha24,
        border: Border.all(color: CpfSeguroColors.whiteAlpha38, width: 1),
        borderRadius: CpfSeguroRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nível ${chip.current} de ${chip.total}',
            style: CpfSeguroType.label.copyWith(color: CpfSeguroColors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          for (var i = 0; i < chip.total; i++) ...[
            if (i > 0) const SizedBox(width: 3),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < chip.current ? CpfSeguroColors.white : CpfSeguroColors.whiteAlpha38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CapabilityPill extends StatelessWidget {
  const _CapabilityPill({required this.cap});
  final CpfSeguroCompletionCapability cap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s3, right: CpfSeguroSpacing.s4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: CpfSeguroColors.whiteAlpha24,
        border: Border.all(color: CpfSeguroColors.whiteAlpha38, width: 1),
        borderRadius: CpfSeguroRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CpfSeguroIconAccessory(icon: cap.icon, padding: 0, size: 14, color: CpfSeguroColors.white),
          const SizedBox(width: 8),
          Text(
            cap.label,
            style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.white, letterSpacing: -0.1),
          ),
        ],
      ),
    );
  }
}

class _CtaPrimary extends StatelessWidget {
  const _CtaPrimary({required this.cta});
  final CpfSeguroCtaAction cta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cta.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CpfSeguroColors.white,
          borderRadius: CpfSeguroRadius.all24,
        ),
        child: Text(
          cta.label,
          style: CpfSeguroType.button.copyWith(color: CpfSeguroColors.primary04),
        ),
      ),
    );
  }
}

class _CtaSecondary extends StatelessWidget {
  const _CtaSecondary({required this.cta});
  final CpfSeguroCtaAction cta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cta.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: CpfSeguroColors.whiteAlpha38, width: 1),
          borderRadius: CpfSeguroRadius.all24,
        ),
        child: Text(
          cta.label,
          style: CpfSeguroType.button.copyWith(color: CpfSeguroColors.white),
        ),
      ),
    );
  }
}
