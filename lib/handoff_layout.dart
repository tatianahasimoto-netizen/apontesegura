import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';

/// Descriptor de uma tela do handoff.
class HandoffScreen {
  const HandoffScreen({required this.label, required this.child, this.caption});
  final String label;
  final String? caption;
  final Widget child;
}

/// Grupo de telas relacionadas (ex: "Migração", "Home", "Modo Segurança").
class HandoffGroup {
  const HandoffGroup({required this.title, required this.subtitle, required this.screens});
  final String title;
  final String subtitle;
  final List<HandoffScreen> screens;
}

/// Layout compartilhado entre as abas SDK e Standalone.
/// Sidebar esquerda (280px) lista grupos + telas clicáveis; área direita
/// mostra APENAS a tela selecionada (PhoneShell 393×852 centrado).
class HandoffLayout extends StatefulWidget {
  const HandoffLayout({
    super.key,
    required this.title,
    required this.description,
    required this.groups,
  });

  final String title;
  final String description;
  final List<HandoffGroup> groups;

  @override
  State<HandoffLayout> createState() => _HandoffLayoutState();
}

class _HandoffLayoutState extends State<HandoffLayout> {
  int _groupIdx = 0;
  int _screenIdx = 0;

  /// Grupos colapsados (por índice). Começam todos abertos.
  final Set<int> _collapsed = {};

  /// Dev mode (estilo Figma inspect): hover nos componentes do DS mostra
  /// component + props + tokens de cor/typo/icon.
  bool _devMode = false;

  /// Modo de cor da tela (Light/Dark). Provido via CpfSeguroThemeScope pros
  /// widgets já migrados pro scheme.
  Brightness _brightness = Brightness.light;

