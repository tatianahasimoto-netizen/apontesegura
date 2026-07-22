import 'package:flutter/widgets.dart';
import 'cpf_seguro_chat_tokens.dart';

/// CPF SEGURO — ChatScroll.
///
/// Coluna de bubbles com gap padrão do chat entre itens sequenciais.
class CpfSeguroChatScroll extends StatelessWidget {
  const CpfSeguroChatScroll({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: CpfSeguroChatTokens.gap),
          children[i],
        ],
      ],
    );
  }
}
