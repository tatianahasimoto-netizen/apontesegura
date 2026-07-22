import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_top_app_bar.dart';
import 'cpf_seguro_bottom_home_indicator.dart';
import 'cpf_seguro_wallet_card.dart';
import 'cpf_seguro_face_id_card.dart';
import 'cpf_seguro_loading_spinner.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_spot_icon.dart'
    show CpfSeguroSpotIcon, CpfSeguroSpotType, CpfSeguroSpotState;
import 'cpf_seguro_sheet_overlay.dart';

/// Estados do [CpfSeguroPaymentSheet].
enum CpfSeguroPaymentSheetState {
  /// Autenticação biométrica inline (FaceIdCard).
  faceId,

  /// Aguardando a maquininha (ícone + instrução).
  approach,

  /// Valor recebido da maquininha — o usuário CONFIRMA vendo o valor
  /// antes do commit final ("Pagar").
  confirm,

  /// Pagamento em processamento — spinner + "não feche o app".
  processing,

  /// Aprovado — check verde + valor + CTA (comprovante/voltar).
  success,

  /// Recusado pelo emissor — motivo + Tentar novamente / Usar outro cartão.
  failed,
}

/// CPF SEGURO — PaymentSheet (organismo).
///
/// Bottom sheet do pagamento por aproximação (Figma 14967:20863). É um
/// sheet — e não uma tela — de propósito: um dia pode ser invocado até
/// FORA do app (padrão Apple Pay). Sequência:
///
/// 1. [CpfSeguroPaymentSheetState.faceId]     — autentica
/// 2. [CpfSeguroPaymentSheetState.approach]   — aproxima da maquininha
/// 3. [CpfSeguroPaymentSheetState.confirm]    — VÊ O VALOR e toca "Pagar"
/// 4. [CpfSeguroPaymentSheetState.processing] — processando (sem footer)
/// 5. [CpfSeguroPaymentSheetState.success] ou [CpfSeguroPaymentSheetState.failed]
///
/// O fluxo INTEIRO mora no sheet — do Face ID ao resultado.
///
/// O passo confirm é CONFIGURÁVEL ("Confirmar valor antes de pagar" nas
/// configurações da carteira) — desligado, o Face ID já aprova e o fluxo
/// pula direto pro processamento.
///
/// Precisa de um [Stack] ancestral (Positioned.fill + scrim internos).
class CpfSeguroPaymentSheet extends StatelessWidget {
  const CpfSeguroPaymentSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.state,
    this.value,
    this.timestamp,
    this.onPay,
    this.onReadQr,
    this.successLabel = 'Ver comprovante',
    this.onSuccessAction,
    this.onRetry,
    this.onChangeCard,
    this.title = 'Pix por aproximação',
  }) : assert(
            (state != CpfSeguroPaymentSheetState.confirm &&
                    state != CpfSeguroPaymentSheetState.success) ||
                value != null,
            'confirm/success exigem o value da transação.');

  final bool open;
  final VoidCallback onClose;
  final CpfSeguroPaymentSheetState state;

  /// Valor formatado recebido da maquininha ("R\$ 1,00") — confirm/success.
  final String? value;

  /// Linha de data/hora no success ("hoje às 17:43").
  final String? timestamp;

  final VoidCallback? onPay;
  final VoidCallback? onReadQr;

  /// Label do CTA no success — "Ver comprovante" no app próprio,
  /// "Voltar ao Aurora" quando invocado do parceiro.
  final String successLabel;
  final VoidCallback? onSuccessAction;
  final VoidCallback? onRetry;
  final VoidCallback? onChangeCard;
  final String title;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroSheetOverlay(
      open: open,
      onScrimTap: onClose,
      child: Container(
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
            CpfSeguroTopAppBar.bottomsheet(
              navBar: CpfSeguroNavigationTopBar(
                left: CpfSeguroNavigationLeftAccessory.close(onPressed: onClose),
                title: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(CpfSeguroSpacing.s6, CpfSeguroSpacing.s4, CpfSeguroSpacing.s6, CpfSeguroSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CpfSeguroWalletCard.payment(),
                  const SizedBox(height: 40),
                  _body(s),
                  const SizedBox(height: 40),
                  _footer(),
                ],
              ),
            ),
            const CpfSeguroBottomHomeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _body(CpfSeguroScheme s) {
    switch (state) {
      case CpfSeguroPaymentSheetState.faceId:
        return const Center(child: CpfSeguroFaceIdCard());
      case CpfSeguroPaymentSheetState.approach:
        return Column(children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: s.primary, width: 2),
            ),
            child: CpfSeguroIconAccessory(icon: CpfSeguroIcons.mobileLight, padding: 0, size: 28, color: s.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Aproxime da maquininha',
            style: CpfSeguroType.bodyMd.copyWith(color: s.fg),
          ),
        ]);
      case CpfSeguroPaymentSheetState.confirm:
        return Column(children: [
          CpfSeguroIconAccessory(icon: CpfSeguroIcons.circleCheckLight, padding: 0, size: 44, color: s.primary),
          const SizedBox(height: 24),
          // Pill com o valor — o usuário SEMPRE vê quanto vai pagar antes
          // de confirmar.
          _valuePill(s, s.primary),
        ]);
      case CpfSeguroPaymentSheetState.processing:
        return Column(children: [
          const CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.lg),
          const SizedBox(height: 16),
          Text(
            'Processando pagamento...',
            style: CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          const SizedBox(height: 4),
          Text(
            'Não feche o app — leva só alguns segundos.',
            style: CpfSeguroType.caption.copyWith(color: s.textMuted),
          ),
        ]);
      case CpfSeguroPaymentSheetState.success:
        return Column(children: [
          const CpfSeguroIconAccessory(icon: CpfSeguroIcons.circleCheckLight, padding: 0, size: 44, color: CpfSeguroColors.success04),
          const SizedBox(height: 16),
          Text(
            'Pagamento efetuado',
            style: CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 2),
            Text(
              timestamp!,
              style: CpfSeguroType.caption.copyWith(color: s.textMuted),
            ),
          ],
          const SizedBox(height: 16),
          _valuePill(s, CpfSeguroColors.success04),
        ]);
      case CpfSeguroPaymentSheetState.failed:
        return Column(children: [
          const CpfSeguroSpotIcon(
            icon: CpfSeguroIcons.triangleExclamationLight,
            type: CpfSeguroSpotType.outline,
            state: CpfSeguroSpotState.error,
            size: 44,
          ),
          const SizedBox(height: 16),
          Text(
            'Pagamento não aprovado',
            style: CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0),
          ),
          const SizedBox(height: 4),
          Text(
            'O emissor recusou a transação. Você não foi cobrado.',
            textAlign: TextAlign.center,
            style: CpfSeguroType.caption.copyWith(color: s.textMuted),
          ),
        ]);
    }
  }

  Widget _valuePill(CpfSeguroScheme s, Color accent) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s8, vertical: CpfSeguroSpacing.s2),
        decoration: BoxDecoration(
          border: Border.all(color: accent, width: 1.5),
          borderRadius: CpfSeguroRadius.pillAll,
        ),
        child: Text(
          value ?? '',
          style: CpfSeguroType.title.copyWith(color: s.fg),
        ),
      ),
    );
  }

  Widget _footer() {
    switch (state) {
      case CpfSeguroPaymentSheetState.confirm:
        return CpfSeguroButton(
          label: 'Pagar',
          size: CpfSeguroButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
      case CpfSeguroPaymentSheetState.processing:
        // Sem ação durante o processamento — o estado fala por si.
        return const SizedBox.shrink();
      case CpfSeguroPaymentSheetState.success:
        return CpfSeguroButton(
          label: successLabel,
          size: CpfSeguroButtonSize.lg,
          fullWidth: true,
          onPressed: onSuccessAction,
        );
      case CpfSeguroPaymentSheetState.failed:
        return Column(mainAxisSize: MainAxisSize.min, children: [
          CpfSeguroButton(
            label: 'Tentar novamente',
            size: CpfSeguroButtonSize.lg,
            fullWidth: true,
            onPressed: onRetry,
          ),
          const SizedBox(height: 8),
          CpfSeguroButton(
            label: 'Usar outro cartão',
            type: CpfSeguroButtonType.secondary,
            size: CpfSeguroButtonSize.lg,
            fullWidth: true,
            onPressed: onChangeCard,
          ),
        ]);
      case CpfSeguroPaymentSheetState.faceId:
      case CpfSeguroPaymentSheetState.approach:
        return CpfSeguroButton(
          label: 'Ler QR Code',
          type: CpfSeguroButtonType.secondary,
          size: CpfSeguroButtonSize.lg,
          leadIcon: CpfSeguroIcons.qrcodeLight,
          fullWidth: true,
          onPressed: onReadQr,
        );
    }
  }
}
