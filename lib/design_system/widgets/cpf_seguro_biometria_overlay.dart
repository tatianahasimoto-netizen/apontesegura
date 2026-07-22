import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;

/// CPF SEGURO — BiometriaOverlay.
///
/// Overlay Face ID/Touch ID pra validar alteração. Full-screen scrim escuro
/// + pulso do ícone + mensagem. Se [autoSuccess=true] (default), chama
/// [onSuccess] após ~1.2s simulando o scan.
///
/// [onCancel] fecha sem validar (tap no scrim).
class CpfSeguroBiometriaOverlay extends StatefulWidget {
  const CpfSeguroBiometriaOverlay({
    super.key,
    required this.open,
    required this.onSuccess,
    required this.onCancel,
    this.autoSuccess = true,
  });

  final bool open;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;
  final bool autoSuccess;

  @override
  State<CpfSeguroBiometriaOverlay> createState() => _CpsBiometriaOverlayState();
}

enum _BioStatus { scanning, success }

class _CpsBiometriaOverlayState extends State<CpfSeguroBiometriaOverlay> {
  _BioStatus _status = _BioStatus.scanning;

  @override
  void didUpdateWidget(covariant CpfSeguroBiometriaOverlay old) {
    super.didUpdateWidget(old);
    if (widget.open && !old.open) {
      _status = _BioStatus.scanning;
      if (widget.autoSuccess) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!mounted || !widget.open) return;
          setState(() => _status = _BioStatus.success);
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted && widget.open) widget.onSuccess();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onCancel,
        child: Semantics(
          scopesRoute: true,
          explicitChildNodes: true,
          label: 'Autenticação biométrica',
          child: ColoredBox(
            color: CpfSeguroColors.blackAlpha40,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BioBubble(status: _status),
                  const SizedBox(height: 24),
                  Text(
                    _status == _BioStatus.success ? 'Autenticado' : 'Olhe para o dispositivo',
                    style: CpfSeguroType.heading.copyWith(color: CpfSeguroColors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BioBubble extends StatefulWidget {
  const _BioBubble({required this.status});
  final _BioStatus status;

  @override
  State<_BioBubble> createState() => _BioBubbleState();
}

class _BioBubbleState extends State<_BioBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final scale = widget.status == _BioStatus.scanning ? (1 + _pulse.value * 0.06) : 1.0;
        final opacity = widget.status == _BioStatus.scanning ? (1 - _pulse.value * 0.2) : 1.0;
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: CpfSeguroMotion.short,
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.status == _BioStatus.success ? CpfSeguroColors.success04 : CpfSeguroColors.transparent,
                borderRadius: CpfSeguroRadius.all24,
                border: widget.status == _BioStatus.success
                    ? null
                    : Border.all(color: CpfSeguroColors.whiteAlpha90, width: 2),
              ),
              child: CpfSeguroIconAccessory(
                icon: widget.status == _BioStatus.success ? 'check-light' : 'fingerprint-light',
                padding: 0,
                size: 56,
                color: CpfSeguroColors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
