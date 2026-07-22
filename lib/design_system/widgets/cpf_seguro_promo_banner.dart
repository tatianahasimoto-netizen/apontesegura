import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Variante de superfície do [CpfSeguroPromoBanner].
///
/// - **light** — fundo branco + borda/texto primary (discreto).
/// - **solid** — fundo primary + texto branco (destaque).
enum CpfSeguroPromoBannerVariant { light, solid }

/// CPF SEGURO — PromoBanner.
///
/// Card promocional / CTA: título + subtítulo opcional + ilustração (à direita)
/// + botão opcional. É o banner de CHAMADA (ativar conta, conhecer feature) —
/// distinto do [CpfSeguroStatusBanner], que é o banner de NÍVEL/progresso do
/// onboarding.
///
/// Consome tokens: cor primary/white por variante, radius 16, tipografia
/// (headlineSm/labelLg), e os componentes [CpfSeguroIllustrationAccessory] e
/// [CpfSeguroButton] — zero estética crua.
///
/// ```dart
/// CpfSeguroPromoBanner(
///   title: 'Ative sua conta',
///   subtitle: 'Complete o cadastro pra usar o Pix.',
///   illustration: CpfSeguroIllustration.keyWord,
///   buttonLabel: 'Continuar',
///   onPressed: () {},
/// )
/// ```
class CpfSeguroPromoBanner extends StatelessWidget {
  const CpfSeguroPromoBanner({
    super.key,
    required this.title,
    required this.illustration,
    this.subtitle,
    this.buttonLabel,
    this.onPressed,
    this.variant = CpfSeguroPromoBannerVariant.light,
  });

  final String title;

  /// Token da ilustração (à direita). O átomo consome, não cria.
  final CpfSeguroIllustration illustration;

  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final CpfSeguroPromoBannerVariant variant;

  @override
  Widget build(BuildContext context) {
    final light = variant == CpfSeguroPromoBannerVariant.light;
    final fg = light ? CpfSeguroColors.primary04 : CpfSeguroColors.white;
    final bg = light ? CpfSeguroColors.white : CpfSeguroColors.primary04;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final hasButton = buttonLabel != null && buttonLabel!.isNotEmpty;

    return CpfSeguroDevInfo(
      component: 'CpfSeguroPromoBanner',
      props: {
        'variant': variant.name,
        if (hasButton) 'button': "'$buttonLabel'",
      },
      tokens: const [
        'bg/fg: primary04 <-> white por variante',
        'radius 16 · headlineSm/labelLg',
        'consome Illustration + Button',
      ],
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: CpfSeguroRadius.all16,
          border: light ? Border.all(color: CpfSeguroColors.primary04) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(CpfSeguroSpacing.s4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: CpfSeguroType.headlineSm.copyWith(color: fg)),
                    if (hasSubtitle) ...[
                      const SizedBox(height: CpfSeguroSpacing.s1),
                      Text(subtitle!,
                          style: CpfSeguroType.labelLg.copyWith(color: fg)),
                    ],
                    if (hasButton) ...[
                      const SizedBox(height: CpfSeguroSpacing.s3),
                      CpfSeguroButton(
                        label: buttonLabel!,
                        size: CpfSeguroButtonSize.md,
                        onPressed: onPressed ?? () {},
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: CpfSeguroSpacing.s2),
              child: CpfSeguroIllustrationAccessory(
                illustration: illustration,
                size: CpfSeguroIllustrationSize.sm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
