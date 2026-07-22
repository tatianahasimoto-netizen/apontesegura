import 'package:flutter/material.dart';
import 'cpf_seguro_colors.dart';
import 'cpf_seguro_fonts.dart';
import 'generated/cps_type_tokens.g.dart';

/// CPF SEGURO — Typography.
///
/// Escala M3 completa (15 estilos: display/headline/title/body/label × lg/md/sm),
/// paridade 1:1 com o React (~/Desktop/cpf-seguro-app/src/styles/type.css).
///
/// Cores NÃO estão embutidas — aplique via `.copyWith(color: ...)` no callsite
/// (só `headline`, `body` e `eyebrow` — os presets do PageTitle/MenuSection —
/// já vêm coloridos por conveniência).
class CpfSeguroType {
  CpfSeguroType._();

  // ============ DISPLAY — hero screens, marketing ==========================
  // Inversão L3: a escala M3 + vozes limpas consomem o gerado do DTCG
  // (CpfSeguroTypeConsts, de tokens/type.tokens.json).
  //
  // A Ponte: Display/Headline usam Poppins; Title/Label/Body usam Roboto Flex
  // (ver CpfSeguroFonts — arquivos de fonte ainda pendentes de adicionar).
  static final TextStyle displayLg = CpfSeguroTypeConsts.displayLg.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);
  static final TextStyle displayMd = CpfSeguroTypeConsts.displayMd.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);
  static final TextStyle displaySm = CpfSeguroTypeConsts.displaySm.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);

  // ============ HEADLINE — títulos de seção grandes (w600, = app) ==========
  static final TextStyle headlineLg = CpfSeguroTypeConsts.headlineLg.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);
  static final TextStyle headlineMd = CpfSeguroTypeConsts.headlineMd.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);
  static final TextStyle headlineSm = CpfSeguroTypeConsts.headlineSm.copyWith(fontFamily: CpfSeguroFonts.familyPoppins);

  // ============ TITLE — títulos de screen/card =============================
  static final TextStyle titleLg = CpfSeguroTypeConsts.titleLg.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);
  static final TextStyle titleMd = CpfSeguroTypeConsts.titleMd.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);
  static final TextStyle titleSm = CpfSeguroTypeConsts.titleSm.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);

  // ============ BODY — texto de leitura ====================================
  static final TextStyle bodyLg = CpfSeguroTypeConsts.bodyLg.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);
  static final TextStyle bodyMd = CpfSeguroTypeConsts.bodyMd.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);
  static final TextStyle bodySm = CpfSeguroTypeConsts.bodySm.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);

  // ============ LABEL — botões, chips, eyebrows ============================
  /// Card titles ("Sou eu!", "CPF Seguro") — Roboto Flex Medium (A Ponte).
  static final TextStyle labelLg = CpfSeguroTypeConsts.labelLg.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);

  /// Section headers ("PARA VOCÊ"), "Ver todos".
  static final TextStyle labelMd = CpfSeguroTypeConsts.labelMd.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);

  /// Banner chip "Nível 1 de 3", banner eyebrow, status tags, tile labels.
  static final TextStyle labelSm = CpfSeguroTypeConsts.labelSm.copyWith(fontFamily: CpfSeguroFonts.familyRobotoFlex);

  // ═══════════════════════════════════════════════════════════════════════
  // VOZES — a API semântica (Apple-style: um nome por degrau). Cor SEMPRE do
  // scheme. A escala M3 acima é o "alfabeto"; estas são as "palavras".
  // Leitura usa a escala direto: bodyLg (16) e bodyMd (14) são as vozes de body.
  // ═══════════════════════════════════════════════════════════════════════

  /// Herói · valores grandes · celebração (raro).
  static const TextStyle display = CpfSeguroTypeConsts.display;

  /// Título de tela (h1).
  static const TextStyle title = CpfSeguroTypeConsts.title;

  /// Título de seção / card.
  static const TextStyle heading = CpfSeguroTypeConsts.heading;

  /// Sub-bloco · destaque forte ("Sou eu!").
  static const TextStyle subheading = CpfSeguroTypeConsts.subheading;

  /// Legenda · metadados · timestamps.
  static const TextStyle caption = CpfSeguroTypeConsts.caption;

  /// Rótulo de UI · chips · tags (tracked).
  static const TextStyle label = CpfSeguroTypeConsts.label;

  /// Kicker de seção — aplicar `.toUpperCase()`.
  static const TextStyle overline = CpfSeguroTypeConsts.overline;

  /// Texto de ação / CTA.
  static const TextStyle button = CpfSeguroTypeConsts.button;

  /// Figuras tabulares — OTP · valores.
  static const TextStyle numeric = TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1, letterSpacing: 0.5, fontFeatures: [FontFeature.tabularFigures()]);

  /// Relógio / system (status bar).
  static const TextStyle mono = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1, letterSpacing: -0.14);

  /// Corpo de bolha de chat (negrito é identidade — decisão do time).
  static const TextStyle chatBody = TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.4);

  // ============ PROTOTIPAGEM (numpad — fora do léxico: o app usa teclados
  // nativos; isto só existe pra reproduzir telas no catálogo) ===============

  /// Numpad key digit — 24 · height 1 · ls 0.5.
  static const TextStyle numpadDigit = TextStyle(
    fontSize: 24,
    height: 1,
    letterSpacing: 0.5,
    color: CpfSeguroColors.neutral01,
  );

  /// Numpad key sub-label (ABC, DEF…) — 9 · 500 · ls 1.5.
  static const TextStyle numpadSubLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: CpfSeguroColors.neutral01,
  );
}
