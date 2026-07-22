import 'package:flutter/widgets.dart';

import 'generated/cps_color_tokens.g.dart';

/// CPF SEGURO — Palette (primitivos / tier 1).
///
/// Espelha as coleções `Palette 01/02/03` do Figma: rampas cruas de cor,
/// uma **instância por flavor**. Trocar de flavor (ex: SDK dentro do app de
/// um parceiro white-label) = trocar a instância de [CpfSeguroPalette]; a
/// camada semântica ([CpfSeguroScheme]) repontar sozinha.
///
/// REGRA: componente **nunca** lê primitivo daqui. Lê [CpfSeguroScheme] (papel
/// semântico). Isto aqui é matéria-prima da paleta, não contrato de uso.
///
/// `CpfSeguroPalette.cpf` = flavor padrão (azul CPF SEGURO), valores 1:1 com o
/// legado `CpfSeguroColors`. Flavors de parceiro entram como novas instâncias.
@immutable
class CpfSeguroPalette {
  const CpfSeguroPalette({
    required this.id,
    // Primary (brand)
    required this.primary01,
    required this.primary02,
    required this.primary03,
    required this.primary04,
    required this.primary05,
    required this.primary06,
    required this.primary07,
    required this.primary08,
    required this.primary09,
    required this.primaryStateSelected,
    required this.primaryStateHover,
    required this.onPrimary,
    // Neutral
    required this.neutral01,
    required this.neutral02,
    required this.neutral03,
    required this.neutral04,
    required this.neutral05,
    required this.neutral06,
    required this.neutral07,
    required this.neutral08,
    required this.neutral09,
    required this.neutral10,
    required this.white,
    required this.black,
    // Error
    required this.error01,
    required this.error02,
    required this.error03,
    required this.error04,
    required this.error05,
    required this.error06,
    required this.error07,
    // Warning
    required this.warning01,
    required this.warning02,
    required this.warning03,
    required this.warning04,
    required this.warning05,
    required this.warning06,
    required this.warning07,
    // Success
    required this.success01,
    required this.success02,
    required this.success03,
    required this.success04,
    required this.success05,
    required this.success06,
    required this.success07,
    // Secure (modo segurança — sempre amarelo, nunca vermelho)
    required this.secure02,
    required this.secure03,
    required this.secure04,
    required this.secure05,
    required this.secure07,
    required this.secure08,
    // Secondary (A Ponte — família de acento que o cpf-seguro-ds não tinha)
    required this.secondary03,
    required this.secondary06,
    required this.secondary07,
    // Common (A Ponte — Common/FG e Common/BG são distintos de Neutral/White)
    required this.commonFg,
    required this.commonBg,
    required this.commonBgMenu,
    // Brand (A Ponte — Brand/Principal é um token à parte da rampa Primary)
    required this.brandPrincipal,
    required this.brandOnPrincipal,
    required this.brandAlpha15,
  });

  /// Identificador do flavor ('cpf', 'aurora', ...). Aparece no dev inspect.
  final String id;

  final Color primary01, primary02, primary03, primary04, primary05, primary06, primary07, primary08, primary09;
  final Color primaryStateSelected, primaryStateHover, onPrimary;

  final Color neutral01, neutral02, neutral03, neutral04, neutral05, neutral06, neutral07, neutral08, neutral09, neutral10;
  final Color white, black;

  final Color error01, error02, error03, error04, error05, error06, error07;
  final Color warning01, warning02, warning03, warning04, warning05, warning06, warning07;
  final Color success01, success02, success03, success04, success05, success06, success07;
  final Color secure02, secure03, secure04, secure05, secure07, secure08;

  final Color secondary03, secondary06, secondary07;
  final Color commonFg, commonBg, commonBgMenu;
  final Color brandPrincipal, brandOnPrincipal, brandAlpha15;

