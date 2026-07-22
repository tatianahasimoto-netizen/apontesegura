import 'package:flutter/material.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — PageTitle.
///
/// Cabeçalho padrão de screen: h1 22/32 + subtítulo 14/20 opcional.
/// Reutilizado abaixo do TopAppBar em screens de configuração/formulário.
/// NÃO usar em heros (Welcome, StatusScreen) — esses são maiores.
///
/// ```dart
/// CpfSeguroPageTitle(title: 'Nome', subtitle: 'Atualize seu nome completo.'),
/// CpfSeguroPageTitle(title: 'Alterar senha'),
/// ```
class CpfSeguroPageTitle extends StatelessWidget {
  const CpfSeguroPageTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroPageTitle',
      props: {'title': "'\$title'", if (subtitle != null) 'subtitle': "'\$subtitle'"},
      tokens: const ['title: title 22/600 fg · subtitle: bodyMd 14/400 textTertiary'],
      child: Padding(
      padding: const EdgeInsets.only(bottom: CpfSeguroSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: CpfSeguroType.title.copyWith(color: s.fg)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary)),
          ],
        ],
      ),
    ),
    );
  }
}
