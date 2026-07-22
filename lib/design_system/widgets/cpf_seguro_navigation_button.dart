import 'package:flutter/widgets.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Descriptor de um CTA no [CpfSeguroNavigationButton].
class CpfSeguroNavigationAction {
  const CpfSeguroNavigationAction({
    required this.label,
    this.onPressed,
    this.leadIcon,
    this.disabled = false,
    this.state = CpfSeguroButtonState.normal,
    this.type,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? leadIcon;
  final bool disabled;
  final CpfSeguroButtonState state;

  /// Override do type do slot (default vem do slot: primary→primary,
  /// secondary→secondary, tertiary→tertiary).
  final CpfSeguroButtonType? type;
}

/// CPF SEGURO — NavigationButton (molécula).
///
/// Coluna de 1, 2 ou 3 CTAs (Button size lg fullWidth) empilhados com gap 12.
/// É o **conteúdo** do slot inferior — NÃO tem glass surface nem HomeIndicator.
/// Pra usar como rodapé real da tela, envolver em `CpfSeguroBottomApp.button()`
/// ou `.buttonAndKeyboard()`.
///
/// Variantes (definidas pelo número de slots preenchidos):
/// - só `primary`
/// - `primary` + `secondary`
/// - `primary` + `secondary` + `tertiary`
///
/// Cada slot também pode ter `state: error` pra CTA destrutiva.
///
/// ```dart
/// CpfSeguroNavigationButton(
///   primary: CpfSeguroNavigationAction(label: 'Continuar', onPressed: submit),
/// )
/// CpfSeguroNavigationButton(
///   primary: CpfSeguroNavigationAction(label: 'Salvar', onPressed: save),
///   secondary: CpfSeguroNavigationAction(label: 'Cancelar', onPressed: cancel),
/// )
/// ```
class CpfSeguroNavigationButton extends StatelessWidget {
  const CpfSeguroNavigationButton({
    super.key,
    this.primary,
    this.secondary,
    this.tertiary,
  });

  final CpfSeguroNavigationAction? primary;
  final CpfSeguroNavigationAction? secondary;
  final CpfSeguroNavigationAction? tertiary;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroDevInfo(
      component: 'CpfSeguroNavigationButton',
      props: {if (primary != null) 'primary': "'${primary!.label}'", if (secondary != null) 'secondary': "'${secondary!.label}'", if (tertiary != null) 'tertiary': "'${tertiary!.label}'"},
      tokens: const ['1-3 CTAs empilhados · gap 8 · dentro do BottomApp glass'],
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (primary != null)
          _slot(primary!, defaultType: CpfSeguroButtonType.primary),
        if (secondary != null) ...[
          if (primary != null) const SizedBox(height: 12),
          _slot(secondary!, defaultType: CpfSeguroButtonType.secondary),
        ],
        if (tertiary != null) ...[
          if (primary != null || secondary != null) const SizedBox(height: 12),
          _slot(tertiary!, defaultType: CpfSeguroButtonType.tertiary),
        ],
      ],
    ),
    );
  }

  Widget _slot(CpfSeguroNavigationAction a, {required CpfSeguroButtonType defaultType}) {
    return CpfSeguroButton(
      label: a.label,
      type: a.type ?? defaultType,
      state: a.state,
      size: CpfSeguroButtonSize.lg,
      fullWidth: true,
      leadIcon: a.leadIcon,
      disabled: a.disabled,
      onPressed: a.onPressed,
    );
  }
}
