import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';

/// CPF SEGURO — SeeAllLink.
///
/// Link "Ver todos" — típico no `trailing` do [CpfSeguroSectionHeader], mas
/// componente independente (usável em qualquer cabeçalho/linha).
class CpfSeguroSeeAllLink extends StatelessWidget {
  const CpfSeguroSeeAllLink({super.key, this.onPressed, this.label = 'Ver todos'});
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: Text(label,
              style: CpfSeguroType.label
                  .copyWith(color: CpfSeguroTheme.schemeOf(context).primary)),
        ),
      ),
    );
  }
}
