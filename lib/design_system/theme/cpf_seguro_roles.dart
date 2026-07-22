import 'dart:math' as math;
import 'package:flutter/painting.dart' show Color;
import 'cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_scheme.dart';

/// CPF SEGURO — Roles (camada semântica / o "significado").
///
/// Um role não é uma cor: é um pacote de intenção (cor + on-color + subtle +
/// ícone default), resolvido a partir do [CpfSeguroScheme]. É o dicionário da
/// linguagem — "vermelho = erro" mora aqui. Componentes devem consumir role,
/// nunca cor crua. Ver spec `openspec/specs/design-system-semantic-roles` e
/// `DS_LANGUAGE.md` §1.
///
/// Aditivo: reusa os campos que o Scheme já expõe (primary/success/warning/
/// error + on/subtle). Não recria tokens.
enum CpfSeguroRole { primary, neutral, success, warning, danger }

/// Pacote resolvido de um role.
class CpfSeguroRoleStyle {
  const CpfSeguroRoleStyle({
    required this.color,
    required this.onColor,
    required this.subtle,
    this.icon,
  });

  /// Cor sólida do role (fill / acento).
  final Color color;

  /// Conteúdo (texto/ícone) sobre [color]. Nunca escolher manualmente.
  final Color onColor;

  /// Tinte suave pra fundos sutis.
  final Color subtle;

  /// Ícone default do role (token string de [CpfSeguroIcons]). Null = sem ícone
  /// canônico (ex: primary).
  final String? icon;
}

/// Resolve roles a partir do scheme corrente.
abstract final class CpfSeguroRoles {
  /// Todos os roles, na ordem canônica de exibição.
  static const List<CpfSeguroRole> all = CpfSeguroRole.values;

  static CpfSeguroRoleStyle of(CpfSeguroScheme s, CpfSeguroRole role) {
    final (Color color, Color subtle, String? icon) = switch (role) {
      CpfSeguroRole.primary => (s.primary, s.primarySubtle, null),
      CpfSeguroRole.neutral => (s.textSecondary, s.surfaceMuted, CpfSeguroIcons.circleInfoLight),
      CpfSeguroRole.success => (s.success, s.successSubtle, CpfSeguroIcons.circleCheckLight),
      CpfSeguroRole.warning => (s.warning, s.warningSubtle, CpfSeguroIcons.triangleExclamationLight),
      CpfSeguroRole.danger => (s.error, s.errorSubtle, CpfSeguroIcons.triangleExclamationLight),
    };
    // On-color é propriedade do role: escolhe branco vs ink pelo maior contraste
    // sobre o fill. Garante legibilidade mesmo em roles amarelos (warning),
    // onde os on* do scheme não garantem AA sobre o sólido.
    return CpfSeguroRoleStyle(
      color: color,
      onColor: _bestOn(color),
      subtle: subtle,
      icon: icon,
    );
  }

  static Color _bestOn(Color bg) {
    const white = Color(0xFFFFFFFF);
    const ink = Color(0xFF3D3939); // neutral-01
    return cpfSeguroContrastRatio(bg, white) >= cpfSeguroContrastRatio(bg, ink)
        ? white
        : ink;
  }

  /// Nome legível do role.
  static String label(CpfSeguroRole role) => role.name;
}

// ═══════════════════════════════════════════════════════════════════════════
// Contraste (WCAG 2.x) — usado pelo catálogo e pelo teste de gate (V4)
// ═══════════════════════════════════════════════════════════════════════════

/// Razão de contraste WCAG entre duas cores (1.0 a 21.0).
double cpfSeguroContrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Alvos WCAG AA. `normal` = texto normal (4.5:1). `large` = texto grande /
/// componentes de UI / ícones (3:1).
const double cpfSeguroContrastAANormal = 4.5;
const double cpfSeguroContrastAALarge = 3.0;

double _luminance(Color c) {
  double chan(int v) {
    final s = v / 255.0;
    return s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * chan(c.red) + 0.7152 * chan(c.green) + 0.0722 * chan(c.blue);
}
