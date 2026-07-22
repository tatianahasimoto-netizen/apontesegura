import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// Tom semântico da StatusTag.
enum CpfSeguroStatusTone { warning, neutral, primary, success, danger }

/// Data holder pra passar uma StatusTag como prop (ex.: slot right do AppList).
class CpfSeguroStatusTagData {
  const CpfSeguroStatusTagData({required this.label, required this.tone, this.icon});
  final String label;
  final CpfSeguroStatusTone tone;
  final String? icon;
}

/// CPF SEGURO — StatusTag.
///
/// Pill 20px de altura com border 0.5px, opcional icon accessory 12px à
/// esquerda + label label-sm. 6 tones (bg + border + text por semântica).
///
/// ```dart
/// CpfSeguroStatusTag(label: 'Pendente', tone: CpfSeguroStatusTone.warning),
/// CpfSeguroStatusTag(label: 'CPF Seguro', tone: CpfSeguroStatusTone.primary, icon: CpfSeguroIcons.shieldUserSolidFull),
/// ```
class CpfSeguroStatusTag extends StatelessWidget {
  const CpfSeguroStatusTag({
    super.key,
    required this.label,
    this.tone = CpfSeguroStatusTone.neutral,
    this.icon,
  });

  final String label;
  final CpfSeguroStatusTone tone;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final t = _toneSpec(tone, CpfSeguroTheme.schemeOf(context));
    return CpfSeguroDevInfo(
      component: 'CpfSeguroStatusTag',
      props: {
        'label': "'$label'",
        'tone': tone.name,
        if (icon != null) 'icon': icon!,
      },
      tokens: [
        'bg: ${cpfSeguroColorToken(t.bg)}',
        'text: ${cpfSeguroColorToken(t.color)} · labelSm 11/500',
        'h 20 · radius pill · border 0.5',
      ],
      child: Container(
      height: 20,
      // Tag: 4 esq · 8 dir, align left. Icon accessory 12 (glyph 8 pelo
      // padding 2 do accessory), spacing 4 pro label.
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s1, right: CpfSeguroSpacing.s2),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border.all(color: t.border, width: 0.5),
        borderRadius: CpfSeguroRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            CpfSeguroIconAccessory(icon: icon!, size: 12, color: t.color),
          // Gap SEMPRE presente: sem ícone o label fica com 4(pad)+4=8 à
          // esquerda, batendo com os 8 da direita → balanceado. O "4 fica".
          const SizedBox(width: CpfSeguroSpacing.s1),
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: CpfSeguroType.labelSm.copyWith(color: t.color),
          ),
        ],
      ),
    ),
    );
  }
}

class _ToneSpec {
  const _ToneSpec({required this.bg, required this.border, required this.color});
  final Color bg;
  final Color border;
  final Color color;
}

_ToneSpec _toneSpec(CpfSeguroStatusTone t, CpfSeguroScheme s) {
  // Dark: o chip vira tint translúcido do próprio tom + texto/borda claros
  // (o tint sólido claro do light estouraria sobre a surface escura). A cor
  // "base" carrega a semântica; a expressão muda com o contexto — é o TOM.
  if (s.isDark) {
    final Color base = switch (t) {
      CpfSeguroStatusTone.warning => s.warning,
      CpfSeguroStatusTone.neutral => s.textSecondary,
      // primary05 (s.primary no dark) é azul médio — como TEXTO sobre o tint
      // escuro fica ilegível. Clareia pra primary06.
      CpfSeguroStatusTone.primary => CpfSeguroColors.primary06,
      CpfSeguroStatusTone.success => s.success,
      CpfSeguroStatusTone.danger => s.error,
    };
    return _ToneSpec(
      bg: base.withValues(alpha: 0.16),
      border: base.withValues(alpha: 0.45),
      color: base,
    );
  }
  // Light: specs originais (tint *07/*08 sólido), 1:1 com o legado.
  return switch (t) {
    CpfSeguroStatusTone.warning => const _ToneSpec(bg: CpfSeguroColors.warning07, border: CpfSeguroColors.warning04, color: CpfSeguroColors.warning04),
    CpfSeguroStatusTone.neutral => const _ToneSpec(bg: CpfSeguroColors.white, border: CpfSeguroColors.neutral05, color: CpfSeguroColors.neutral05),
    CpfSeguroStatusTone.primary => const _ToneSpec(bg: CpfSeguroColors.primary08, border: CpfSeguroColors.primary04, color: CpfSeguroColors.primary04),
    CpfSeguroStatusTone.success => const _ToneSpec(bg: CpfSeguroColors.success07, border: CpfSeguroColors.success04, color: CpfSeguroColors.success04),
    CpfSeguroStatusTone.danger => const _ToneSpec(bg: CpfSeguroColors.error07, border: CpfSeguroColors.error04, color: CpfSeguroColors.error04),
  };
}
