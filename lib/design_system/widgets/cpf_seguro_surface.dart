import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — Surface.
///
/// O primitivo de composição da **gramática** do DS: toda superfície (screen,
/// modal, bottomsheet) se monta navegando por três regiões —
/// **top · content · bottom**.
///
/// - `top` — barra superior (ex: [CpfSeguroTopAppBar] / NavigationTopBar).
/// - `content` — região principal, rolável por default.
/// - `bottom` — slot inferior (ex: [CpfSeguroBottomApp]: nav, botão, teclado…).
///
/// Não é a raiz do sistema — é um primitivo (cobre ~80-90% das telas). Layouts
/// que fogem de 3 fatias (hero full-bleed, split, web com side-nav) usam outros
/// primitivos. Ver `DS_LANGUAGE.md` §2.
///
/// ```dart
/// CpfSeguroSurface(
///   top: CpfSeguroTopAppBar.defaultVariant(navBar: nav),
///   content: Column(children: [...]),
///   bottom: CpfSeguroBottomApp.button(button: cta),
/// )
///
/// // sheet: mesma gramática, cantos arredondados, sobre surface
/// CpfSeguroSurface.sheet(
///   top: CpfSeguroTopAppBar.bottomsheet(navBar: nav),
///   content: Column(children: [...]),
///   bottom: CpfSeguroBottomApp.button(button: cta),
/// )
/// ```
class CpfSeguroSurface extends StatelessWidget {
  const CpfSeguroSurface({
    super.key,
    this.top,
    required this.content,
    this.bottom,
    this.scrollableContent = true,
    this.contentPadding,
    this.background,
  }) : _sheet = false;

  /// Superfície de sheet/modal: cantos superiores arredondados (r24) e fundo
  /// sólido de surface (sem gradient de tela).
  const CpfSeguroSurface.sheet({
    super.key,
    this.top,
    required this.content,
    this.bottom,
    this.scrollableContent = true,
    this.contentPadding,
    this.background,
  }) : _sheet = true;

  /// Região superior. Omitir = sem top.
  final Widget? top;

  /// Região principal.
  final Widget content;

  /// Região inferior. Omitir = sem bottom.
  final Widget? bottom;

  /// Content rolável (default true). False = content estático (o próprio
  /// widget controla o layout).
  final bool scrollableContent;

  /// Padding do content. Default: h s6 · v s4.
  final EdgeInsets? contentPadding;

  /// Fundo. Default screen: gradient screenBg (light) / s.bg (dark).
  /// Default sheet: s.surface.
  final Decoration? background;

  final bool _sheet;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final pad = contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: CpfSeguroSpacing.s6,
          vertical: CpfSeguroSpacing.s4,
        );

    final decoration = background ??
        (_sheet
            ? BoxDecoration(color: s.surface)
            : (s.isDark
                ? BoxDecoration(color: s.bg)
                : const BoxDecoration(gradient: CpfSeguroGradients.screenBg)));

    final middle = scrollableContent
        ? SingleChildScrollView(padding: pad, child: content)
        : Padding(padding: pad, child: content);

    Widget column = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (top != null) top!,
        Expanded(child: middle),
        if (bottom != null) bottom!,
      ],
    );

    Widget surface = DecoratedBox(decoration: decoration, child: column);

    if (_sheet) {
      surface = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: surface,
      );
    }
    return surface;
  }
}
