import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_spot_icon.dart' show CpfSeguroSpotIcon, CpfSeguroSpotState;
import 'cpf_seguro_dev_inspect.dart';

/// Estado semântico do Toast.
enum CpfSeguroToastState { normal, success, error, warning }

/// CPF SEGURO — Toast.
///
/// Feedback temporário pós-ação. Renderiza inline — quem decide quando
/// aparecer/sumir é o caller (state local ou controlador global). Pra
/// animação de entrada, embrulhe num [AnimatedSwitcher] ou [Positioned]
/// + slide.
///
/// ```dart
/// CpfSeguroToast(state: CpfSeguroToastState.success, title: 'Senha alterada!'),
/// CpfSeguroToast(
///   state: CpfSeguroToastState.error,
///   title: 'Falha ao enviar',
///   subtitle: 'Verifique sua conexão e tente de novo.',
/// ),
/// ```
class CpfSeguroToast extends StatelessWidget {
  const CpfSeguroToast({
    super.key,
    required this.title,
    this.state = CpfSeguroToastState.normal,
    this.subtitle,
    this.icon,
  });

  final String title;
  final CpfSeguroToastState state;
  final String? subtitle;

  /// Sobrepõe o ícone default do state.
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final cfg = _toastConfig(state);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroToast',
      props: {'title': "'$title'", 'state': state.name},
      tokens: const ['glass · radius 16 · spot por state · subheading 14/600'],
      child: ClipRRect(
      borderRadius: CpfSeguroRadius.all8,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Semantics(
          liveRegion: true,
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cfg.bg,
              border: Border.all(color: cfg.border, width: 1),
              borderRadius: CpfSeguroRadius.all8,
              boxShadow: CpfSeguroElevation.soft,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s3, vertical: CpfSeguroSpacing.s2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CpfSeguroSpotIcon(
                    icon: icon ?? cfg.defaultIcon,
                    state: cfg.iconState,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral01),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: CpfSeguroType.caption.copyWith(
                              color: CpfSeguroColors.neutral03,
                              fontSize: 13,
                              letterSpacing: 0,
                              height: 16 / 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class _ToastConfig {
  const _ToastConfig({
    required this.bg,
    required this.border,
    required this.iconState,
    required this.defaultIcon,
  });
  final Color bg;
  final Color border;
  final CpfSeguroSpotState iconState;
  final String defaultIcon;
}

_ToastConfig _toastConfig(CpfSeguroToastState s) => switch (s) {
      CpfSeguroToastState.normal => const _ToastConfig(
          bg: CpfSeguroColors.neutral10Alpha70,
          border: CpfSeguroColors.neutral08,
          iconState: CpfSeguroSpotState.normal,
          defaultIcon: 'hand-wave-light',
        ),
      CpfSeguroToastState.success => const _ToastConfig(
          bg: CpfSeguroColors.success07Alpha70,
          border: CpfSeguroColors.success06,
          iconState: CpfSeguroSpotState.success,
          defaultIcon: 'check-light',
        ),
      CpfSeguroToastState.error => const _ToastConfig(
          bg: CpfSeguroColors.error07Alpha70,
          border: CpfSeguroColors.error06,
          iconState: CpfSeguroSpotState.error,
          defaultIcon: 'xmark-light',
        ),
      CpfSeguroToastState.warning => const _ToastConfig(
          bg: CpfSeguroColors.warning07Alpha70,
          border: CpfSeguroColors.warning06,
          iconState: CpfSeguroSpotState.warning,
          defaultIcon: 'triangle-exclamation-light',
        ),
    };
