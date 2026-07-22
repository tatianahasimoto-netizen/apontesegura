import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_chat_input.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_nav.dart';
import 'cpf_seguro_navigation_button.dart';
import 'cpf_seguro_keyboard.dart' show CpfSeguroKeyboard;

export 'cpf_seguro_bottom_home_indicator.dart';
export 'cpf_seguro_nav.dart';
export 'cpf_seguro_navigation_button.dart';

/// CPF SEGURO — BottomApp (organismo unificado).
///
/// Único ponto de entrada pro slot inferior da tela. Cada variante é uma
/// **factory nomeada** que compõe moléculas + [CpfSeguroBottomHomeIndicator]
/// dentro de uma [CpfSeguroGlassSurface] (ou sem, no caso `.default()`).
///
/// **Filosofia atomic**:
/// - Átomo: [CpfSeguroBottomHomeIndicator]
/// - Moléculas: [CpfSeguroNav], [CpfSeguroNavigationButton], [CpfSeguroKeyboard],
///   [CpfSeguroChatInput]
/// - Organismo: este widget
///
/// Variantes:
/// - `.default()`             → só HomeIndicator (sem glass, sem fundo)
/// - `.nav(nav:)`             → Nav + indicator em glass
/// - `.button(button:)`       → NavigationButton + indicator em glass
/// - `.keyboard(keyboard:)`   → Keyboard + indicator cinza
/// - `.buttonAndKeyboard(button:, keyboard:)` → NavigationButton em glass + Keyboard + indicator cinza
/// - `.chatInput(input:)`     → ChatInput + indicator em glass
/// - `.chatInputAndKeyboard(input:, keyboard:)` → ChatInput em glass + Keyboard + indicator cinza
///
/// [heightFor] é o helper pra reservar espaço no shell.
class CpfSeguroBottomApp extends StatelessWidget {
  const CpfSeguroBottomApp._({required this.variant});

  final _BottomAppVariant variant;

  /// Só HomeIndicator, sem fundo, sem glass. Uso: Welcome, ErrorFatal, telas
  /// de resultado que não pedem barra fixa no rodapé.
  const CpfSeguroBottomApp.defaultVariant({super.key})
      : variant = const _DefaultVariant();

  /// Nav (tabs) em glass + indicator.
  CpfSeguroBottomApp.nav({super.key, required CpfSeguroNav nav})
      : variant = _NavVariant(nav);

  /// NavigationButton (1-3 CTAs) em glass + indicator.
  CpfSeguroBottomApp.button({
    super.key,
    required CpfSeguroNavigationButton button,
  }) : variant = _ButtonVariant(button);

  /// Keyboard (numpad) + indicator cinza. Sem glass (numpad já é cinza sólido).
  CpfSeguroBottomApp.keyboard({
    super.key,
    required CpfSeguroKeyboard keyboard,
  }) : variant = _KeyboardVariant(keyboard);

  /// NavigationButton em glass + Keyboard + indicator cinza.
  CpfSeguroBottomApp.buttonAndKeyboard({
    super.key,
    required CpfSeguroNavigationButton button,
    required CpfSeguroKeyboard keyboard,
  }) : variant = _ButtonAndKeyboardVariant(button, keyboard);

  /// ChatInput em glass + indicator.
  CpfSeguroBottomApp.chatInput({
    super.key,
    required CpfSeguroChatInput input,
  }) : variant = _ChatInputVariant(input);

  /// ChatInput em glass + Keyboard + indicator cinza.
  CpfSeguroBottomApp.chatInputAndKeyboard({
    super.key,
    required CpfSeguroChatInput input,
    required CpfSeguroKeyboard keyboard,
  }) : variant = _ChatInputAndKeyboardVariant(input, keyboard);

  /// Altura útil de cada variante — usar como `bottomSlotHeight` no shell pai.
  static double heightFor(_BottomAppVariant v) => v.height;

