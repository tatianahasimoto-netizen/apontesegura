import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show TextInputAction, TextInputType;
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_field.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — SearchInput.
///
/// Input com lupa: **[CpfSeguroField]** (átomo de texto) + lupa. h 48, bg
/// surface, border neutral-08, radius 16. Padding 12 esq + 8 dir + gap 4.
///
/// [controller] e [focusNode] são opcionais — quando null, este componente cria
/// e gerencia os internos, passando-os ao [CpfSeguroField].
class CpfSeguroSearchInput extends StatefulWidget {
  const CpfSeguroSearchInput({
    super.key,
    this.controller,
    this.placeholder = 'Pesquisar',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<CpfSeguroSearchInput> createState() => _CpsSearchInputState();
}

class _CpsSearchInputState extends State<CpfSeguroSearchInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocus = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _ownsFocus = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocus) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroSearchInput',
      props: {'placeholder': "'${widget.placeholder}'"},
      tokens: const [
        'h48 · radius 16 · icon magnifying-glass-light textPlaceholder'
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(
              left: CpfSeguroSpacing.s3, right: CpfSeguroSpacing.s2),
          decoration: BoxDecoration(
            color: s.surface,
            border: Border.all(color: s.border, width: 1),
            borderRadius: CpfSeguroRadius.all16,
          ),
          child: Row(
            children: [
              CpfSeguroIconAccessory(
                  icon: CpfSeguroIcons.magnifyingGlassLight,
                  padding: 0,
                  size: 18,
                  color: s.textPlaceholder),
              const SizedBox(width: 4),
              Expanded(
                child: CpfSeguroField(
                  controller: _controller,
                  focusNode: _focusNode,
                  placeholder: widget.placeholder,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
