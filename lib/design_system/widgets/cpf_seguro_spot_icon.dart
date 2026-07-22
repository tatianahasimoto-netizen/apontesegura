import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart';
import 'cpf_seguro_dev_inspect.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ATOM · SpotIcon (círculo colorido com ícone)
// ═══════════════════════════════════════════════════════════════════════════

enum CpfSeguroSpotType { fill, outline }

enum CpfSeguroSpotState {
  normal,
  disabled,
  primary,
  error,
  warning,
  success,
  loading,
}

class _SpotSpec {
  const _SpotSpec({required this.bg, this.border, required this.iconColor});
  final Color bg;
  final Color? border;
  final Color iconColor;
}

_SpotSpec _resolveSpot(CpfSeguroSpotType type, CpfSeguroSpotState state, CpfSeguroScheme s) {
  if (type == CpfSeguroSpotType.fill) {
    return switch (state) {
      // Listagem cinza: icon neutral-03 (não 01) — padrão do extrato geral.
      CpfSeguroSpotState.normal => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
      CpfSeguroSpotState.disabled => _SpotSpec(
          bg: s.isDark ? CpfSeguroColors.neutral02 : CpfSeguroColors.neutral10,
          iconColor: CpfSeguroColors.neutral06),
      CpfSeguroSpotState.primary => const _SpotSpec(bg: CpfSeguroColors.primary04, iconColor: CpfSeguroColors.white),
      CpfSeguroSpotState.error => const _SpotSpec(bg: CpfSeguroColors.error04, iconColor: CpfSeguroColors.error07),
      CpfSeguroSpotState.warning => const _SpotSpec(bg: CpfSeguroColors.warning04, iconColor: CpfSeguroColors.white),
      CpfSeguroSpotState.success => const _SpotSpec(bg: CpfSeguroColors.success04, iconColor: CpfSeguroColors.white),
      CpfSeguroSpotState.loading => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
    };
  }
  return switch (state) {
    CpfSeguroSpotState.normal => _SpotSpec(bg: s.surfaceMuted, iconColor: s.textTertiary),
    CpfSeguroSpotState.disabled => _SpotSpec(
        bg: s.isDark ? CpfSeguroColors.neutral02 : CpfSeguroColors.neutral10,
        iconColor: CpfSeguroColors.neutral06),
    CpfSeguroSpotState.primary => const _SpotSpec(bg: CpfSeguroColors.primary08, iconColor: CpfSeguroColors.primary04),
    // Dark: fundo pálido (error-07) vira tint escuro; ícone clareia.
    CpfSeguroSpotState.error => s.isDark
        ? _SpotSpec(bg: s.errorSubtle, iconColor: s.error)
        : const _SpotSpec(bg: CpfSeguroColors.error07, iconColor: CpfSeguroColors.error03),
    CpfSeguroSpotState.warning => s.isDark
        ? _SpotSpec(bg: CpfSeguroColors.warning05.withValues(alpha: 0.18), iconColor: CpfSeguroColors.warning05)
        : const _SpotSpec(bg: CpfSeguroColors.warning07, border: CpfSeguroColors.warning03, iconColor: CpfSeguroColors.warning03),
    CpfSeguroSpotState.success => s.isDark
        ? _SpotSpec(bg: CpfSeguroColors.success05.withValues(alpha: 0.18), iconColor: CpfSeguroColors.success05)
        : const _SpotSpec(bg: CpfSeguroColors.success07, border: CpfSeguroColors.success03, iconColor: CpfSeguroColors.success03),
    CpfSeguroSpotState.loading => s.isDark
        ? _SpotSpec(bg: s.surfaceMuted, iconColor: s.primary)
        : const _SpotSpec(bg: CpfSeguroColors.primary07, border: CpfSeguroColors.neutral07, iconColor: CpfSeguroColors.primary04),
  };
}

/// CPF SEGURO — SpotIcon (átomo STANDALONE).
///
/// Círculo colorido com ícone. 10 variantes (fill/outline × 8 states).
/// Default 34px (mobile). Icon escala pra ~58% do container.
///
/// Vive por conta própria (banner, KPI card, etc). Dentro do AppList,
/// use [CpfSeguroLeftAccessory.spotIcon].
class CpfSeguroSpotIcon extends StatelessWidget {
  const CpfSeguroSpotIcon({
    super.key,
    required this.icon,
    this.type = CpfSeguroSpotType.fill,
    this.state = CpfSeguroSpotState.normal,
    this.badge = CpfSeguroBadge.none,
    this.size = 34,
  });

  final String icon;
  final CpfSeguroSpotType type;
  final CpfSeguroSpotState state;
  final CpfSeguroBadge badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final spec = _resolveSpot(type, state, s);
    final iconSize = (size * 0.58).roundToDouble();
    return CpfSeguroDevInfo(
      component: 'CpfSeguroSpotIcon',
      props: {
        'icon': icon,
        'type': type.name,
        'state': state.name,
        'size': '${size.toInt()}',
        if (badge != CpfSeguroBadge.none) 'badge': badge.name,
      },
      tokens: [
        'bg: ${cpfSeguroColorToken(spec.bg)}',
        'icon: ${cpfSeguroColorToken(spec.iconColor)} · ${iconSize.toInt()}px',
        if (spec.border != null) 'border: ${cpfSeguroColorToken(spec.border)}',
      ],
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: spec.bg,
          shape: BoxShape.circle,
          border: spec.border == null ? null : Border.all(color: spec.border!, width: 1),
        ),
        child: CpfSeguroIconAccessory(icon: icon, size: iconSize, color: spec.iconColor, badge: badge),
      ),
    );
  }
}
