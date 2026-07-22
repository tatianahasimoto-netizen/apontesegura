import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory, CpfSeguroBadge;
import '../theme/cpf_seguro_icon_tokens.dart';

/// Aba do BottomNav.
enum CpfSeguroNavTab { home, souEu, carteira, cpfSeguro }

/// Item configurável do BottomNav (construtor [CpfSeguroNav.items]). Permite
/// ao consumidor definir as tabs (quantidade/ícone/label/badge) em vez do enum
/// fixo — ex.: o app tem 3 tabs dinâmicas com feature-gating.
class CpfSeguroNavItem {
  const CpfSeguroNavItem({
    required this.icon,
    required this.label,
    this.badge = CpfSeguroBadge.none,
  });

  final String icon;
  final String label;
  final CpfSeguroBadge badge;
}

/// CPF SEGURO — BottomNav.
///
/// Barra de navegação inferior com 4 tabs. Spec: altura visual 110 (min),
/// glass padrão do app + stroke white 1px + shadow Elevation.medium. O
/// círculo do item ativo (primary-04, shadow Elevation.brandSoft) ESTOURA
/// a borda superior da barra; o label fica a 8px do círculo. Item CPF SEGURO
/// aceita [pauseActive=true] pra mostrar dot vermelho.
///
/// ```dart
/// CpfSeguroBottomNav(activeTab: CpfSeguroNavTab.home, onTabChanged: (t) => setTab(t)),
/// CpfSeguroBottomNav(activeTab: CpfSeguroNavTab.cpfSeguro, pauseActive: true),
/// ```
class CpfSeguroNav extends StatelessWidget {
  /// Variante enum (4 tabs fixas) — usada pelo catálogo.
  const CpfSeguroNav({
    super.key,
    required CpfSeguroNavTab this.activeTab,
    this.pauseActive = false,
    this.onTabChanged,
  })  : items = null,
        activeIndex = null,
        onIndexChanged = null;

  /// Variante CONFIGURÁVEL — o consumidor define a lista de tabs (o app tem 3
  /// dinâmicas com feature-gating). [activeIndex] = índice ativo; [items] =
  /// tabs (ícone/label/badge).
  const CpfSeguroNav.items({
    super.key,
    required List<CpfSeguroNavItem> this.items,
    required int this.activeIndex,
    this.onIndexChanged,
  })  : activeTab = null,
        pauseActive = false,
        onTabChanged = null;

  final CpfSeguroNavTab? activeTab;

  /// Dot vermelho na tab CPF SEGURO (indica pausa ativa) — só na variante enum.
  final bool pauseActive;

  final ValueChanged<CpfSeguroNavTab>? onTabChanged;

  final List<CpfSeguroNavItem>? items;
  final int? activeIndex;
  final ValueChanged<int>? onIndexChanged;

  static const List<_TabConfig> _enumTabs = [
    _TabConfig(tab: CpfSeguroNavTab.home, icon: CpfSeguroIcons.houseLight, label: 'Home'),
    _TabConfig(tab: CpfSeguroNavTab.souEu, icon: CpfSeguroIcons.fingerprintLight, label: 'Sou eu!'),
    _TabConfig(tab: CpfSeguroNavTab.carteira, icon: CpfSeguroIcons.walletLight, label: 'Carteira'),
    _TabConfig(tab: CpfSeguroNavTab.cpfSeguro, icon: CpfSeguroIcons.idCardLight, label: 'CPF SEGURO'),
  ];

