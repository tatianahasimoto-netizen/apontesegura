import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — CobrandedBadge.
///
/// Selo discreto "Protegido por [logo CPF SEGURO]" pra usar dentro do app do
/// parceiro (SDK) indicando que o login é gerenciado pelo CPF SEGURO.
/// Cobranding sutil — destaca sem competir com a marca do parceiro.
///
/// Diferente de [CpfSeguroCobrandMark] (chat), que é "{PARCEIRO} + logo" ATIVO —
/// este é passivo, uma nota de rodapé.
///
/// ```dart
/// CpfSeguroCobrandedBadge(),                       // 'Protegido por [logo]'
/// CpfSeguroCobrandedBadge(prefix: 'Login por'),
/// ```
class CpfSeguroCobrandedBadge extends StatelessWidget {
  const CpfSeguroCobrandedBadge({
    super.key,
    this.prefix = 'Protegido por',
  });

  final String prefix;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroCobrandedBadge',
      props: {'prefix': "'$prefix'"},
      tokens: const ['cobranding CPF SEGURO × parceiro'],
      child: Semantics(
      label: '$prefix CPF SEGURO',
      container: true,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prefix, style: CpfSeguroType.labelSm.copyWith(color: s.textMuted)),
          const SizedBox(width: 6),
          CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 40, color: s.primary),
        ],
      ),
    ),
    );
  }
}