  // Constantes de altura por variante (compat com callers legados).
  static const double heightDefault = 34;
  // Nav = 16 headroom (estouro do ativo) + 76 row + 34 indicator.
  // Barra VISUAL = 110 (spec): glass + stroke white + shadow blackAlpha13.
  static const double heightNav = 126;
  static const double heightButton1 = 122;
  static const double heightButton2 = 190;
  static const double heightButton3 = 258;
  static const double heightKeyboard = 315;
  static const double heightChatInput = 122;
  static const double heightChatInputAndKeyboard = 369;
  static const double heightButtonAndKeyboardPrimaryOnly = 369;

  @override
  Widget build(BuildContext context) => variant.build();
}

// ═══════════════════════════════════════════════════════════════════════════
// Variantes
// ═══════════════════════════════════════════════════════════════════════════

sealed class _BottomAppVariant {
  const _BottomAppVariant();
  Widget build();
  double get height;
}

class _DefaultVariant extends _BottomAppVariant {
  const _DefaultVariant();
  @override
  double get height => CpfSeguroBottomApp.heightDefault;
  @override
  Widget build() => const CpfSeguroBottomHomeIndicator();
}

class _NavVariant extends _BottomAppVariant {
  const _NavVariant(this.nav);
  final CpfSeguroNav nav;
  @override
  double get height => CpfSeguroBottomApp.heightNav;

  /// Nav já traz glass + HomeIndicator próprios — embrulhar em GlassSurface
  /// aqui clipava o pop-out do item ativo (que estoura 16px acima da barra).
  @override
  Widget build() => nav;
}

class _ButtonVariant extends _BottomAppVariant {
  const _ButtonVariant(this.button);
  final CpfSeguroNavigationButton button;
  @override
  double get height => CpfSeguroBottomApp.heightButton1;
  @override
  Widget build() => CpfSeguroGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
              child: button,
            ),
            const CpfSeguroBottomHomeIndicator(),
          ],
        ),
      );
}

class _KeyboardVariant extends _BottomAppVariant {
  const _KeyboardVariant(this.keyboard);
  final CpfSeguroKeyboard keyboard;
  @override
  double get height => CpfSeguroBottomApp.heightKeyboard;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          keyboard,
          const CpfSeguroBottomHomeIndicator(background: CpfSeguroColors.neutral08),
        ],
      );
}

class _ButtonAndKeyboardVariant extends _BottomAppVariant {
  const _ButtonAndKeyboardVariant(this.button, this.keyboard);
  final CpfSeguroNavigationButton button;
  final CpfSeguroKeyboard keyboard;
  @override
  double get height => CpfSeguroBottomApp.heightButtonAndKeyboardPrimaryOnly;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CpfSeguroGlassSurface(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
              child: button,
            ),
          ),
          keyboard,
          const CpfSeguroBottomHomeIndicator(background: CpfSeguroColors.neutral08),
        ],
      );
}

class _ChatInputVariant extends _BottomAppVariant {
  const _ChatInputVariant(this.input);
  final CpfSeguroChatInput input;
  @override
  double get height => CpfSeguroBottomApp.heightChatInput;
  @override
  Widget build() => CpfSeguroGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(CpfSeguroSpacing.s6, CpfSeguroSpacing.s4, CpfSeguroSpacing.s6, CpfSeguroSpacing.s2),
              child: input,
            ),
            const CpfSeguroBottomHomeIndicator(),
          ],
        ),
      );
}

class _ChatInputAndKeyboardVariant extends _BottomAppVariant {
  const _ChatInputAndKeyboardVariant(this.input, this.keyboard);
  final CpfSeguroChatInput input;
  final CpfSeguroKeyboard keyboard;
  @override
  double get height => CpfSeguroBottomApp.heightChatInputAndKeyboard;
  @override
  Widget build() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CpfSeguroGlassSurface(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(CpfSeguroSpacing.s6, CpfSeguroSpacing.s4, CpfSeguroSpacing.s6, CpfSeguroSpacing.s4),
              child: input,
            ),
          ),
          keyboard,
          const CpfSeguroBottomHomeIndicator(background: CpfSeguroColors.neutral08),
        ],
      );
}
