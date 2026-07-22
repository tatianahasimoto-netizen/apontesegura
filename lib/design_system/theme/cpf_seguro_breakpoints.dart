/// CPF SEGURO — Breakpoints responsivos (largura de container).
///
/// Vindos das Figma Variables (coleção Containers). Base do DS web
/// (webadmin / IB) e da região `side` da gramática (ver DS_LANGUAGE.md §2):
/// a partir de [md] cabe nav lateral; abaixo de [sm] é layout compacto mobile.
///
/// Enriquecimento trazido do Figma (código é a fonte por ora — nomes EN).
abstract final class CpfSeguroBreakpoints {
  /// 640 — fim do mobile compacto.
  static const double sm = 640;

  /// 768 — tablet / início de layout com `side`.
  static const double md = 768;

  /// 1024 — desktop.
  static const double lg = 1024;

  /// 1280 — desktop largo.
  static const double xl = 1280;

  static const List<double> all = [sm, md, lg, xl];

  /// Tier da largura corrente — pra escolher layout responsivo.
  static CpfSeguroBreakpoint of(double width) {
    if (width < sm) return CpfSeguroBreakpoint.xs;
    if (width < md) return CpfSeguroBreakpoint.sm;
    if (width < lg) return CpfSeguroBreakpoint.md;
    if (width < xl) return CpfSeguroBreakpoint.lg;
    return CpfSeguroBreakpoint.xl;
  }
}

enum CpfSeguroBreakpoint { xs, sm, md, lg, xl }
