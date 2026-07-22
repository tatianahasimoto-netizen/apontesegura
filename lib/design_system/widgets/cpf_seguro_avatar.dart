import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_typography.dart';

/// Variante do Avatar.
enum CpfSeguroAvatarVariant {
  /// Círculo branco + borda; iniciais em primary-03.
  outlined,

  /// Círculo cheio da marca (primary-04); iniciais brancas.
  solid,
}

/// CPF SEGURO — Avatar.
///
/// Iniciais em círculo (default 40) — pessoa/contato sem foto. Componente
/// **standalone**: vive por conta própria e é usado em vários contextos. A
/// [CpfSeguroAppList] apenas o CONSOME (via `CpfSeguroLeftAccessory.avatar`),
/// não o define.
///
/// ```dart
/// CpfSeguroAvatar(initials: 'JC'),
/// CpfSeguroAvatar(initials: 'CR', variant: CpfSeguroAvatarVariant.solid, size: 48),
/// ```
class CpfSeguroAvatar extends StatelessWidget {
  const CpfSeguroAvatar({
    super.key,
    required this.initials,
    this.variant = CpfSeguroAvatarVariant.outlined,
    this.size = 40,
    this.borderColor = CpfSeguroColors.neutral09,
  });

  final String initials;
  final CpfSeguroAvatarVariant variant;

  /// Diâmetro do círculo (default 40). O texto escala junto (~40% do size).
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final solid = variant == CpfSeguroAvatarVariant.solid;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: solid ? CpfSeguroColors.primary04 : CpfSeguroColors.white,
        border: solid ? null : Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        initials,
        style: CpfSeguroType.heading.copyWith(
          fontSize: size * 0.4,
          color: solid ? CpfSeguroColors.white : CpfSeguroColors.primary03,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
