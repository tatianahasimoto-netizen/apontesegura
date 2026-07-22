import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

class _NumKey {
  const _NumKey(this.n, [this.sub, this.type = _NumKeyType.number]);
  const _NumKey.blank() : n = '', sub = null, type = _NumKeyType.blank;
  const _NumKey.backspace() : n = '', sub = null, type = _NumKeyType.backspace;
  final String n;
  final String? sub;
  final _NumKeyType type;
}

enum _NumKeyType { number, blank, backspace }

const _numpadRows = <List<_NumKey>>[
  [_NumKey('1'), _NumKey('2', 'ABC'), _NumKey('3', 'DEF')],
  [_NumKey('4', 'GHI'), _NumKey('5', 'JKL'), _NumKey('6', 'MNO')],
  [_NumKey('7', 'PQRS'), _NumKey('8', 'TUV'), _NumKey('9', 'WXYZ')],
  [_NumKey.blank(), _NumKey('0'), _NumKey.backspace()],
];

class _Numpad extends StatelessWidget {
  const _Numpad({required this.onKey, required this.onBackspace});
  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CpfSeguroColors.neutral08,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: CpfSeguroSpacing.s4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < _numpadRows.length; r++) ...[
            if (r > 0) const SizedBox(height: 9),
            Row(
              children: [
                for (var i = 0; i < _numpadRows[r].length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _NumpadKey(
                      k: _numpadRows[r][i],
                      onPress: () {
                        final k = _numpadRows[r][i];
                        if (k.type == _NumKeyType.backspace) onBackspace();
                        else if (k.type == _NumKeyType.number) onKey(k.n);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({required this.k, required this.onPress});
  final _NumKey k;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    if (k.type == _NumKeyType.blank) return const SizedBox(height: 47);
    final s = CpfSeguroTheme.schemeOf(context);
    final isBackspace = k.type == _NumKeyType.backspace;
    return Semantics(
      button: true,
      label: isBackspace ? 'Apagar' : k.n,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            height: 47,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isBackspace ? CpfSeguroColors.transparent : s.surface,
              borderRadius: CpfSeguroRadius.all8,
              boxShadow: isBackspace
                  ? null
                  : CpfSeguroElevation.keyPress,
            ),
            child: isBackspace
                ? CpfSeguroIconAccessory(icon: CpfSeguroIcons.xmarkLight, padding: 0, size: 22, color: s.fg)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(k.n, style: CpfSeguroType.numpadDigit.copyWith(color: s.fg)),
                      if (k.sub != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(k.sub!, style: CpfSeguroType.numpadSubLabel.copyWith(color: s.fg)),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// CPF SEGURO — Numpad iOS público.
///
/// Reusável fora dos sheets — ex: dentro de CpfSeguroBottomButtonKeyboard.
/// Fundo cinza iOS (#D1D4DB), keys brancas com sombra sutil, backspace
/// como ícone xmark. Retorna `void` — o pai gerencia buffer.
class CpfSeguroKeyboard extends StatelessWidget {
  const CpfSeguroKeyboard({super.key, required this.onKey, required this.onBackspace});
  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) => _Numpad(onKey: onKey, onBackspace: onBackspace);
}

/// CPF SEGURO — KeyboardIndicator.
///
/// Barra de home indicator sobre o fundo cinza do numpad (fecha o teclado
/// numérico embaixo). Usada junto do [CpfSeguroKeyboard] em sheets de senha.
class CpfSeguroKeyboardIndicator extends StatelessWidget {
  const CpfSeguroKeyboardIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      color: CpfSeguroColors.neutral08,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: CpfSeguroSpacing.s2),
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: CpfSeguroColors.neutral01,
            borderRadius: CpfSeguroRadius.pillAll,
          ),
        ),
      ),
    );
  }
}
