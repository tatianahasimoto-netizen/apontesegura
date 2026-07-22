import 'package:flutter/widgets.dart';
import 'cpf_seguro_colors.dart';
import 'generated/cps_elevation_tokens.g.dart';

/// CPF SEGURO — Elevation (tier suporte).
///
/// Espelha a coleção `Elevation` do Figma, mas **filtrada** pro que o DS usa
/// de verdade: das 21 do Figma sobram 7 sombras reais em 2 famílias —
/// **neutra** (preto, superfícies) e **brand lift** (azul, elementos que
/// "pulam" com a marca). Rings de foco (`primary-07`/`error-07` com spread)
/// não são elevação e vivem no border, fora daqui.
///
/// Uso: `boxShadow: CpfSeguroElevation.low` (drop-in nos `boxShadow:` que hoje
/// estão inline). Valores light = 1:1 com o legado, migração é troca exata.
///
/// Mode-aware: `resolve(level, dark: theme.isDark)`. Dark é 1ª versão —
/// sombra neutra aprofunda o preto; brand mantém (a marca continua "acesa").
enum CpfSeguroElevationLevel { low, medium, soft, overlay, brandLow, brandMedium, brandHigh }

class CpfSeguroElevation {
  CpfSeguroElevation._();

  // ─── Neutra (preto) — superfícies ────────────────────────────────────────

  // Inversão L3: as shadows estáticas consomem o gerado (CpfSeguroElevationConsts,
  // de tokens/elevation.tokens.json). Dark, funções e resolve() seguem no Dart.

  /// Card / nav base. black@13 · (0,2) · blur 8.
  static const List<BoxShadow> low = CpfSeguroElevationConsts.low;

  /// Card flutuante / bottom bar / chat bar. black@13 · (5,4) · blur 20.
  static const List<BoxShadow> medium = CpfSeguroElevationConsts.medium;

  /// Toast. black@8 · (0,4) · blur 10 (mais leve, feedback flutuante).
  static const List<BoxShadow> soft = CpfSeguroElevationConsts.soft;

  /// Tooltip / popover. black@20 · (0,4) · blur 12.
  static const List<BoxShadow> overlay = CpfSeguroElevationConsts.overlay;

  /// Overlay grande (dev inspect / popover largo). black@20 · (0,4) · blur 16.
  static const List<BoxShadow> overlayLg = CpfSeguroElevationConsts.overlayLg;

  /// Tecla do numpad (pressionada). black@18 · (0,1) · sem blur.
  static const List<BoxShadow> keyPress = CpfSeguroElevationConsts.keyPress;

  // ─── Brand lift (azul) — elementos com a marca ───────────────────────────

  /// Chat button. primary-04@18 · (0,2) · blur 8.
  static const List<BoxShadow> brandLow = CpfSeguroElevationConsts.brandLow;

  /// Banner "PARA VOCÊ". primary-05@40 · (2,8) · blur 20.
  static const List<BoxShadow> brandMedium = CpfSeguroElevationConsts.brandMedium;

  /// Chat completion card. primary-05@32 · (0,12) · blur 40.
  static const List<BoxShadow> brandHigh = CpfSeguroElevationConsts.brandHigh;

  /// Nav item ativo (glow suave da marca). primary-04@18 · (0,4) · blur 10.
  static const List<BoxShadow> brandSoft = CpfSeguroElevationConsts.brandSoft;

  // ─── Receitas do app (produção) — fonte única do bridge do app ───────────

  /// Sopro sutil (bolha de chat / instrução). black@2 · (0,2) · blur 5.
  /// (App `Shadows.soft`; renomeado p/ não colidir com [soft].)
  static const List<BoxShadow> subtle = CpfSeguroElevationConsts.subtle;

  /// Input flutuante (barras/campos do onboarding). black@10 · (5,4) · blur 20.
  static const List<BoxShadow> input = CpfSeguroElevationConsts.input;

  /// Footer ancorado — sombra pra CIMA. gray01@5 · (0,-4) · blur 10.
  static const List<BoxShadow> footerUp = CpfSeguroElevationConsts.footerUp;

  /// Botão de ícone flutuante (pesada). black@50 · (0,4) · blur 10.
  static const List<BoxShadow> heavy = CpfSeguroElevationConsts.heavy;

  /// Glow da marca no item ativo da bottom nav. primary-04@35 · (0,2) · blur 10.
  static const List<BoxShadow> navGlow = CpfSeguroElevationConsts.navGlow;

  /// Lift de card-herói — a cor acompanha o gradiente. base@35 · (0,10) · blur 24.
  static List<BoxShadow> heroLift(Color base) => [
        BoxShadow(color: base.withValues(alpha: 0.35), offset: const Offset(0, 10), blurRadius: 24),
      ];

  /// Lift compacto dos level cards. base@40 · (2,8) · blur 24.
  static List<BoxShadow> cardLift(Color base) => [
        BoxShadow(color: base.withValues(alpha: 0.4), offset: const Offset(2, 8), blurRadius: 24),
      ];

  // ─── Dark (1ª versão) — neutra aprofunda; brand mantém ───────────────────

  static const List<BoxShadow> _lowDark = [
    BoxShadow(color: CpfSeguroColors.blackAlpha40, offset: Offset(0, 2), blurRadius: 8),
  ];
  static const List<BoxShadow> _mediumDark = [
    BoxShadow(color: CpfSeguroColors.blackAlpha40, offset: Offset(5, 4), blurRadius: 20),
  ];
  static const List<BoxShadow> _softDark = [
    BoxShadow(color: CpfSeguroColors.blackAlpha20, offset: Offset(0, 4), blurRadius: 10),
  ];
  static const List<BoxShadow> _overlayDark = [
    BoxShadow(color: CpfSeguroColors.blackAlpha40, offset: Offset(0, 4), blurRadius: 12),
  ];

  /// Resolve nível + modo. Brand não muda no dark (só neutra aprofunda).
  static List<BoxShadow> resolve(CpfSeguroElevationLevel level, {bool dark = false}) {
    switch (level) {
      case CpfSeguroElevationLevel.low:
        return dark ? _lowDark : low;
      case CpfSeguroElevationLevel.medium:
        return dark ? _mediumDark : medium;
      case CpfSeguroElevationLevel.soft:
        return dark ? _softDark : soft;
      case CpfSeguroElevationLevel.overlay:
        return dark ? _overlayDark : overlay;
      case CpfSeguroElevationLevel.brandLow:
        return brandLow;
      case CpfSeguroElevationLevel.brandMedium:
        return brandMedium;
      case CpfSeguroElevationLevel.brandHigh:
        return brandHigh;
    }
  }
}