  /// Headroom transparente acima da barra — o círculo ativo estoura 8px
  /// acima da borda do glass. O glass segue a receita comprovada do
  /// TopAppBar (conteúdo DENTRO do BackdropFilter — backdrop sem filho real
  /// não renderiza o blur no web); o círculo ativo é uma camada própria por
  /// cima, posicionada pelo índice da tab, fora do clip.
  static const double headroom = 16;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    // Resolve a fonte de dados: variante configurável (items) ou enum fixo.
    final List<CpfSeguroNavItem> tabs = items ??
        _enumTabs
            .map((c) => CpfSeguroNavItem(
                  icon: c.icon,
                  label: c.label,
                  badge: c.tab == CpfSeguroNavTab.cpfSeguro && pauseActive
                      ? CpfSeguroBadge.danger
                      : CpfSeguroBadge.none,
                ))
            .toList();
    final int active = items != null
        ? activeIndex!
        : _enumTabs.indexWhere((c) => c.tab == activeTab);
    final void Function(int)? onTap = items != null
        ? onIndexChanged
        : (onTabChanged == null
            ? null
            : (i) => onTabChanged!(_enumTabs[i].tab));
    return LayoutBuilder(builder: (context, constraints) {
      // Row de itens vive dentro de Padding(16) + Padding(8) → área útil.
      final itemsWidth = constraints.maxWidth - 48;
      final colWidth = itemsWidth / tabs.length;
      final circleLeft = 24 + colWidth * active + colWidth / 2 - 24;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Barra glass (spec: 110 visual · white80+blur10 · stroke white
          // 1px · shadow Elevation.medium fora do clip) com o CONTEÚDO dentro —
          // é o conteúdo que dá corpo pro BackdropFilter renderizar.
          Padding(
            padding: const EdgeInsets.only(top: headroom),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: CpfSeguroRadius.r40,
                  topRight: CpfSeguroRadius.r40,
                ),
                boxShadow: CpfSeguroElevation.medium,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: CpfSeguroRadius.r40,
                  topRight: CpfSeguroRadius.r40,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: s.glassTint,
                      border: Border.all(
                          color: s.isDark ? s.border : CpfSeguroColors.white, width: 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: CpfSeguroRadius.r40,
                        topRight: CpfSeguroRadius.r40,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0; i < tabs.length; i++)
                                  Expanded(
                                    child: _MenuItem(
                                      icon: tabs[i].icon,
                                      label: tabs[i].label,
                                      active: i == active,
                                      badge: tabs[i].badge,
                                      onTap: onTap == null
                                          ? null
                                          : () => onTap(i),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const _NavHomeIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── Círculo do item ativo — camada acima do glass, estourando a
          // borda (top 8 < headroom 16). Dropshadow primary @ 18 (spec).
          if (active >= 0)
            Positioned(
              top: 8,
              left: circleLeft,
              child: Container(
                padding: const EdgeInsets.all(CpfSeguroSpacing.s2),
                decoration: BoxDecoration(
                  color: s.primary,
                  borderRadius: CpfSeguroRadius.pillAll,
                  boxShadow: CpfSeguroElevation.brandSoft,
                ),
                child: CpfSeguroIconAccessory(
                  icon: tabs[active].icon,
                  size: 32,
                  color: s.onPrimary,
                  badge: tabs[active].badge,
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _TabConfig {
  const _TabConfig({required this.tab, required this.icon, required this.label});
  final CpfSeguroNavTab tab;
  final String icon;
  final String label;
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.badge,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool active;
  final CpfSeguroBadge badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    // Inativo clareia no dark pra não sumir sobre o glass escuro.
    final Color inactive = s.isDark ? s.textSecondary : CpfSeguroColors.neutral05;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 76,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (active)
                  // Placeholder do círculo — a bolha real é pintada pela
                  // camada de cima do Nav (fora do clip do glass), mas o
                  // espaço reservado aqui garante o label a 8px dela.
                  const SizedBox(height: 40, width: 48)
                else
                  CpfSeguroIconAccessory(
                    icon: icon,
                    size: 32,
                    color: inactive,
                    badge: badge,
                  ),
                // Label a 8px do círculo/ícone (spec) + respiro de 12 até o
                // indicator — é esse respiro que deixa o círculo estourar.
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: CpfSeguroType.caption.copyWith(
                    color: active ? s.primary : inactive,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavHomeIndicator extends StatelessWidget {
  const _NavHomeIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: CpfSeguroSpacing.s2),
          child: Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: CpfSeguroTheme.schemeOf(context).fg,
              borderRadius: CpfSeguroRadius.pillAll,
            ),
          ),
        ),
      ),
    );
  }
}
