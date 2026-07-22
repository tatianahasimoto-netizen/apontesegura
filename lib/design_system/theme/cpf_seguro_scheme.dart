import 'package:flutter/widgets.dart';
import 'cpf_seguro_colors.dart';
import 'cpf_seguro_palette.dart';

/// CPF SEGURO — Scheme (semântica / tier 2).
///
/// Espelha a coleção `0.Theme` do Figma (modos Light/Dark). Cada campo é um
/// **papel** (BG, FG, Primary...), não uma cor crua. Resolve os primitivos de
/// um [CpfSeguroPalette] conforme o modo.
///
/// É isto que os widgets consomem (via `CpfSeguroTheme.of(context).scheme`),
/// nunca [CpfSeguroPalette] direto. Nome de cada papel segue os grupos do
/// Figma: Common (bg/bgMenu/fg), Neutral (surface/border/muted), Brand
/// (primary...), e as famílias de status.
///
/// `.light(palette)` reproduz 1:1 o uso atual do DS (não-quebra). `.dark(...)`
/// é 1ª versão — afinar contra os valores Dark do Figma depois.
@immutable
class CpfSeguroScheme {
  const CpfSeguroScheme({
    required this.brightness,
    required this.palette,
    // Common
    required this.bg,
    required this.bgMenu,
    required this.fg,
    // Superfície (card / sheet / glass base)
    required this.surface,
    required this.onSurface,
    required this.surfaceMuted,
    // Texto hierárquico (régua neutral 01→05: fg/secondary/tertiary/muted/placeholder)
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.textPlaceholder,
    // Bordas / divisores
    required this.border,
    required this.divider,
    // Glass (tint da superfície glassy — muda com o modo)
    required this.glassTint,
    // Brand
    required this.primary,
    required this.onPrimary,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primarySubtle,
    required this.onPrimarySubtle,
    // Status — success / warning / error / secure (base + subtle bg)
    required this.success,
    required this.onSuccess,
    required this.successSubtle,
    required this.warning,
    required this.onWarning,
    required this.warningSubtle,
    required this.error,
    required this.onError,
    required this.errorSubtle,
    required this.secure,
    required this.onSecure,
    required this.secureSubtle,
    // Partner (cobranding — mode-agnóstico)
    required this.partner,
    required this.onPartner,
  });

  final Brightness brightness;
  final CpfSeguroPalette palette;

  /// Common — fundo geral da tela.
  final Color bg;

  /// Common — fundo da barra de menu / navegação (glass base).
  final Color bgMenu;

  /// Common — texto/ícone de maior contraste sobre [bg].
  final Color fg;

  /// Fundo de card / sheet (elevado sobre [bg]).
  final Color surface;

  /// Conteúdo de maior contraste sobre [surface].
  final Color onSurface;

  /// Fundo sutil (chip neutro, campo desabilitado, wash).
  final Color surfaceMuted;

  final Color textSecondary, textTertiary, textMuted, textPlaceholder;
  final Color border, divider;

  /// Tint da superfície glassy (nav, top bar, toast). Light = white@80;
  /// dark = tint escuro. Consumido por CpfSeguroGlassSurface.
  final Color glassTint;

  final Color primary, onPrimary, primaryHover, primaryPressed;

  /// Fundo suave da marca (accent bg — ex: spot de ícone azul).
  final Color primarySubtle;

  /// Conteúdo sobre [primarySubtle].
  final Color onPrimarySubtle;

  final Color success, onSuccess, successSubtle;
  final Color warning, onWarning, warningSubtle;
  final Color error, onError, errorSubtle;
  final Color secure, onSecure, secureSubtle;

  /// Partner (cobranding) — cor do parceiro white-label. Mode-agnóstico.
  final Color partner, onPartner;

  // ═══════════════════════════════════════════════════════════════════════
  // LIGHT — resolve o palette pro uso atual do DS (paridade 1:1 com o legado)
  // ═══════════════════════════════════════════════════════════════════════
  factory CpfSeguroScheme.light(CpfSeguroPalette p) => CpfSeguroScheme(
        brightness: Brightness.light,
        palette: p,
        bg: p.white,
        bgMenu: p.white,
        fg: p.neutral01,
        surface: p.white,
        onSurface: p.neutral01,
        surfaceMuted: p.neutral09,
        textSecondary: p.neutral02,
        textTertiary: p.neutral03,
        textMuted: p.neutral04,
        textPlaceholder: p.neutral05,
        border: p.neutral08,
        divider: p.neutral09,
        glassTint: const Color(0xCCFFFFFF), // white @ 80%

        primary: p.primary04,
        onPrimary: p.onPrimary,
        primaryHover: p.primaryStateHover,
        primaryPressed: p.primaryStateSelected,
        primarySubtle: p.primary08,
        onPrimarySubtle: p.primary04,
        success: p.success04,
        onSuccess: p.white,
        successSubtle: p.success07,
        warning: p.warning04,
        onWarning: p.white,
        warningSubtle: p.warning07,
        error: p.error04,
        onError: p.white,
        errorSubtle: p.error07,
        secure: p.secure04,
        onSecure: p.neutral01,
        secureSubtle: p.secure08,
        partner: CpfSeguroColors.partnerPrimary,
        onPartner: CpfSeguroColors.partnerOnPrimary,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // DARK — 1ª versão. Fundo = primary escuro, marca clareia (primary-06).
  // Afinar contra os valores Dark do Figma (variable defs) antes de shippar.
  // ═══════════════════════════════════════════════════════════════════════
  factory CpfSeguroScheme.dark(CpfSeguroPalette p) => CpfSeguroScheme(
        brightness: Brightness.dark,
        palette: p,
        // Superfícies dessaturadas (dark slate com leve tom navy) — não o
        // primary02/03 vivo, que virava "bloco azul". bg quase preto, surface
        // e surfaceMuted como elevações neutras.
        bg: const Color(0xFF0B1020),
        bgMenu: const Color(0xFF161C2E),
        fg: p.neutral10,
        surface: const Color(0xFF161C2E),
        onSurface: p.neutral10,
        surfaceMuted: const Color(0xFF212A42),
        textSecondary: p.neutral07,
        textTertiary: p.neutral06,
        textMuted: p.neutral05,
        textPlaceholder: p.neutral05,
        border: const Color(0x14FFFFFF), // white @ 8%
        divider: const Color(0x14FFFFFF),
        glassTint: const Color(0xCC000000), // black @ 80%

        // primary-05 (vivo) em vez do primary-06 (lavado) — a marca precisa
        // pulsar no dark. onPrimary = branco (lê bem sobre o azul).
        primary: p.primary05,
        onPrimary: p.white,
        primaryHover: p.primary04,
        primaryPressed: p.primary03,
        primarySubtle: p.primary03,
        onPrimarySubtle: p.primary06,
        success: p.success05,
        onSuccess: p.success01,
        successSubtle: p.success02,
        warning: p.warning05,
        onWarning: p.warning01,
        warningSubtle: p.warning02,
        error: p.error05,
        onError: p.error01,
        errorSubtle: p.error02,
        secure: p.secure05,
        onSecure: p.secure03,
        secureSubtle: p.secure02,
        partner: CpfSeguroColors.partnerPrimary,
        onPartner: CpfSeguroColors.partnerOnPrimary,
      );

  bool get isDark => brightness == Brightness.dark;
}
