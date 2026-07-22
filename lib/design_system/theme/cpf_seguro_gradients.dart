import 'package:flutter/widgets.dart';
import 'generated/cps_gradient_tokens.g.dart';

/// CPF SEGURO — Gradients (degrades).
///
/// Todo degrade do DS mora aqui. Paridade 1:1 com o React
/// (~/Desktop/cpf-seguro-app/src/styles/theme.css: `--banner-gradient`).
///
/// Convenção: sempre `LinearGradient` const, com stops explícitos.
/// Uso: `BoxDecoration(gradient: CpfSeguroGradients.brandLift)`.
class CpfSeguroGradients {
  CpfSeguroGradients._();

  // ─── Brand (azul escuro → azul claro) ─────────────────────────────────────

  /// Degrade principal do brand — banner "PARA VOCÊ".
  /// Escuro (primary-03, topo-esq) → claro (primary-05, baixo-dir).
  /// Escala escuro → claro na leitura visual, começa profundo e "abre" pro
  /// azul mais luminoso.
  // Inversão L3: os gradients consomem o gerado (CpfSeguroGradientConsts, de
  // tokens/gradient.tokens.json — cores por ref aos primitivos).
  static const LinearGradient brandLift = CpfSeguroGradientConsts.brandLift;
}
