import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — OfflinePill (molécula).
///
/// Pill de conectividade mostrada ACIMA do StatusBanner quando o app está
/// sem conexão (gap 8 pro banner). Bg neutral-01, radius 8, px 16 py 4,
/// wifi 16 + label-sm neutral-09.
///
/// Figma 15:15378.
///
/// **Composição** — Icon (átomo) + tokens.
class CpfSeguroOfflinePill extends StatelessWidget {
  const CpfSeguroOfflinePill({
    super.key,
    this.label = 'Sem conexão · mostrando dados salvos',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroDevInfo(
      component: 'CpfSeguroOfflinePill',
      props: {'label': "'$label'"},
      tokens: const ['bg neutral-01 · radius 8 · wifi-light 16 + labelSm neutral-09'],
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s4, vertical: CpfSeguroSpacing.s1),
      decoration: BoxDecoration(
        color: CpfSeguroColors.neutral01,
        borderRadius: CpfSeguroRadius.all8,
      ),
      child: Row(
        children: [
          const CpfSeguroIconAccessory(icon: CpfSeguroIcons.wifiLight, padding: 0, size: 16, color: CpfSeguroColors.neutral09),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral09),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
