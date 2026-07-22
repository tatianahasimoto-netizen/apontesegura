import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — EmptyState (molécula).
///
/// Card de estado vazio de uma lista (ex: Atividade Recente sem eventos).
/// Border neutral-09, radius 24, px 40 py 16, conteúdo centralizado:
/// spot circular neutral-10 com ícone 12 + título title-sm + caption body-sm.
///
/// Figma 15:15620 ("Nenhuma ação ainda").
///
/// **Composição** — Icon (átomo) + tokens.
class CpfSeguroEmptyState extends StatelessWidget {
  const CpfSeguroEmptyState({
    super.key,
    required this.title,
    required this.caption,
    this.icon = 'arrow-rotate-left-light',
  });

  final String title;
  final String caption;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroEmptyState',
      props: {'title': "'$title'", 'icon': icon},
      tokens: const ['card surface · border divider · radius 24 · spot 32', 'title: subheading fg · caption: caption textTertiary'],
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s10, vertical: CpfSeguroSpacing.s4),
      decoration: BoxDecoration(
        color: s.surface,
        borderRadius: CpfSeguroRadius.all24,
        border: Border.all(color: s.divider, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Spot 32×32 — círculo neutro (cinza no dark, não puxa a marca).
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: s.isDark ? CpfSeguroColors.neutral02 : CpfSeguroColors.neutral10,
              shape: BoxShape.circle,
            ),
            child: CpfSeguroIconAccessory(icon: icon, padding: 0, size: 12, color: s.textTertiary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: CpfSeguroType.subheading.copyWith(color: s.fg),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: CpfSeguroType.caption.copyWith(color: s.textTertiary),
          ),
        ],
      ),
    ),
    );
  }
}
