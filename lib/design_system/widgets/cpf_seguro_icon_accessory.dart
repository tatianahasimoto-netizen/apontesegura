import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import 'cpf_seguro_icon.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ATOM · IconAccessory (wrapper de ícone com badge)
// ═══════════════════════════════════════════════════════════════════════════

/// Cor do dot (badge) no canto sup-direito do IconAccessory/SpotIcon.
enum CpfSeguroBadge { none, primary, danger }

Color? _badgeColor(CpfSeguroBadge b) => switch (b) {
      CpfSeguroBadge.none => null,
      CpfSeguroBadge.primary => CpfSeguroColors.primary04,
      CpfSeguroBadge.danger => CpfSeguroColors.error04,
    };

/// CPF SEGURO — IconAccessory (átomo STANDALONE).
///
/// Wrapper genérico de ícone + badge dot opcional. Vive por conta própria e é
/// consumido por vários componentes (banners, chips, tags, SpotIcon, AppList).
///
/// REGRA DE TAMANHO: padding 2 de todos os lados — um accessory de size 32
/// tem o ÍCONE com 28 (size − 4) e fecha 32 por conta do padding.
///
/// Figma "Icon acessory" (653:1749) — sizes 12 / 14 / 16 / 20 / 28 / 32 / 40 / 60.
class CpfSeguroIconAccessory extends StatelessWidget {
  const CpfSeguroIconAccessory({
    super.key,
    required this.icon,
    this.size = 20,
    this.color,
    this.badge = CpfSeguroBadge.none,
    this.padding = 2,
  });

  final String icon;
  final double size;
  final Color? color;
  final CpfSeguroBadge badge;

  /// Respiro em volta do glyph (regra do accessory). Slot standalone com badge
  /// usa 2; glyph inline dentro de outro componente usa 0 (fica = ao token cru).
  final double padding;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _badgeColor(badge);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: CpfSeguroIcon(name: icon, size: size - padding * 2, color: color),
          ),
          if (badgeColor != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}
