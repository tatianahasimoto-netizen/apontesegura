import 'package:flutter/widgets.dart';
import 'generated/cps_gradient_tokens.g.dart';

/// CPF SEGURO — Gradients (degrades).
///
/// Todo degrade do DS mora aqui. Paridade 1:1 com o React
/// (~/Desktop/cpf-seguro-app/src/styles/theme.css: `--banner-gradient`,
/// `--screen-bg`, `--card-pv-bg`).
///
/// Convenção: sempre `LinearGradient` const, com stops explícitos.
/// Uso: `BoxDecoration(gradient: CpfSeguroGradients.screenBg)`.
class CpfSeguroGradients {
  CpfSeguroGradients._();

  // ─── Brand (azul escuro → azul claro) ─────────────────────────────────────

  /// Degrade principal do brand — banner "PARA VOCÊ", ChatCompletionCard.
  /// Escuro (primary-03, topo-esq) → claro (primary-05, baixo-dir).
  /// Escala escuro → claro na leitura visual, começa profundo e "abre" pro
  /// azul mais luminoso.
  // Inversão L3: os gradients consomem o gerado (CpfSeguroGradientConsts, de
  // tokens/gradient.tokens.json — cores por ref aos primitivos).
  static const LinearGradient brandLift = CpfSeguroGradientConsts.brandLift;

  /// Degrade sutil de screen bg — branco (topo) → primary-08 (rodapé).
  /// Usado em telas full-screen (Journey, Welcome, ErrorFatal) pra dar
  /// respiração visual sem competir com cards. Padrão React `--screen-bg`.
  static const LinearGradient screenBg = CpfSeguroGradientConsts.screenBg;

  /// Degrade quase invisível de card — branco (topo-esq) → primary-09 (baixo-dir).
  /// Usado nos cards "Para Você" da home. 113.207° ≈ topo-esq pro baixo-dir.
  /// Padrão React `--card-pv-bg`.
  static const LinearGradient cardPv = CpfSeguroGradientConsts.cardPv;
}
