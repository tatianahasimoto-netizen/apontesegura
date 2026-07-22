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
}