  HandoffScreen get _selected => widget.groups[_groupIdx].screens[_screenIdx];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Sidebar(
          title: widget.title,
          description: widget.description,
          groups: widget.groups,
          selectedGroup: _groupIdx,
          selectedScreen: _screenIdx,
          collapsed: _collapsed,
          onToggleGroup: (g) => setState(() {
            if (!_collapsed.remove(g)) _collapsed.add(g);
          }),
          onSelect: (g, s) => setState(() {
            _groupIdx = g;
            _screenIdx = s;
          }),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        widget.groups[_groupIdx].title,
                        style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.primary04, letterSpacing: 1.4),
                      ),
                    ),
                    // Toggle Light/Dark — provido via CpfSeguroThemeScope.
                    _PillToggle(
                      label: _brightness == Brightness.dark ? '☾ Dark' : '☀ Light',
                      active: _brightness == Brightness.dark,
                      onTap: () => setState(() => _brightness =
                          _brightness == Brightness.dark ? Brightness.light : Brightness.dark),
                    ),
                    const SizedBox(width: 8),
                    // Toggle do dev mode — hover inspeciona os componentes.
                    _PillToggle(
                      label: '</> Dev',
                      active: _devMode,
                      onTap: () => setState(() => _devMode = !_devMode),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(_selected.label, style: CpfSeguroType.headlineSm.copyWith(color: CpfSeguroColors.neutral01)),
                  if (_selected.caption != null) ...[
                    const SizedBox(height: 4),
                    Text(_selected.caption!, style: CpfSeguroType.bodyMd.copyWith(color: CpfSeguroColors.neutral04)),
                  ],
                  const SizedBox(height: 32),
                  CpfSeguroThemeScope(
                    theme: CpfSeguroTheme.resolve(brightness: _brightness),
                    child: CpfSeguroDevMode(enabled: _devMode, child: _selected.child),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.title,
    required this.description,
    required this.groups,
    required this.selectedGroup,
    required this.selectedScreen,
    required this.collapsed,
    required this.onToggleGroup,
    required this.onSelect,
  });

  final String title;
  final String description;
  final List<HandoffGroup> groups;
  final int selectedGroup;
  final int selectedScreen;
  final Set<int> collapsed;
  final void Function(int g) onToggleGroup;
  final void Function(int g, int s) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 800),
      decoration: const BoxDecoration(
        color: CpfSeguroColors.white,
        border: Border(right: BorderSide(color: CpfSeguroColors.neutral09, width: 1)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CpfSeguroType.titleLg.copyWith(color: CpfSeguroColors.neutral01)),
                  const SizedBox(height: 4),
                  Text(description, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (var gi = 0; gi < groups.length; gi++) ...[
              _GroupHeader(
                title: groups[gi].title,
                subtitle: groups[gi].subtitle,
                count: groups[gi].screens.length,
                // O grupo do selecionado fica sempre aberto.
                expanded: !collapsed.contains(gi) || gi == selectedGroup,
                onTap: () => onToggleGroup(gi),
              ),
              if (!collapsed.contains(gi) || gi == selectedGroup)
                for (var si = 0; si < groups[gi].screens.length; si++)
                  _ScreenItem(
                    label: groups[gi].screens[si].label,
                    selected: gi == selectedGroup && si == selectedScreen,
                    onTap: () => onSelect(gi, si),
                  ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.expanded,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final int count;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chevron gira 90° quando aberto (aponta pra baixo).
              Padding(
                padding: const EdgeInsets.only(top: 1, right: 6),
                child: Transform.rotate(
                  angle: expanded ? 1.5708 : 0,
                  child: const CpfSeguroIcon(
                    name: CpfSeguroIcons.angleRightLight,
                    size: 12,
                    color: CpfSeguroColors.neutral05,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral04),
                        ),
                      ),
                      Text('$count', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral06)),
                    ]),
                    const SizedBox(height: 2),
                    Text(subtitle, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral05)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenItem extends StatefulWidget {
  const _ScreenItem({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ScreenItem> createState() => _ScreenItemState();
}

class _ScreenItemState extends State<_ScreenItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.selected
        ? CpfSeguroColors.primaryStateSelected
        : _hover
            ? CpfSeguroColors.primaryStateHover
            : CpfSeguroColors.transparent;
    final color = widget.selected
        ? CpfSeguroColors.primary04
        : _hover
            ? CpfSeguroColors.neutral02
            : CpfSeguroColors.neutral03;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.all8),
          child: Text(
            widget.label,
            style: CpfSeguroType.labelMd.copyWith(
              color: color,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill toggle do topo do handoff (Light/Dark, Dev). Ativo = neutral-01 sólido.
class _PillToggle extends StatelessWidget {
  const _PillToggle({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: active ? CpfSeguroColors.neutral01 : CpfSeguroColors.transparent,
            borderRadius: CpfSeguroRadius.pillAll,
            border: Border.all(
              color: active ? CpfSeguroColors.neutral01 : CpfSeguroColors.neutral07,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: CpfSeguroType.labelSm.copyWith(
              color: active ? CpfSeguroColors.white : CpfSeguroColors.neutral03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Moldura de device 393×852 compartilhada pelas telas de handoff (SDK e
/// Standalone). NÃO é widget do DS — é infra de preview: frame arredondado
/// + sombra, com slots fixos por cima do conteúdo:
///
/// - [topSlot] → Positioned no topo (TopAppBar). Sem topSlot, renderiza
///   StatusBar em glass (a menos que [hideStatusBar]).
/// - [bottomSlot] → Positioned no rodapé (BottomApp/HomeIndicator).
///
/// O conteúdo passa POR BAIXO dos slots — o scroll da tela precisa
/// compensar com padding (top ~100-108, bottom ~140-180 conforme o slot).
class HandoffPhoneShell extends StatelessWidget {
  const HandoffPhoneShell({
    super.key,
    required this.child,
    this.topSlot,
    this.bottomSlot,
    this.overlay,
    this.hideStatusBar = false,
    this.bg = CpfSeguroColors.white,
    this.bgGradient,
  });

  final Widget child;
  final Widget? topSlot;
  final Widget? bottomSlot;

  /// Camada pintada POR CIMA de tudo (inclusive top/bottom slots) — sheets
  /// e overlays com scrim que precisam escurecer a tela inteira. O filho já
  /// deve ser Positioned/Positioned.fill (vira filho direto do Stack).
  final Widget? overlay;
  final bool hideStatusBar;
  final Color bg;
  final Gradient? bgGradient;

  @override
  Widget build(BuildContext context) {
    // No dark, o bg da tela vira scheme.bg (as telas passam bg/gradient de
    // light; sobrescrever só no dark preserva o light exato). Sem gradient
    // no dark — cor sólida.
    final s = CpfSeguroTheme.schemeOf(context);
    final effBg = s.isDark ? s.bg : bg;
    final effGrad = s.isDark ? null : bgGradient;
    return Container(
      width: 393,
      height: 852,
      decoration: BoxDecoration(
        color: effGrad == null ? effBg : null,
        gradient: effGrad,
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
        boxShadow: const [
          BoxShadow(color: CpfSeguroColors.blackAlpha20, offset: Offset(0, 20), blurRadius: 40),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(43),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            if (topSlot != null)
              Positioned(top: 0, left: 0, right: 0, child: topSlot!)
            else if (!hideStatusBar)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CpfSeguroGlassSurface(child: CpfSeguroStatusBar()),
              ),
            if (bottomSlot != null)
              Positioned(left: 0, right: 0, bottom: 0, child: bottomSlot!),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }
}
