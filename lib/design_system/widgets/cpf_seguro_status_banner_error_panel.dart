import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_status_banner_action_icon.dart';

/// CPF SEGURO — StatusBannerErrorPanel.
///
/// Painel de erro DENTRO do banner azul (feedback de documento inválido).
/// Bg [CpfSeguroColors.errorBanner], radius 8, gap 16, SEM padding — o
/// ActionIcon fica flush à esquerda, altura = altura do ícone (40).
/// Usar via `body` do [CpfSeguroStatusBanner].
class CpfSeguroStatusBannerErrorPanel extends StatelessWidget {
  const CpfSeguroStatusBannerErrorPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // Stance: o azul segura você mesmo no erro — o painel é um alerta CONTIDO
    // dentro do banner, não a tela virando vermelha. O errorBanner (#A23737)
    // foi dessaturado pra não gritar sobre o azul no LIGHT; no dark ele vira
    // marrom-lama e o "vermelho = erro" some. No dark, um vermelho mais limpo
    // (error-03) afirma o erro sem gritar.
    final bool dark = CpfSeguroTheme.schemeOf(context).isDark;
    return Container(
      decoration: BoxDecoration(
        color: dark ? CpfSeguroColors.error03 : CpfSeguroColors.errorBanner,
        borderRadius: CpfSeguroRadius.all8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CpfSeguroStatusBannerActionIcon(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: CpfSeguroSpacing.s2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.white),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.error06),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
