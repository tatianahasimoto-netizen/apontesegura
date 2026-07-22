import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Gap (primitivo instrumentado).
///
/// Espaço (SizedBox) instrumentado — no dev mode, hover mostra o valor do
/// gap. Uso: `CpfSeguroGap.h(24)` (vertical) · `CpfSeguroGap.w(12)` (horizontal).
class CpfSeguroGap extends StatelessWidget {
  const CpfSeguroGap.h(this.size, {super.key}) : _vertical = true;
  const CpfSeguroGap.w(this.size, {super.key}) : _vertical = false;

  final double size;
  final bool _vertical;

  @override
  Widget build(BuildContext context) {
    final box = _vertical ? SizedBox(height: size) : SizedBox(width: size);
    if (!CpfSeguroDevMode.of(context)) return box;
    // Pinta uma faixa fina translúcida sobre o gap só pra dar hit-area e
    // marcar visualmente o espaçamento.
    return CpfSeguroDevInfo(
      component: 'gap',
      props: {(_vertical ? 'height' : 'width'): '${size.toInt()}px'},
      tokens: const [],
      child: _vertical
          ? SizedBox(height: size, width: double.infinity, child: const _GapMarker(vertical: true))
          : SizedBox(width: size, height: double.infinity, child: const _GapMarker(vertical: false)),
    );
  }
}

class _GapMarker extends StatelessWidget {
  const _GapMarker({required this.vertical});
  final bool vertical;
  @override
  Widget build(BuildContext context) => const ColoredBox(color: CpfSeguroColors.blackAlpha20);
}
