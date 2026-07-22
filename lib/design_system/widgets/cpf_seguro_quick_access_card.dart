import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Estados do [CpfSeguroQuickAccessCard] — só DOIS, por princípio: um atalho
/// ou você pode usar, ou não pode. Nada de meio-termo — 3+ tratamentos num
/// menu de atalhos lê como incoerência.
/// - [active]   → disponível: círculo primary-subtle + icon primary
/// - [inactive] → travado: círculo neutro + icon cinza + lock badge
enum CpfSeguroQuickAccessState { active, inactive }

/// CPF SEGURO — QuickAccessCard (molécula).
///
/// Mini card 75×84 da seção "ACESSO RÁPIDO" da Home. Border neutral-10,
/// radius 16, py 8, gap 2 entre círculo do ícone (34×34) e label.
/// Conteúdo alinhado ao topo; cards de 1 linha deixam folga embaixo
/// (Figma 15:16008 não tem justify-center).
///
/// Label é nowrap — quebras de linha só explícitas via `\n`
/// (ex: 'Pausar\nCPF', igual ao `<br/>` do Figma).
///
/// **Composição** — Icon (átomo) + tokens.
class CpfSeguroQuickAccessCard extends StatelessWidget {
  const CpfSeguroQuickAccessCard({
    super.key,
    required this.icon,
    required this.label,
    this.state = CpfSeguroQuickAccessState.active,
    this.onTap,
  });

  final String icon;
  final String label;
  final CpfSeguroQuickAccessState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final bool dark = s.isDark;
    final bool active = state == CpfSeguroQuickAccessState.active;
    // Binário: ativo puxa a marca (azul), inativo é neutro (cinza) + cadeado.
    final Color iconBg = active
        ? s.primarySubtle
        : (dark ? CpfSeguroColors.neutral02 : CpfSeguroColors.neutral10);
    final Color iconColor = active ? s.primary : CpfSeguroColors.neutral06;
    // Label label-sm · 11/16 · 500 · ls 0.5.
    final Color labelColor = active ? s.fg : s.textPlaceholder;
    final bool showLock = !active;

    Widget card = SizedBox(
      width: 75,
      height: 84,
      child: Stack(
        children: [
          Container(
            width: 75,
            height: 84,
            // Figma tem px-16 mas o label é nowrap (estoura o padding sem
            // quebrar) — damos largura total pro label e centramos.
            padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s2),
            decoration: BoxDecoration(
              color: s.surface,
              borderRadius: CpfSeguroRadius.all16,
              border: Border.all(
                  color: dark ? s.border : CpfSeguroColors.neutral10, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon accessory · pill 34×34 (icon 18 + padding 8/8).
                Container(
                  padding: const EdgeInsets.all(CpfSeguroSpacing.s2),
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: CpfSeguroIconAccessory(icon: icon, padding: 0, size: 18, color: iconColor),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  style: CpfSeguroType.labelSm.copyWith(color: labelColor),
                ),
              ],
            ),
          ),
          if (showLock)
            const Positioned(
              top: 7,
              left: 54,
              child: SizedBox(
                width: 12,
                height: 12,
                child: Center(
                  child: CpfSeguroIconAccessory(
                    icon: CpfSeguroIcons.lockLight,
                    padding: 0,
                    size: 8,
                    color: CpfSeguroColors.neutral05,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap != null && active) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: card),
      );
    }
    return CpfSeguroDevInfo(
      component: 'CpfSeguroQuickAccessCard',
      props: {'label': "'$label'", 'icon': icon, 'state': state.name},
      tokens: [
        '75×84 · radius 16 · border neutral-10',
        'circle: ${cpfSeguroColorToken(iconBg)} · icon ${cpfSeguroColorToken(iconColor)}',
        'label: ${cpfSeguroColorToken(labelColor)} · labelSm 11/500',
      ],
      child: card,
    );
  }
}
