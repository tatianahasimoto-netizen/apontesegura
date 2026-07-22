import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';

/// CPF SEGURO — SheetOverlay (base interna dos bottomsheets).
///
/// Reusa scrim escuro + sheet slide-up pra qualquer bottomsheet do DS.
/// NÃO é exportado no barrel — é infra compartilhada pelos sheets
/// (ExitConfirm, Password, Payment, Checkout).
///
/// Renderiza `SizedBox.shrink()` quando [open=false]. Quando true, cobre o
/// pai com scrim (40% preto) e sobrepõe o [child] alinhado bottom. O pai
/// deve ser um [Stack] ancestral (mesmo padrão do React que usa
/// `position: absolute` dentro do PhoneShell).
class CpfSeguroSheetOverlay extends StatefulWidget {
  const CpfSeguroSheetOverlay({
    super.key,
    required this.open,
    required this.onScrimTap,
    required this.child,
  });

  final bool open;
  final VoidCallback onScrimTap;
  final Widget child;

  @override
  State<CpfSeguroSheetOverlay> createState() => _CpsSheetOverlayState();
}

class _CpsSheetOverlayState extends State<CpfSeguroSheetOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: CpfSeguroMotion.medium,
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _c, curve: CpfSeguroMotion.enter);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: CpfSeguroMotion.enter));

  @override
  void initState() {
    super.initState();
    if (widget.open) _c.value = 1;
  }

  @override
  void didUpdateWidget(covariant CpfSeguroSheetOverlay old) {
    super.didUpdateWidget(old);
    if (widget.open && !old.open) _c.forward();
    if (!widget.open && old.open) _c.reverse();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open && _c.value == 0) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        children: [
          // Positioned.fill obrigatório — ColoredBox sem filho como child
          // solto do Stack colapsa pra 0×0 e o scrim não pinta.
          Positioned.fill(
            child: FadeTransition(
              opacity: _fade,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onScrimTap,
                child: const ColoredBox(color: CpfSeguroColors.blackAlpha40),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(position: _slide, child: widget.child),
          ),
        ],
      ),
    );
  }
}
