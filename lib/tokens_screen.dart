import 'package:flutter/material.dart';
import 'design_system/cpf_seguro_design_system.dart';

/// Showcase do **Scheme semântico** (tier 3) — Light e Dark lado a lado.
///
/// Não é mais uma tela/aba: é uma peça reusada na seção TOKENS do Preview.
/// Cada painel é um preview vivo (bg/surface/primary/status) + o grid de
/// papéis. É o que os widgets consomem via `CpfSeguroTheme.of(context)`.
class CpfSchemeShowcase extends StatelessWidget {
  const CpfSchemeShowcase({super.key});

  // O que cada ROLE significa — a semântica que os widgets consomem. Derivado
  // do uso: onde cada papel aparece de fato nas telas/componentes.
  static const _roleDict = <(String, String)>[
    ('bg', 'Fundo geral da tela (scaffold).'),
    ('bgMenu', 'Fundo de área de menu / lista lateral.'),
    ('fg', 'Texto e ícone de maior contraste sobre o bg.'),
    ('surface', 'Fundo de card e sheet — elevado sobre o bg.'),
    ('onSurface', 'Conteúdo de maior contraste sobre a surface.'),
    ('surfaceMuted', 'Wash sutil — chip neutro, campo, hover de botão secundário.'),
    ('textSecondary', 'Texto de apoio — subtítulo, descrição.'),
    ('textTertiary', 'Texto terciário — label de botão secundário, ícone neutro, placeholder.'),
    ('border', 'Borda de campo e card.'),
    ('primary', 'A marca em ação — botão primary, foco, seleção.'),
    ('onPrimary', 'Conteúdo sobre primary (texto branco do botão).'),
    ('primarySubtle', 'Fundo suave da marca — spot/badge azul claro, hover de outline.'),
    ('success', 'Base do status verificado / confirmado.'),
    ('warning', 'Base do status pendente / atenção.'),
    ('error', 'Base do erro / destrutivo.'),
    ('secure', 'Base do modo segurança / CPF pausado (o dourado).'),
  ];

  @override
  Widget build(BuildContext context) {
    final light = CpfSeguroScheme.light(CpfSeguroPalette.cpf);
    final dark = CpfSeguroScheme.dark(CpfSeguroPalette.cpf);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _SchemePanel(scheme: light, label: 'Light')),
            const SizedBox(width: 24),
            Expanded(child: _SchemePanel(scheme: dark, label: 'Dark')),
          ],
        ),
        const SizedBox(height: 24),
        Text('DICIONÁRIO DE PAPÉIS · o que cada role significa',
            style: CpfSeguroType.labelSm.copyWith(
                color: CpfSeguroColors.neutral04, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        for (final r in _roleDict)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(r.$1,
                      style: CpfSeguroType.labelSm.copyWith(
                          color: CpfSeguroColors.neutral02,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(r.$2,
                      style: CpfSeguroType.bodySm
                          .copyWith(color: CpfSeguroColors.neutral03, height: 1.4)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SchemePanel extends StatelessWidget {
  const _SchemePanel({required this.scheme, required this.label});
  final CpfSeguroScheme scheme;
  final String label;

  @override
  Widget build(BuildContext context) {
    final onBg = scheme.fg;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: scheme.bg,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: onBg)),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: scheme.isDark ? scheme.primary : scheme.fg,
                      shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Título na surface',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface)),
                  const SizedBox(height: 4),
                  Text('Texto secundário de apoio',
                      style: TextStyle(fontSize: 13, color: scheme.textSecondary)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _MiniBtn(bg: scheme.primary, fg: scheme.onPrimary, label: 'Primary'),
                      const SizedBox(width: 8),
                      _MiniBtn(bg: scheme.primarySubtle, fg: scheme.onPrimarySubtle, label: 'Subtle'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Dot(scheme.success),
                      _Dot(scheme.warning),
                      _Dot(scheme.error),
                      _Dot(scheme.secure),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in _roles(scheme)) _RoleChip(name: r.$1, color: r.$2, onBg: onBg),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<(String, Color)> _roles(CpfSeguroScheme s) => [
        ('bg', s.bg),
        ('bgMenu', s.bgMenu),
        ('fg', s.fg),
        ('surface', s.surface),
        ('onSurface', s.onSurface),
        ('surfaceMuted', s.surfaceMuted),
        ('textSecondary', s.textSecondary),
        ('textTertiary', s.textTertiary),
        ('border', s.border),
        ('primary', s.primary),
        ('onPrimary', s.onPrimary),
        ('primarySubtle', s.primarySubtle),
        ('success', s.success),
        ('warning', s.warning),
        ('error', s.error),
        ('secure', s.secure),
      ];
}

class _MiniBtn extends StatelessWidget {
  const _MiniBtn({required this.bg, required this.fg, required this.label});
  final Color bg, fg;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(200)),
      child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 8),
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.name, required this.color, required this.onBg});
  final String name;
  final Color color;
  final Color onBg;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: onBg.withValues(alpha: 0.2)),
          ),
        ),
        const SizedBox(width: 6),
        Text(name, style: TextStyle(fontSize: 11, color: onBg.withValues(alpha: 0.75))),
      ],
    );
  }
}
