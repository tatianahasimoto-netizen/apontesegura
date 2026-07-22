import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tom do [CpfSeguroInfoChip].
///
/// - **light** — pill claro (bg branco, texto/ícone neutros). Sobre fundo claro.
/// - **onColor** — pill translúcido branco + borda branca, texto branco. Pra
///   assentar SOBRE uma superfície colorida (card de nível, banner primary).
enum CpfSeguroInfoChipTone { light, onColor }

/// CPF SEGURO — InfoChip.
///
/// Pill DECORATIVO/informativo: ícone + label, não-interativo. Distinto de:
/// - [CpfSeguroStatusTag] (estado semântico com tom fixo success/error/…),
/// - [CpfSeguroInputChip] (filtro/seleção interativo, com chevron/onTap).
///
/// É o "badge" genérico de rótulo — usado sobre cards e superfícies coloridas.
///
/// ```dart
/// CpfSeguroInfoChip(label: 'Nível 2', icon: CpfSeguroIcons.starLight),
/// CpfSeguroInfoChip(label: 'Próximo nível', tone: CpfSeguroInfoChipTone.onColor),
/// ```
class CpfSeguroInfoChip extends StatelessWidget {
  const CpfSeguroInfoChip({
    super.key,
    required this.label,
    this.icon,
    this.tone = CpfSeguroInfoChipTone.light,
  });

  final String label;

  /// Nome do ícone (ds.Icons). Null = sem ícone.
  final String? icon;
  final CpfSeguroInfoChipTone tone;

  @override
  Widget build(BuildContext context) {
    final onColor = tone == CpfSeguroInfoChipTone.onColor;
    final bg = onColor
        ? CpfSeguroColors.white.withValues(alpha: 0.15)
        : CpfSeguroColors.white;
    final fg = onColor ? CpfSeguroColors.white : CpfSeguroColors.neutral02;
    final border = onColor
        ? CpfSeguroColors.white.withValues(alpha: 0.38)
        : CpfSeguroColors.neutral09;

    return CpfSeguroDevInfo(
      component: 'CpfSeguroInfoChip',
      props: {'tone': tone.name, if (icon != null) 'icon': icon!},
      tokens: const ['pill · icon 14 + labelSm', 'light: bg white / onColor: white@15% + border'],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CpfSeguroSpacing.s3, vertical: CpfSeguroSpacing.s1_5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: CpfSeguroRadius.all200,
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CpfSeguroIcon(name: icon!, color: fg, size: 14),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(label,
                  style: CpfSeguroType.labelSm.copyWith(color: fg)),
            ),
          ],
        ),
      ),
    );
  }
}
