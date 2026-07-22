import 'package:flutter/material.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_icon_button.dart';

/// CPF SEGURO — NoticeBanner.
///
/// Card CLARO ilustrado de aviso/estado (ex.: conta em processamento, KYC
/// pendente, feature bloqueada). Borda primary-04, radius 16, título + descrição
/// em primary-04, ilustração sangrando no canto inferior-direito e um
/// **botão-ícone** de ação (default `+`) ancorado embaixo à direita.
///
/// Distinto dos outros banners:
/// - [CpfSeguroPromoBanner] = CTA promo (botão de TEXTO, ilustração à direita).
/// - [CpfSeguroStatusBanner] = banner de NÍVEL (gradiente escuro + progresso).
class CpfSeguroNoticeBanner extends StatelessWidget {
  const CpfSeguroNoticeBanner({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    this.onTap,
    this.showButton = true,
    this.buttonIcon = CpfSeguroIcons.plusLight,
    this.buttonSemanticLabel = 'Adicionar',
  });

  final String title;
  final String description;
  final CpfSeguroIllustration illustration;
  final VoidCallback? onTap;
  final bool showButton;
  final String buttonIcon;
  final String buttonSemanticLabel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: CpfSeguroRadius.all16,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: CpfSeguroRadius.all16,
          border: Border.all(color: CpfSeguroColors.primary04),
        ),
        child: ClipRRect(
          borderRadius: CpfSeguroRadius.all16,
          child: Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.antiAlias,
            children: [
              Positioned(
                right: -CpfSeguroSpacing.s6,
                bottom: -CpfSeguroSpacing.s12,
                child: CpfSeguroIllustrationAccessory(
                  illustration: illustration,
                  size: CpfSeguroIllustrationSize.md,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: CpfSeguroSpacing.s6,
                        top: CpfSeguroSpacing.s4,
                        bottom: CpfSeguroSpacing.s3,
                        right: CpfSeguroSpacing.s4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CpfSeguroType.headlineMd.copyWith(
                              color: CpfSeguroColors.primary04,
                              height: 1.2,
                              backgroundColor: CpfSeguroColors.white,
                            ),
                          ),
                          const SizedBox(height: CpfSeguroSpacing.s1),
                          Text(
                            description,
                            style: CpfSeguroType.labelLg.copyWith(
                              color: CpfSeguroColors.primary04,
                              backgroundColor: CpfSeguroColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 160, width: 120),
                ],
              ),
              if (showButton)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: CpfSeguroIconButton(
                    icon: buttonIcon,
                    semanticLabel: buttonSemanticLabel,
                    type: CpfSeguroIconButtonType.secondaryPrimary,
                    size: CpfSeguroIconButtonSize.lg,
                    onPressed: onTap ?? () {},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
