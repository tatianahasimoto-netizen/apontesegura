import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — SectionHeader.
///
/// Cabeçalho de seção da home: label esquerda (label-md · neutral-03) +
/// slot opcional à direita (típico: [CpfSeguroSeeAllLink]).
///
/// SEM padding embutido — margem lateral é responsabilidade da tela
/// (padding do scroll), não da molécula.
///
/// ```dart
/// CpfSeguroSectionHeader(label: 'ACESSO RÁPIDO', trailing: CpfSeguroSeeAllLink(onPressed: openAll)),
/// ```
class CpfSeguroSectionHeader extends StatelessWidget {
  const CpfSeguroSectionHeader({
    super.key,
    required this.label,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroSectionHeader',
      props: {'label': "'\$label'", if (trailing != null) 'trailing': 'widget'},
      tokens: const ['label: label textTertiary (neutral-03)'],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: CpfSeguroType.label.copyWith(color: s.textTertiary)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
