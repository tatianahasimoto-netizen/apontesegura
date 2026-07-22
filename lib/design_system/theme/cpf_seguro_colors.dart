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

  /// primary-09 = wash mais claro ainda (bg do back office).
  static const Color primary09 = Color(CpfSeguroColorConsts.primary09);

  /// Tint pálido do app (alinhado com ColorsPalette.primary10 no app real).
  /// Fora do DTCG (specific do app) — literal.
  static const Color primary10 = Color(0xFFEEF3FF);

  static const Color primaryStateSelected = Color(CpfSeguroColorConsts.primaryStateSelected);
  static const Color primaryStateHover = Color(CpfSeguroColorConsts.primaryStateHover);
  static const Color brandOnPrimary = Color(CpfSeguroColorConsts.onPrimary);

  /// primary-04 @ 18% — chat button drop shadow.
  static const Color primary04Alpha18 = Color(0x2E003BE0);

  /// primary-05 @ 20% — bottom nav item ativo (lift shadow).
  static const Color primary05Alpha20 = Color(0x333369FF);

  /// primary-05 @ 32% — chat completion card drop shadow.
  static const Color primary05Alpha32 = Color(0x522157EF);

  /// primary-05 @ 40% — banner drop shadow.
  static const Color primary05Alpha40 = Color(0x662157EF);

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

  /// neutral-10 @ 70% — bg do toast normal (glass tint).
  static const Color neutral10Alpha70 = Color(0xB3F6F6F6);

  /// white @ 24% — banner chip bg (sobre gradient primary).
  static const Color whiteAlpha24 = Color(0x3DFFFFFF);

  /// white @ 32% — banner divider tracejado.
  static const Color whiteAlpha32 = Color(0x52FFFFFF);

  /// white @ 38% — banner chip border, completion dot inativo.
  static const Color whiteAlpha38 = Color(0x61FFFFFF);

  /// white @ 80% — glass surface (TopAppBar, BottomNav, Toast, sticky bars).
  static const Color whiteAlpha80 = Color(0xCCFFFFFF);

  /// white @ 90% — véu de sheet/scrim claro.
  static const Color whiteAlpha90 = Color(0xE6FFFFFF);

  /// black @ 8% — toast drop shadow.
  static const Color blackAlpha8 = Color(0x14000000);

  /// black @ 13% — card / bottom nav / bottomchatbar drop shadow.
  static const Color blackAlpha13 = Color(0x21000000);

  /// black @ 18% — numpad key press shadow.
  static const Color blackAlpha18 = Color(0x2D000000);

  /// black @ 20% — tooltip drop shadow.
  static const Color blackAlpha20 = Color(0x33000000);

  /// black @ 40% — scrim padrão de bottomsheet.
  static const Color blackAlpha40 = Color(0x66000000);

  /// black @ 85% — full-screen overlay (biometria).
  static const Color blackAlpha85 = Color(0xD9000000);

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

  /// Painel de erro sobre o gradient azul do StatusBanner (React #A23737).
  /// Vermelho dessaturado — o error-04 puro vibra demais sobre o brand.
  static const Color errorBanner = Color(0xFFA23737);

  /// Bg do cartão físico do parceiro na Carteira (Figma #272727).
  /// Mais frio que o neutral-01 — específico do WalletCard.partner.
  static const Color cardDark = Color(0xFF272727);

  /// error-04 @ 12% — error toast shadow.
  static const Color error04Alpha12 = Color(0x1FF04438);

  /// error-04 @ 20% — delete button shadow (back office).
  static const Color error04Alpha20 = Color(0x33F04438);

  /// error-04 @ 32% — destructive card shadow.
  static const Color error04Alpha32 = Color(0x52F04438);

  /// error-04 @ 40% — danger banner shadow.
  static const Color error04Alpha40 = Color(0x66F04438);

  /// error-07 @ 70% — bg do toast error (glass tint).
  static const Color error07Alpha70 = Color(0xB3FEF3F2);

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

  /// warning-07 @ 70% — bg do toast warning (glass tint).
  static const Color warning07Alpha70 = Color(0xB3FEF4E6);

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
  // SECURE mode (yellow) + alphas
  // ═══════════════════════════════════════════════════════════════════════

  /// Boss especificou: pausa NUNCA é vermelha; é amarelo.
  /// secure02 = dourado escuro sólido p/ o subtle bg do dark (par do
  /// warning02/error02). Derivado do 03 escurecido.
  static const Color secure02 = Color(CpfSeguroColorConsts.secure02);
  static const Color secure03 = Color(CpfSeguroColorConsts.secure03);
  static const Color secure04 = Color(CpfSeguroColorConsts.secure04);
  static const Color secure05 = Color(CpfSeguroColorConsts.secure05);
  static const Color secure07 = Color(CpfSeguroColorConsts.secure07);
  static const Color secure08 = Color(CpfSeguroColorConsts.secure08);

  /// secure-07 @ 38% — border amarelo pálido do chip de pausa no banner.
  static const Color secure07Alpha38 = Color(0x61FFFDD6);

  // ═══════════════════════════════════════════════════════════════════════
  // PARTNER (Aurora fictício)
  // ═══════════════════════════════════════════════════════════════════════

  static const Color partnerPrimary = Color(0xFFE55A2B);
  static const Color partnerPrimaryHover = Color(0xFFCC4D24);
  static const Color partnerOnPrimary = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════
  // TRANSPARENT (só o essencial — não precisa "overlayDark", "scrim" etc.
  // Esses estão sob NEUTRAL como blackAlpha40/85)
  // ═══════════════════════════════════════════════════════════════════════

  static const Color transparent = Color(0x00000000);
}
