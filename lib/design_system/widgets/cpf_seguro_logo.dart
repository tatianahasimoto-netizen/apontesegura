import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/cpf_seguro_colors.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Variante do logo.
enum CpfSeguroLogoVariant {
  /// Só o shield/símbolo (para top bars densas, favicon).
  mark,

  /// Símbolo + wordmark "CPF SEGURO" (áreas de branding).
  full,
}

/// CPF SEGURO — Logo oficial.
///
/// Consolida `CpfLogo` (mark) e `LogoCpfSeguro` (full/icon) do React em um
/// único widget. Aplica cor via `ColorFilter.srcIn` — SVG original é branco.
///
/// ```dart
/// CpfSeguroLogo(),                                            // mark 40px, primary-04
/// CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 24),
/// CpfSeguroLogo(color: CpfSeguroColors.white, size: 32),           // sobre bg escuro
/// ```
class CpfSeguroLogo extends StatelessWidget {
  const CpfSeguroLogo({
    super.key,
    this.variant = CpfSeguroLogoVariant.mark,
    this.size = 40,
    this.color = CpfSeguroColors.primary04,
  });

  final CpfSeguroLogoVariant variant;

  /// Altura em px (mark é 1:1; full escala proporcionalmente).
  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final asset = variant == CpfSeguroLogoVariant.full ? 'assets/logos/logo-full.svg' : 'assets/logos/logo.svg';
    return CpfSeguroDevInfo(
      component: 'CpfSeguroLogo',
      props: {'variant': variant.name, 'size': '${size.toInt()}'},
      tokens: ['color: ${cpfSeguroColorToken(color)}', 'asset: $asset'],
      child: SvgPicture.asset(
      asset,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: 'CPF SEGURO',
    ),
    );
  }
}
