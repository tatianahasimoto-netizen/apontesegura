import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — WalletCard (molécula).
///
/// Cartão visual da Carteira: 345×180 (width flexível), radius 24,
/// padding px 24 py 16. Figma 1152:21383.
///
/// Variantes (named constructors):
/// - [CpfSeguroWalletCard.cpfSeguro] — azul primary-04: wordmark "CPF seguro"
///   branco topo-esquerda + mark Pix 25 topo-direita + "••• 1234" embaixo.
/// - [CpfSeguroWalletCard.partner] — skin escura do cartão físico (cardDark):
///   logo do parceiro topo-direita + últimos dígitos e bandeira embaixo.
/// - [CpfSeguroWalletCard.skeleton] — cinza com tarja, usado no fluxo de
///   adicionar cartão ("Aproxime do cartão" / "Adicionando cartão").
/// - [CpfSeguroWalletCard.payment] — azul do fluxo Pagar: label
///   "Pix aproximação" topo-esquerda + wordmark topo-direita + mark 36
///   embaixo-esquerda.
///
/// **Composição** — Icon (átomo) + tokens.
class CpfSeguroWalletCard extends StatelessWidget {
  const CpfSeguroWalletCard.cpfSeguro({
    super.key,
    this.lastDigits = '7654',
  })  : _variant = _WalletVariant.cpfSeguro,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  const CpfSeguroWalletCard.partner({
    super.key,
    this.lastDigits = '7654',
    this.partnerLogo = 'assets/logos/swile.png',
    this.networkLogo = 'assets/logos/card-network.png',
  })  : _variant = _WalletVariant.partner,
        label = null;

  const CpfSeguroWalletCard.skeleton({super.key})
      : _variant = _WalletVariant.skeleton,
        lastDigits = null,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  const CpfSeguroWalletCard.payment({
    super.key,
    this.label = 'Pix aproximação',
  })  : _variant = _WalletVariant.payment,
        lastDigits = null,
        partnerLogo = null,
        networkLogo = null;

  /// Splash do NFC/aproximação: fundo primary, mark grande à esquerda +
  /// mark Pix à direita. Responsivo (AspectRatio 2), não altura fixa.
  const CpfSeguroWalletCard.pixSplash({super.key})
      : _variant = _WalletVariant.pixSplash,
        lastDigits = null,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  final _WalletVariant _variant;

  /// Últimos 4 dígitos ("7654") — renderizado como "••• 7654".
  final String? lastDigits;

  /// Label do fluxo Pagar ("Pix aproximação").
  final String? label;

  /// Asset do logo do parceiro (variante partner).
  final String? partnerLogo;

  /// Asset da bandeira (variante partner). Null omite.
  final String? networkLogo;

  static const double height = 180;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroWalletCard',
      props: {
        'variant': _variant.name,
        if (lastDigits != null) 'lastDigits': lastDigits!,
        if (label != null) 'label': "'$label'",
      },
      tokens: [
        '345×180 · radius 24 · px 24 py 16',
        switch (_variant) {
          _WalletVariant.cpfSeguro ||
          _WalletVariant.payment ||
          _WalletVariant.pixSplash =>
            'bg: primary-04 · logo/mark white',
          _WalletVariant.partner => 'bg: cardDark (#272727)',
          _WalletVariant.skeleton => 'gradient neutral-07→08 + tarja neutral-06',
        },
      ],
      child: _wrapAspect(Container(
      height: _variant == _WalletVariant.pixSplash ? null : height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: switch (_variant) {
          _WalletVariant.cpfSeguro ||
          _WalletVariant.payment ||
          _WalletVariant.pixSplash =>
            s.primary,
          _WalletVariant.partner => CpfSeguroColors.cardDark,
          _WalletVariant.skeleton => null,
        },
        gradient: _variant == _WalletVariant.skeleton
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [CpfSeguroColors.neutral07, CpfSeguroColors.neutral08],
              )
            : null,
        borderRadius: CpfSeguroRadius.all24,
      ),
      child: switch (_variant) {
        _WalletVariant.cpfSeguro => _buildCpf(),
        _WalletVariant.partner => _buildPartner(),
        _WalletVariant.skeleton => _buildSkeleton(),
        _WalletVariant.payment => _buildPayment(),
        _WalletVariant.pixSplash => _buildPixSplash(),
      },
      )),
    );
  }

  /// pixSplash é responsivo (AspectRatio 2) em vez de altura fixa.
  Widget _wrapAspect(Widget card) {
    if (_variant == _WalletVariant.pixSplash) {
      return AspectRatio(aspectRatio: 2, child: card);
    }
    return card;
  }

  Widget _buildPixSplash() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CpfSeguroLogo(
              variant: CpfSeguroLogoVariant.mark,
              size: 68,
              color: CpfSeguroColors.white),
          Spacer(),
          CpfSeguroIconAccessory(
              icon: CpfSeguroIcons.pixSolid,
              padding: 0,
              size: 50,
              color: CpfSeguroColors.white),
        ],
      ),
    );
  }

  Widget _buildCpf() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 26, color: CpfSeguroColors.white),
              CpfSeguroIconAccessory(icon: CpfSeguroIcons.pixMark, padding: 0, size: 25, color: CpfSeguroColors.white),
            ],
          ),
          Text(
            '••• ${lastDigits ?? ''}',
            style: CpfSeguroType.heading.copyWith(color: CpfSeguroColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPartner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (partnerLogo != null) Image.asset(partnerLogo!, height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '••• ${lastDigits ?? ''}',
                style: CpfSeguroType.heading.copyWith(color: CpfSeguroColors.white),
              ),
              if (networkLogo != null) Image.asset(networkLogo!, height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    // Tarja magnética 44px a 16px do topo (fluxo adicionar cartão).
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(height: 44, color: CpfSeguroColors.neutral06),
      ],
    );
  }

  Widget _buildPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6, vertical: CpfSeguroSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label ?? '',
                style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.white),
              ),
              const CpfSeguroLogo(variant: CpfSeguroLogoVariant.full, size: 26, color: CpfSeguroColors.white),
            ],
          ),
          const CpfSeguroIconAccessory(icon: CpfSeguroIcons.pixMark, padding: 0, size: 36, color: CpfSeguroColors.white),
        ],
      ),
    );
  }
}

enum _WalletVariant { cpfSeguro, partner, skeleton, payment, pixSplash }