  // ═══════════════════════════════════════════════════════════════════════
  // Flavor padrão — CPF SEGURO (azul). 1:1 com o legado CpfSeguroColors.
  // ═══════════════════════════════════════════════════════════════════════
  // INVERSÃO (L3): os primitivos do flavor cpf CONSOMEM o gerado do DTCG
  // (CpfSeguroColorConsts, de tokens/color.cpf.tokens.json). Editar cor = editar
  // o DTCG + `npm run tokens`. Continua `const` (Color(const int) é const).
  static const CpfSeguroPalette cpf = CpfSeguroPalette(
    id: 'cpf',
    primary01: Color(CpfSeguroColorConsts.primary01),
    primary02: Color(CpfSeguroColorConsts.primary02),
    primary03: Color(CpfSeguroColorConsts.primary03),
    primary04: Color(CpfSeguroColorConsts.primary04),
    primary05: Color(CpfSeguroColorConsts.primary05),
    primary06: Color(CpfSeguroColorConsts.primary06),
    primary07: Color(CpfSeguroColorConsts.primary07),
    primary08: Color(CpfSeguroColorConsts.primary08),
    primary09: Color(CpfSeguroColorConsts.primary09),
    primaryStateSelected: Color(CpfSeguroColorConsts.primaryStateSelected),
    primaryStateHover: Color(CpfSeguroColorConsts.primaryStateHover),
    onPrimary: Color(CpfSeguroColorConsts.onPrimary),
    neutral01: Color(CpfSeguroColorConsts.neutral01),
    neutral02: Color(CpfSeguroColorConsts.neutral02),
    neutral03: Color(CpfSeguroColorConsts.neutral03),
    neutral04: Color(CpfSeguroColorConsts.neutral04),
    neutral05: Color(CpfSeguroColorConsts.neutral05),
    neutral06: Color(CpfSeguroColorConsts.neutral06),
    neutral07: Color(CpfSeguroColorConsts.neutral07),
    neutral08: Color(CpfSeguroColorConsts.neutral08),
    neutral09: Color(CpfSeguroColorConsts.neutral09),
    neutral10: Color(CpfSeguroColorConsts.neutral10),
    white: Color(CpfSeguroColorConsts.white),
    black: Color(CpfSeguroColorConsts.black),
    error01: Color(CpfSeguroColorConsts.error01),
    error02: Color(CpfSeguroColorConsts.error02),
    error03: Color(CpfSeguroColorConsts.error03),
    error04: Color(CpfSeguroColorConsts.error04),
    error05: Color(CpfSeguroColorConsts.error05),
    error06: Color(CpfSeguroColorConsts.error06),
    error07: Color(CpfSeguroColorConsts.error07),
    warning01: Color(CpfSeguroColorConsts.warning01),
    warning02: Color(CpfSeguroColorConsts.warning02),
    warning03: Color(CpfSeguroColorConsts.warning03),
    warning04: Color(CpfSeguroColorConsts.warning04),
    warning05: Color(CpfSeguroColorConsts.warning05),
    warning06: Color(CpfSeguroColorConsts.warning06),
    warning07: Color(CpfSeguroColorConsts.warning07),
    success01: Color(CpfSeguroColorConsts.success01),
    success02: Color(CpfSeguroColorConsts.success02),
    success03: Color(CpfSeguroColorConsts.success03),
    success04: Color(CpfSeguroColorConsts.success04),
    success05: Color(CpfSeguroColorConsts.success05),
    success06: Color(CpfSeguroColorConsts.success06),
    success07: Color(CpfSeguroColorConsts.success07),
    secure02: Color(CpfSeguroColorConsts.secure02),
    secure03: Color(CpfSeguroColorConsts.secure03),
    secure04: Color(CpfSeguroColorConsts.secure04),
    secure05: Color(CpfSeguroColorConsts.secure05),
    secure07: Color(CpfSeguroColorConsts.secure07),
    secure08: Color(CpfSeguroColorConsts.secure08),
    secondary03: Color(CpfSeguroColorConsts.secondary03),
    secondary06: Color(CpfSeguroColorConsts.secondary06),
    secondary07: Color(CpfSeguroColorConsts.secondary07),
    commonFg: Color(CpfSeguroColorConsts.commonFg),
    commonBg: Color(CpfSeguroColorConsts.commonBg),
    commonBgMenu: Color(CpfSeguroColorConsts.commonBgMenu),
    brandPrincipal: Color(CpfSeguroColorConsts.brandPrincipal),
    brandOnPrincipal: Color(CpfSeguroColorConsts.brandOnPrincipal),
    brandAlpha15: Color(CpfSeguroColorConsts.brandAlpha15),
  );

  /// Flavors disponíveis (cresce quando entrar parceiro white-label).
  static const List<CpfSeguroPalette> all = [cpf];
}
