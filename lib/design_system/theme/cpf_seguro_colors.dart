import 'package:flutter/material.dart';

import 'generated/cps_color_tokens.g.dart';

/// CPF SEGURO — Color tokens.
///
/// Fonte única de verdade extraída do Figma DS. Nunca hardcode um hex num
/// widget: referencie uma constante daqui. Paridade 1:1 com o React
/// (~/Desktop/cpf-seguro-app/src/styles/theme.css).
class CpfSeguroColors {
  CpfSeguroColors._();

  // ═══════════════════════════════════════════════════════════════════════
  // COMMON (A Ponte — Common/FG e Common/BG são distintos de Neutral/White)
  // ═══════════════════════════════════════════════════════════════════════

  static const Color commonFg = Color(CpfSeguroColorConsts.commonFg);
  static const Color commonBg = Color(CpfSeguroColorConsts.commonBg);
  static const Color commonBgMenu = Color(CpfSeguroColorConsts.commonBgMenu);

  // ═══════════════════════════════════════════════════════════════════════
  // PRIMARY (brand blue) + alphas
  // ═══════════════════════════════════════════════════════════════════════

  // Inversão L3: os primitivos consomem o gerado do DTCG (CpfSeguroColorConsts).
  static const Color primary01 = Color(CpfSeguroColorConsts.primary01);
  static const Color primary02 = Color(CpfSeguroColorConsts.primary02);
  static const Color primary03 = Color(CpfSeguroColorConsts.primary03);

  /// primary-04 = brand principal.
  static const Color primary04 = Color(CpfSeguroColorConsts.primary04);
  static const Color primary05 = Color(CpfSeguroColorConsts.primary05);
  static const Color primary06 = Color(CpfSeguroColorConsts.primary06);
  static const Color primary07 = Color(CpfSeguroColorConsts.primary07);

  /// primary-08 = wash background sutil.
  static const Color primary08 = Color(CpfSeguroColorConsts.primary08);

  /// Tint pálido do app (alinhado com ColorsPalette.primary10 no app real).
  /// Fora do DTCG (specific do app) — literal.
  static const Color primary10 = Color(0xFFEEF3FF);

  static const Color primaryStateSelected = Color(CpfSeguroColorConsts.primaryStateSelected);
  static const Color primaryStateHover = Color(CpfSeguroColorConsts.primaryStateHover);
  static const Color brandOnPrimary = Color(CpfSeguroColorConsts.onPrimary);

  // ═══════════════════════════════════════════════════════════════════════
  // NEUTRAL (gray) + alphas de white e black
  // ═══════════════════════════════════════════════════════════════════════

  static const Color neutral01 = Color(CpfSeguroColorConsts.neutral01);
  static const Color neutral02 = Color(CpfSeguroColorConsts.neutral02);
  static const Color neutral03 = Color(CpfSeguroColorConsts.neutral03);
  static const Color neutral04 = Color(CpfSeguroColorConsts.neutral04);
  static const Color neutral05 = Color(CpfSeguroColorConsts.neutral05);
  static const Color neutral06 = Color(CpfSeguroColorConsts.neutral06);
  static const Color neutral07 = Color(CpfSeguroColorConsts.neutral07);
  static const Color neutral08 = Color(CpfSeguroColorConsts.neutral08);
  static const Color neutral09 = Color(CpfSeguroColorConsts.neutral09);
  static const Color neutral10 = Color(CpfSeguroColorConsts.neutral10);

  /// Cinza escuro do app (alinhado com ColorsPalette.gray11 no app real).
  /// Fora do DTCG (specific do app) — literal.
  static const Color neutral11 = Color(0xFF2B2B2B);
  static const Color white = Color(CpfSeguroColorConsts.white);
  static const Color black = Color(CpfSeguroColorConsts.black);

  /// white @ 90% — véu de sheet/scrim claro.
  static const Color whiteAlpha90 = Color(0xE6FFFFFF);

  /// black @ 20% — tooltip drop shadow, gap marker (dev mode).
  static const Color blackAlpha20 = Color(0x33000000);

  /// black @ 40% — scrim padrão de bottomsheet, overlay de biometria.
  static const Color blackAlpha40 = Color(0x66000000);

  /// slate #101828 @ 10% / @ 6% — sombra do knob do ToggleSwitch (padrão iOS,
  /// 2 camadas). Cor levemente navy em vez de preto puro.
  static const Color slateAlpha10 = Color(0x1A101828);
  static const Color slateAlpha6 = Color(0x0F101828);

  // ═══════════════════════════════════════════════════════════════════════
  // ERROR (red) + alphas
  // ═══════════════════════════════════════════════════════════════════════

  static const Color error01 = Color(CpfSeguroColorConsts.error01);
  static const Color error02 = Color(CpfSeguroColorConsts.error02);
  static const Color error03 = Color(CpfSeguroColorConsts.error03);
  static const Color error04 = Color(CpfSeguroColorConsts.error04);
  static const Color error05 = Color(CpfSeguroColorConsts.error05);
  static const Color error06 = Color(CpfSeguroColorConsts.error06);
  static const Color error07 = Color(CpfSeguroColorConsts.error07);

  // ═══════════════════════════════════════════════════════════════════════
  // WARNING (amber) + alphas
  // ═══════════════════════════════════════════════════════════════════════

  static const Color warning01 = Color(CpfSeguroColorConsts.warning01);
  static const Color warning02 = Color(CpfSeguroColorConsts.warning02);
  static const Color warning03 = Color(CpfSeguroColorConsts.warning03);
  static const Color warning04 = Color(CpfSeguroColorConsts.warning04);
  static const Color warning05 = Color(CpfSeguroColorConsts.warning05);
  static const Color warning06 = Color(CpfSeguroColorConsts.warning06);
  static const Color warning07 = Color(CpfSeguroColorConsts.warning07);

  // ═══════════════════════════════════════════════════════════════════════
  // SUCCESS (green) + alphas
  // ═══════════════════════════════════════════════════════════════════════

  static const Color success01 = Color(CpfSeguroColorConsts.success01);
  static const Color success02 = Color(CpfSeguroColorConsts.success02);
  static const Color success03 = Color(CpfSeguroColorConsts.success03);
  static const Color success04 = Color(CpfSeguroColorConsts.success04);
  static const Color success05 = Color(CpfSeguroColorConsts.success05);
  static const Color success06 = Color(CpfSeguroColorConsts.success06);
  static const Color success07 = Color(CpfSeguroColorConsts.success07);

  /// success-07 @ 70% — bg do toast success (glass tint).
  static const Color success07Alpha70 = Color(0xB3F1FEF6);

  // ═══════════════════════════════════════════════════════════════════════
  // SECONDARY (A Ponte — acento usado em Card-Acordo / Status-tag)
  // ═══════════════════════════════════════════════════════════════════════

  static const Color secondary03 = Color(CpfSeguroColorConsts.secondary03);
  static const Color secondary06 = Color(CpfSeguroColorConsts.secondary06);
  static const Color secondary07 = Color(CpfSeguroColorConsts.secondary07);

  // ═══════════════════════════════════════════════════════════════════════
  // TRANSPARENT (só o essencial — não precisa "overlayDark", "scrim" etc.
  // Esses estão sob NEUTRAL como blackAlpha40)
  // ═══════════════════════════════════════════════════════════════════════

  static const Color transparent = Color(0x00000000);
}
