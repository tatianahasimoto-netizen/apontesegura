import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// Estado de cada critério.
///
/// - **pending** — ainda não avaliado (marker vazio).
/// - **ok** — atendido (check verde).
/// - **fail** — reprovado (x vermelho).
enum CpfSeguroCriteriaStatus { pending, ok, fail }

/// Item da lista de critérios (regra + estado).
class CpfSeguroCriteriaItem {
  const CpfSeguroCriteriaItem(
      {required this.label, this.status = CpfSeguroCriteriaStatus.pending});
  final String label;
  final CpfSeguroCriteriaStatus status;
}

/// CPF SEGURO — CriteriaList.
///
/// Lista de critérios/validações com marker de estado à esquerda (requisitos de
/// senha, checagens de formulário). Vocabulário standalone — consumido pela
/// [CpfSeguroChatCriteriaBubble], pelo PasswordBottomSheet e por requisitos de
/// senha no app. O marker e o tom saem de tokens (success/error/placeholder).
///
/// ```dart
/// CpfSeguroCriteriaList(items: [
///   CpfSeguroCriteriaItem(label: 'Mínimo 8 caracteres', status: CpfSeguroCriteriaStatus.ok),
///   CpfSeguroCriteriaItem(label: 'Uma letra maiúscula'),
/// ])
/// ```
class CpfSeguroCriteriaList extends StatelessWidget {
  const CpfSeguroCriteriaList({super.key, required this.items, this.gap = 8});

  final List<CpfSeguroCriteriaItem> items;

  /// Espaço vertical entre itens.
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          CpfSeguroCriteriaRow(item: items[i]),
        ],
      ],
    );
  }
}

/// Uma linha de critério (marker + label). Público pra compor fora da lista.
class CpfSeguroCriteriaRow extends StatelessWidget {
  const CpfSeguroCriteriaRow({super.key, required this.item});
  final CpfSeguroCriteriaItem item;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final labelColor = item.status == CpfSeguroCriteriaStatus.ok
        ? CpfSeguroColors.success04
        : s.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CriteriaMarker(status: item.status),
        const SizedBox(width: 8),
        Flexible(
          child: Text(item.label,
              style: CpfSeguroType.chatBody.copyWith(color: labelColor)),
        ),
      ],
    );
  }
}

class _CriteriaMarker extends StatelessWidget {
  const _CriteriaMarker({required this.status});
  final CpfSeguroCriteriaStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == CpfSeguroCriteriaStatus.ok) {
      return const CpfSeguroIconAccessory(
          icon: CpfSeguroIcons.circleCheckSolid,
          padding: 0,
          size: 16,
          color: CpfSeguroColors.success04);
    }
    if (status == CpfSeguroCriteriaStatus.fail) {
      return const CpfSeguroIconAccessory(
          icon: CpfSeguroIcons.xmarkSolid,
          padding: 0,
          size: 16,
          color: CpfSeguroColors.error04);
    }
    final s = CpfSeguroTheme.schemeOf(context);
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: s.textPlaceholder, width: 1.5),
      ),
    );
  }
}
