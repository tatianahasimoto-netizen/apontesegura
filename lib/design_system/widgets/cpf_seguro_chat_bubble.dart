import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_chat_tokens.dart';

/// Lado da fala.
enum CpfSeguroChatFrom { bot, user }

/// Tom da bolha do bot. `neutral` = cinza padrão; `alert` = aviso (warning) pra
/// mensagens de erro/atenção do bot.
enum CpfSeguroChatBubbleTone { neutral, alert }

/// CPF SEGURO — ChatBubble.
///
/// - Bot: cinza neutral-09, anchored bottom-left (canto 4 chato).
/// - User: azul primary-04, anchored bottom-right.
/// Max width 85% (ou 90% com [wide=true]). [tone]=alert pinta o bot de warning.
class CpfSeguroChatBubble extends StatelessWidget {
  const CpfSeguroChatBubble({
    super.key,
    required this.from,
    required this.child,
    this.editable = false,
    this.onEdit,
    this.wide = false,
    this.tone = CpfSeguroChatBubbleTone.neutral,
  });

  final CpfSeguroChatFrom from;
  final Widget child;

  /// Mostra link "Alterar" abaixo (só quando [from]=user).
  final bool editable;
  final VoidCallback? onEdit;

  final bool wide;

  /// Tom do bot (neutral/alert). Ignorado quando [from]=user.
  final CpfSeguroChatBubbleTone tone;

  BorderRadius _radius() {
    const r = CpfSeguroChatTokens.radius;
    const a = CpfSeguroChatTokens.anchor;
    return from == CpfSeguroChatFrom.bot
        ? const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomRight: Radius.circular(r),
            bottomLeft: Radius.circular(a),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomRight: Radius.circular(a),
            bottomLeft: Radius.circular(r),
          );
  }

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final isBot = from == CpfSeguroChatFrom.bot;
    final alert = isBot && tone == CpfSeguroChatBubbleTone.alert;
    final bubbleColor = alert
        ? CpfSeguroColors.warning07
        : (isBot ? s.surfaceMuted : s.primary);
    final textColor = alert
        ? CpfSeguroColors.warning02
        : (isBot ? s.textSecondary : CpfSeguroColors.white);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Figma 6:4343: bubble hug-content, wmax 270 (bot E user). `wide=true`
        // solta o teto (CriteriaBubble multi-item). Clampa se a tela for < 270.
        final maxW = wide
            ? constraints.maxWidth
            : (constraints.maxWidth < CpfSeguroChatTokens.maxWidth
                ? constraints.maxWidth
                : CpfSeguroChatTokens.maxWidth);
        return Align(
          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Column(
            crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: _radius(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CpfSeguroChatTokens.px,
                      vertical: CpfSeguroChatTokens.py,
                    ),
                    child: DefaultTextStyle(
                      style: CpfSeguroType.chatBody.copyWith(color: textColor),
                      child: child,
                    ),
                  ),
                ),
              ),
              if (editable && from == CpfSeguroChatFrom.user) ...[
                const SizedBox(height: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Text(
                      'Alterar',
                      style: CpfSeguroType.label.copyWith(
                        color: s.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
