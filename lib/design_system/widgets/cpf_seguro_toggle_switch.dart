import 'package:flutter/material.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tamanho do ToggleSwitch — mirror do Figma DS (node 2365:32193).
enum CpfSeguroToggleSize { sm, md }

/// CPF SEGURO — ToggleSwitch.
///
/// Switch binário on/off. Track primary-04 quando on, neutral-09 quando off.
/// Hover: primary-03 / neutral-07. Disabled: neutral-09 + thumb neutral-07.
/// Focus ring #F1F2F6 4px (opt-in via [showFocusRing]).
///
/// ```dart
/// CpfSeguroToggleSwitch(value: bio, onChanged: (v) => setState(() => bio = v)),
/// CpfSeguroToggleSwitch(value: skip, onChanged: onSkipChange, size: CpfSeguroToggleSize.sm),
/// ```
class CpfSeguroToggleSwitch extends StatefulWidget {
  const CpfSeguroToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = CpfSeguroToggleSize.md,
    this.disabled = false,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final CpfSeguroToggleSize size;
  final bool disabled;
  final String? semanticLabel;

  @override
  State<CpfSeguroToggleSwitch> createState() => _CpsToggleSwitchState();
}

class _CpsToggleSwitchState extends State<CpfSeguroToggleSwitch> {
  bool _hover = false;
  bool _focus = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final sz = _sizing(widget.size);
    final trackColor = _trackColor(s);
    final thumbColor = widget.disabled ? CpfSeguroColors.neutral07 : CpfSeguroColors.white;
    final disabled = widget.disabled || widget.onChanged == null;

    Widget core = AnimatedContainer(
      duration: CpfSeguroMotion.control.duration,
      width: sz.width,
      height: sz.height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: CpfSeguroRadius.pillAll,
        boxShadow: _focus && !disabled
            ? [BoxShadow(color: s.surfaceMuted, blurRadius: 0, spreadRadius: 4)]
            : null,
      ),
      child: AnimatedAlign(
        duration: CpfSeguroMotion.control.duration,
        curve: CpfSeguroMotion.control.curve,
        alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: CpfSeguroMotion.control.duration,
          width: sz.thumb,
          height: sz.thumb,
          decoration: BoxDecoration(
            color: thumbColor,
            shape: BoxShape.circle,
            boxShadow: disabled
                ? null
                : const [
                    BoxShadow(color: CpfSeguroColors.slateAlpha10, blurRadius: 3, offset: Offset(0, 1)),
                    BoxShadow(color: CpfSeguroColors.slateAlpha6, blurRadius: 2, offset: Offset(0, 1)),
                  ],
          ),
        ),
      ),
    );

    return CpfSeguroDevInfo(
      component: 'CpfSeguroToggleSwitch',
      props: {'value': '${widget.value}', 'size': widget.size.name, if (widget.disabled) 'disabled': 'true'},
      tokens: const ['track on primary-04 / off neutral-08 · thumb white · radius pill'],
      child: Semantics(
      label: widget.semanticLabel,
      toggled: widget.value,
      enabled: !disabled,
      button: true,
      child: MouseRegion(
        cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (f) => setState(() => _focus = f),
          child: GestureDetector(
            onTap: disabled ? null : () => widget.onChanged!(!widget.value),
            child: core,
          ),
        ),
      ),
    ),
    );
  }

  Color _trackColor(CpfSeguroScheme s) {
    if (widget.disabled) return CpfSeguroColors.neutral09;
    if (widget.value) return _hover ? CpfSeguroColors.primary03 : s.primary;
    return _hover ? CpfSeguroColors.neutral07 : s.surfaceMuted;
  }
}

class _Sizing {
  const _Sizing({required this.width, required this.height, required this.thumb});
  final double width;
  final double height;
  final double thumb;
}

_Sizing _sizing(CpfSeguroToggleSize size) => switch (size) {
      CpfSeguroToggleSize.sm => const _Sizing(width: 36, height: 20, thumb: 16),
      CpfSeguroToggleSize.md => const _Sizing(width: 44, height: 24, thumb: 20),
    };
