import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_criteria_list.dart';
import 'cpf_seguro_chat_tokens.dart';

/// CPF SEGURO — ChatCriteriaBubble.
///
/// Bubble wide (90%) do bot com uma [CpfSeguroCriteriaList] (regras de senha,
/// validações). A lista de critérios foi extraída pro átomo standalone
/// [CpfSeguroCriteriaList] — este bubble só dá a casca de chat.
class CpfSeguroChatCriteriaBubble extends StatelessWidget {
  const CpfSeguroChatCriteriaBubble({
    super.key,
    required this.items,
    this.title,
  });

  final List<CpfSeguroCriteriaItem> items;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: s.surfaceMuted,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(CpfSeguroChatTokens.radius),
                  topRight: Radius.circular(CpfSeguroChatTokens.radius),
                  bottomRight: Radius.circular(CpfSeguroChatTokens.radius),
                  bottomLeft: Radius.circular(CpfSeguroChatTokens.anchor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CpfSeguroChatTokens.px,
                  vertical: CpfSeguroChatTokens.py,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(title!,
                          style: CpfSeguroType.chatBody
                              .copyWith(color: s.textSecondary)),
                      const SizedBox(height: 12),
                    ],
                    CpfSeguroCriteriaList(items: items),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
