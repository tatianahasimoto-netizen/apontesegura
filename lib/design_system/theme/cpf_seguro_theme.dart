import 'package:flutter/widgets.dart';
import 'cpf_seguro_palette.dart';
import 'cpf_seguro_scheme.dart';

/// CPF SEGURO — Theme (tier 3, resolvido + provido).
///
/// Amarra **flavor** ([CpfSeguroPalette]) + **modo** ([Brightness]) num
/// [CpfSeguroScheme] resolvido, e distribui pela árvore via [InheritedWidget].
/// Widget consome com `CpfSeguroTheme.of(context)`.
///
/// Trocar de flavor OU de modo = trocar o [CpfSeguroThemeScope] que envolve a
/// tela; todo mundo abaixo repontar. É assim que o SDK white-label e o
/// dark/light vão funcionar sem tocar em cada widget.
@immutable
class CpfSeguroTheme {
  const CpfSeguroTheme({required this.scheme});

  /// Constrói a partir de flavor + modo (atalho comum).
  CpfSeguroTheme.resolve({
    CpfSeguroPalette palette = CpfSeguroPalette.cpf,
    Brightness brightness = Brightness.light,
  }) : scheme = brightness == Brightness.dark
            ? CpfSeguroScheme.dark(palette)
            : CpfSeguroScheme.light(palette);

  final CpfSeguroScheme scheme;

  CpfSeguroPalette get palette => scheme.palette;
  Brightness get brightness => scheme.brightness;
  bool get isDark => scheme.isDark;

  // Atalhos de flavor prontos.
  static final CpfSeguroTheme cpfLight =
      CpfSeguroTheme.resolve(palette: CpfSeguroPalette.cpf);
  static final CpfSeguroTheme cpfDark = CpfSeguroTheme.resolve(
      palette: CpfSeguroPalette.cpf, brightness: Brightness.dark);

  /// Lê o tema do contexto. Cai no flavor CPF light se não houver scope
  /// (mantém widgets ainda-não-migrados funcionando fora de um provider).
  static CpfSeguroTheme of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<CpfSeguroThemeScope>();
    return scope?.theme ?? cpfLight;
  }

  static CpfSeguroScheme schemeOf(BuildContext context) => of(context).scheme;
}

/// Envolve uma subárvore com um [CpfSeguroTheme]. Colocar na raiz da tela
/// (ou do phone shell) e trocar pra alternar modo/flavor.
class CpfSeguroThemeScope extends InheritedWidget {
  const CpfSeguroThemeScope({
    super.key,
    required this.theme,
    required super.child,
  });

  final CpfSeguroTheme theme;

  @override
  bool updateShouldNotify(CpfSeguroThemeScope oldWidget) =>
      oldWidget.theme.scheme != theme.scheme;
}
