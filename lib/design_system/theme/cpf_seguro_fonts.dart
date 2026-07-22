/// CPF SEGURO — Fontes empacotadas.
///
/// A fonte SF Pro Rounded é bundlada por este package. Os `TextStyle` do
/// [CpfSeguroType] não fixam família (herdam do tema), então o app consumidor
/// aplica a fonte no tema uma vez:
///
/// ```dart
/// import 'package:cpf_seguro_design_system/cpf_seguro_design_system.dart';
///
/// MaterialApp(
///   theme: ThemeData(fontFamily: CpfSeguroFonts.family),
///   ...
/// )
/// ```
///
/// [family] usa o prefixo `packages/<pkg>/<família>` — a forma do Flutter
/// resolver uma fonte que vem de um package.
abstract final class CpfSeguroFonts {
  static const String package = 'cpf_seguro_design_system';

  /// Família qualificada p/ usar em `ThemeData.fontFamily` no app consumidor.
  static const String family = 'packages/$package/SF Pro Rounded';

  /// Nome cru da família (uso interno do package / catálogo).
  static const String familyRaw = 'SF Pro Rounded';

  // ===========================================================================
  // A Ponte — duas famílias por camada tipográfica (Poppins para Display/
  // Headline, Roboto Flex para Title/Label/Body). Usadas em CpfSeguroType via
  // `.copyWith(fontFamily: ...)`.
  //
  // TODO(a-ponte): os arquivos de fonte ainda não foram adicionados a
  // assets/fonts/ nem registrados no `flutter: fonts:` do pubspec.yaml — sem
  // isso o Flutter cai no fallback do sistema silenciosamente (não quebra o
  // build, só não renderiza a fonte certa). Baixar/licenciar Poppins SemiBold
  // e Roboto Flex (Regular/Medium), colocar em assets/fonts/ e registrar no
  // pubspec.yaml antes de considerar isso pronto.
  // ===========================================================================

  static const String familyPoppins = 'Poppins';
  static const String familyRobotoFlex = 'Roboto Flex';
}
