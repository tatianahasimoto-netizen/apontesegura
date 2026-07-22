import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_cobrand_eyebrow.dart' show CpfSeguroCobrandEyebrow;
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_partner_button.dart';

/// CPF SEGURO — SdkScreen.
///
/// Layout base pra screens do SDK que NÃO são chat: Welcome (T2), ErrorFatal,
/// telas de saída. Estrutura fixa (top-down):
///
/// 1. **CobrandEyebrow** — "{PARCEIRO} + logo CPF SEGURO"
/// 2. Espaço flexível
/// 3. **IllustrationAccessory** hero (opcional)
/// 4. **Title** — CpfSeguroType.title
/// 5. **Subtitle** — CpfSeguroType.bodyMd
/// 6. Espaço flexível
/// 7. **PartnerButton** — CTA principal
///
/// Bg = [CpfSeguroGradients.screenBg] por default (white → primary-08).
/// Usar `bg` pra sobrepor.
///
/// ```dart
/// CpfSeguroSdkScreen(
///   partnerName: 'Banco Aurora',
///   illustration: CpfSeguroIllustration.fingerprint,
///   title: 'Seu login agora é com a gente',
///   subtitle: 'Crie uma senha pelo CPF SEGURO em menos de 1 minuto.',
///   primaryLabel: 'Criar nova senha',
///   onPrimary: () => next(),
/// )
/// ```
class CpfSeguroSdkScreen extends StatelessWidget {
  const CpfSeguroSdkScreen({
    super.key,
    required this.partnerName,
    required this.title,
    required this.primaryLabel,
    this.subtitle,
    this.illustration,
    this.illustrationSize = CpfSeguroIllustrationSize.md,
    this.onPrimary,
    this.gradient,
  });

  /// Nome do parceiro pro CobrandEyebrow.
  final String partnerName;

  /// Token da ilustração hero (ex: [CpfSeguroIllustration.fingerprint]). Se
  /// null, o hero é omitido.
  final CpfSeguroIllustration? illustration;

  /// Degrau canônico da ilustração hero.
  final CpfSeguroIllustrationSize illustrationSize;

  /// Título principal — title (22/28 · 600).
  final String title;

  /// Subtítulo opcional — bodyMd neutral-03.
  final String? subtitle;

  /// Label do CTA rodapé (PartnerButton).
  final String primaryLabel;

  /// Callback do CTA.
  final VoidCallback? onPrimary;

  /// Gradient de fundo. Default: [CpfSeguroGradients.screenBg].
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    // Screen bg: em dark, fundo sólido s.bg; em light, o gradient sutil
    // (white → primary-08). Override explícito de [gradient] sempre vence.
    final decoration = gradient != null
        ? BoxDecoration(gradient: gradient)
        : (s.isDark
            ? BoxDecoration(color: s.bg)
            : const BoxDecoration(gradient: CpfSeguroGradients.screenBg));
    return DecoratedBox(
      decoration: decoration,
      // Safe area top=40 (StatusBar glass) + 24 respiro; bottom=34 (BottomBar
      // glass) + 24 respiro. Content vai por baixo dos containers glass.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(CpfSeguroSpacing.s6, CpfSeguroSpacing.s10 + CpfSeguroSpacing.s6, CpfSeguroSpacing.s6, 34 + CpfSeguroSpacing.s6),
        child: Column(
          children: [
            CpfSeguroCobrandEyebrow(partnerName: partnerName),
            const Spacer(),
            if (illustration != null)
              CpfSeguroIllustrationAccessory(illustration: illustration!, size: illustrationSize),
            if (illustration != null) const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CpfSeguroType.title.copyWith(
                color: s.fg,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary),
              ),
            ],
            const Spacer(),
            CpfSeguroPartnerButton(label: primaryLabel, onPressed: onPrimary),
          ],
        ),
      ),
    );
  }
}
