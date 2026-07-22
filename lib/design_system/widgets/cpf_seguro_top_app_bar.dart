import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_glass_surface.dart';
import 'cpf_seguro_navigation_top_bar.dart';
import 'cpf_seguro_status_bar.dart';
import 'cpf_seguro_stepper.dart';

export 'cpf_seguro_navigation_top_bar.dart';
export 'cpf_seguro_stepper.dart';

/// CPF SEGURO — TopAppBar (organismo unificado).
///
/// Único ponto de entrada pro slot superior da tela. Cada variante é uma
/// **factory nomeada** que compõe [CpfSeguroStatusBar] +
/// [CpfSeguroNavigationTopBar] (+ [CpfSeguroStepper] opcional) numa
/// [CpfSeguroGlassSurface] — ou, no `.bottomsheet()`, num container branco
/// opaco com grip no topo.
///
/// **Filosofia atomic**:
/// - Átomo: [CpfSeguroStatusBar]
/// - Moléculas: [CpfSeguroNavigationTopBar] (com [CpfSeguroNavigationLeftAccessory]
///   e [CpfSeguroNavigationRightAccessory] como accessories), [CpfSeguroStepper]
/// - Organismo: este widget
///
/// Variantes:
/// - `.defaultVariant(navBar:)`  → glass (StatusBar + NavigationTopBar)
/// - `.stepper(navBar:, stepper:)` → glass (StatusBar + NavigationTopBar + Stepper)
/// - `.bottomsheet(navBar:)`     → container branco (grip + NavigationTopBar)
class CpfSeguroTopAppBar extends StatelessWidget {
  const CpfSeguroTopAppBar._({required this.variant});

  final _TopAppBarVariant variant;

  /// Default = StatusBar + NavigationTopBar em glass.
  CpfSeguroTopAppBar.defaultVariant({
    super.key,
    required CpfSeguroNavigationTopBar navBar,
  }) : variant = _DefaultVariant(navBar);

  /// Stepper = StatusBar + NavigationTopBar + Stepper em glass.
  CpfSeguroTopAppBar.stepper({
    super.key,
    required CpfSeguroNavigationTopBar navBar,
    required CpfSeguroStepper stepper,
  }) : variant = _StepperVariant(navBar, stepper);

  /// Bottomsheet = grip (traço) + NavigationTopBar em container branco opaco.
  /// **Sem StatusBar** (é uma superfície interna, não a barra do sistema) e
  /// **sem glass** (o sheet já é sólido branco atrás).
  CpfSeguroTopAppBar.bottomsheet({
    super.key,
    required CpfSeguroNavigationTopBar navBar,
  }) : variant = _BottomsheetVariant(navBar);

  /// App real = glass + **inset REAL da status bar** (SafeArea) + NavigationTopBar.
  /// Diferente do `.defaultVariant`, NÃO desenha a [CpfSeguroStatusBar] mock
  /// (9:41) — no app a status bar do sistema é a de verdade. Use como
  /// `flexibleSpace`/conteúdo do topo com `extendBodyBehindAppBar: true`.
  CpfSeguroTopAppBar.app({
    super.key,
    required CpfSeguroNavigationTopBar navBar,
  }) : variant = _AppVariant(navBar);

  @override
  Widget build(BuildContext context) => variant.build(context);
}

// ═══════════════════════════════════════════════════════════════════════════
// Variantes
// ═══════════════════════════════════════════════════════════════════════════

sealed class _TopAppBarVariant {
  const _TopAppBarVariant();
  Widget build(BuildContext context);
}

class _DefaultVariant extends _TopAppBarVariant {
  const _DefaultVariant(this.navBar);
  final CpfSeguroNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) => CpfSeguroGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CpfSeguroStatusBar(),
            navBar,
          ],
        ),
      );
}

class _StepperVariant extends _TopAppBarVariant {
  const _StepperVariant(this.navBar, this.stepper);
  final CpfSeguroNavigationTopBar navBar;
  final CpfSeguroStepper stepper;

  @override
  Widget build(BuildContext context) => CpfSeguroGlassSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CpfSeguroStatusBar(),
            navBar,
            stepper,
            const SizedBox(height: 8),
          ],
        ),
      );
}

class _AppVariant extends _TopAppBarVariant {
  const _AppVariant(this.navBar);
  final CpfSeguroNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) => CpfSeguroGlassSurface(
        child: SafeArea(
          bottom: false,
          child: navBar,
        ),
      );
}

class _BottomsheetVariant extends _TopAppBarVariant {
  const _BottomsheetVariant(this.navBar);
  final CpfSeguroNavigationTopBar navBar;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: s.surface,
        borderRadius: const BorderRadius.only(
          topLeft: CpfSeguroRadius.r24,
          topRight: CpfSeguroRadius.r24,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Center(
              child: Container(
                width: 75,
                height: 5,
                decoration: BoxDecoration(
                  color: s.fg,
                  borderRadius: CpfSeguroRadius.pillAll,
                ),
              ),
            ),
          ),
          navBar,
        ],
      ),
    );
  }
}
