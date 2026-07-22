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
import 'cpf_seguro_checkbox.dart';
import 'cpf_seguro_input.dart';
import 'cpf_seguro_action.dart' show CpfSeguroActionDirection;
import 'cpf_seguro_app_list.dart'
    show
        CpfSeguroAppList,
        CpfSeguroAppListRow,
        CpfSeguroLeftAccessory,
        CpfSeguroMiddleAccessory,
        CpfSeguroRightAccessory;
import 'cpf_seguro_sheet_overlay.dart';

/// Cartão salvo listado no [CpfSeguroCheckoutSheet].
class CpfSeguroCheckoutCard {
  const CpfSeguroCheckoutCard({required this.label, this.sublabel});
  final String label;
  final String? sublabel;
}

/// Linha do resumo de valores ("Subtotal · R\$ 545,00").
class CpfSeguroCheckoutLine {
  const CpfSeguroCheckoutLine({required this.label, required this.value, this.emphasized = false});
  final String label;
  final String value;

  /// Total — renderiza em title ao invés de body.
  final bool emphasized;
}

/// Estados do [CpfSeguroCheckoutSheet].
enum CpfSeguroCheckoutSheetState {
  /// Resumo do pedido: valores detalhados + forma de pagamento com "Trocar".
  summary,

  /// Trocar forma: Pix (aprovação na hora) + cartões salvos + adicionar novo.
  methods,

  /// Inserir um cartão novo (com opção de salvar na carteira).
  newCard,

  /// Pagar com Pix: copia e cola + timer + confirmação automática.
  pix,
}

/// CPF SEGURO — CheckoutSheet (organismo).
///
/// Checkout e-commerce invocado pelo [WalletButton] na loja do parceiro —
/// bench: checkout do iFood (cartão E Pix):
///
/// - [CpfSeguroCheckoutSheetState.summary] — pedido + resumo de valores +
///   forma de pagamento selecionada com link "Trocar" + CTA contextual
///   ("Pagar R\$ X" / "Pagar com Pix").
/// - [CpfSeguroCheckoutSheetState.methods] — Pix primeiro ("Aprovação na
///   hora") + cartões salvos (radio) + "Adicionar novo cartão".
/// - [CpfSeguroCheckoutSheetState.newCard] — form + "Salvar na minha carteira".
/// - [CpfSeguroCheckoutSheetState.pix] — copia e cola + expiração +
///   confirmação automática (pagamento acontece no app do banco).
///
/// Cartão segue pro [CpfSeguroPaymentSheet] (faceId → resultado); Pix
/// confirma sozinho e cai no success.
///
/// Precisa de um [Stack] ancestral (Positioned.fill + scrim internos).
class CpfSeguroCheckoutSheet extends StatelessWidget {
  const CpfSeguroCheckoutSheet({
    super.key,
    required this.open,
    required this.onClose,
    required this.state,
    required this.merchant,
    required this.amount,
    this.merchantInitials = '••',
    this.orderRef,
    this.lines = const [],
    this.cards = const [],
    this.selectedCard = 0,
    this.pixSelected = false,
    this.pixCode,
    this.pixExpiry,
    this.saveNewCard = true,
    this.onSelectCard,
    this.onSelectPix,
    this.onNewCard,
    this.onChangeMethod,
    this.onPay,
    this.onCopyPix,
    this.onToggleSave,
  });

  final bool open;
  final VoidCallback onClose;
  final CpfSeguroCheckoutSheetState state;

  /// Nome da loja ("Pague menos").
  final String merchant;
  final String merchantInitials;

  /// Referência do pedido ("Pedido #4821").
  final String? orderRef;

  /// Total formatado ("R\$ 560,00").
  final String amount;

  /// Resumo de valores (Subtotal/Taxa/Total) — summary.
  final List<CpfSeguroCheckoutLine> lines;

  final List<CpfSeguroCheckoutCard> cards;
  final int selectedCard;

  /// Pix é a forma selecionada (summary/methods).
  final bool pixSelected;

  /// Código copia e cola (estado pix).
  final String? pixCode;

  /// Expiração do código ("9:58").
  final String? pixExpiry;

  /// Checkbox "Salvar na minha carteira" (estado newCard).
  final bool saveNewCard;

  final ValueChanged<int>? onSelectCard;
  final VoidCallback? onSelectPix;
  final VoidCallback? onNewCard;

  /// Link "Trocar" da forma de pagamento (summary).
  final VoidCallback? onChangeMethod;
  final VoidCallback? onPay;
  final VoidCallback? onCopyPix;
  final ValueChanged<bool>? onToggleSave;

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
                title: 'Pagamento',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(CpfSeguroSpacing.s6, CpfSeguroSpacing.s2, CpfSeguroSpacing.s6, CpfSeguroSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pedido — loja + referência, sempre visível.
                  CpfSeguroAppListRow(
                    left: CpfSeguroLeftAccessory.avatar(initials: merchantInitials),
                    middle: CpfSeguroMiddleAccessory.titleSubtitle(
                      title: merchant,
                      subtitle: orderRef,
                    ),
                  ),
                  ...switch (state) {
                    CpfSeguroCheckoutSheetState.summary => _summary(s),
                    CpfSeguroCheckoutSheetState.methods => _methods(s),
                    CpfSeguroCheckoutSheetState.newCard => _newCard(s),
                    CpfSeguroCheckoutSheetState.pix => _pix(s),
                  },
                  const SizedBox(height: 24),
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

  // ─── summary — resumo de valores + forma de pagamento com Trocar ────────
  List<Widget> _summary(CpfSeguroScheme s) {
    return [
      const SizedBox(height: 8),
      Container(height: 1, color: s.divider),
      const SizedBox(height: 12),
      for (final line in lines)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                line.label,
                style: line.emphasized
                    ? CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)
                    : CpfSeguroType.bodyMd.copyWith(color: s.textTertiary),
              ),
              Text(
                line.value,
                style: line.emphasized
                    ? CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)
                    : CpfSeguroType.bodyMd.copyWith(color: s.textSecondary),
              ),
            ],
          ),
        ),
      const SizedBox(height: 12),
      Container(height: 1, color: s.divider),
      const SizedBox(height: 16),
      // Forma de pagamento selecionada + Trocar (padrão iFood).
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Forma de pagamento', style: CpfSeguroType.subheading.copyWith(color: s.fg)),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onChangeMethod,
              child: Text(
                'Trocar',
                style: CpfSeguroType.label.copyWith(color: s.primary),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      CpfSeguroAppList.carded(children: [
        pixSelected
            ? const CpfSeguroAppListRow(
                left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.pixLight),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(
                  title: 'Pix',
                  subtitle: 'Aprovação na hora',
                ),
              )
            : CpfSeguroAppListRow(
                left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.creditCardLight),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(
                  title: cards.isNotEmpty ? cards[selectedCard].label : '',
                  subtitle: cards.isNotEmpty ? cards[selectedCard].sublabel : null,
                ),
              ),
      ]),
    ];
  }

  // ─── methods — Pix primeiro + cartões + adicionar ────────────────────────
  List<Widget> _methods(CpfSeguroScheme s) {
    return [
      const SizedBox(height: 16),
      Text('Pagar com', style: CpfSeguroType.subheading.copyWith(color: s.fg)),
      const SizedBox(height: 8),
      CpfSeguroAppList.carded(children: [
        CpfSeguroAppListRow(
          onTap: onSelectPix,
          left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.pixLight),
          middle: const CpfSeguroMiddleAccessory.titleSubtitle(
            title: 'Pix',
            subtitle: 'Aprovação na hora',
          ),
          right: CpfSeguroRightAccessory.radio(
            selected: pixSelected,
            onPressed: onSelectPix ?? () {},
          ),
        ),
        for (var i = 0; i < cards.length; i++)
          CpfSeguroAppListRow(
            onTap: onSelectCard == null ? null : () => onSelectCard!(i),
            left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.creditCardLight),
            middle: CpfSeguroMiddleAccessory.titleSubtitle(
              title: cards[i].label,
              subtitle: cards[i].sublabel,
            ),
            right: CpfSeguroRightAccessory.radio(
              selected: !pixSelected && i == selectedCard,
              onPressed: () => onSelectCard?.call(i),
            ),
          ),
        CpfSeguroAppListRow(
          onTap: onNewCard,
          left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.plusLight),
          middle: const CpfSeguroMiddleAccessory.titleSubtitle(
            title: 'Adicionar novo cartão',
            subtitle: 'Crédito ou débito — dá pra salvar na carteira',
          ),
          right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
        ),
      ]),
    ];
  }

  // ─── newCard — form + salvar na carteira ─────────────────────────────────
  List<Widget> _newCard(CpfSeguroScheme s) {
    return [
      const SizedBox(height: 16),
      Text('Novo cartão', style: CpfSeguroType.subheading.copyWith(color: s.fg)),
      const SizedBox(height: 8),
      CpfSeguroInput(
        controller: TextEditingController(text: '5502 09** **** 7665'),
        label: 'Número do cartão',
      ),
      const SizedBox(height: 12),
      CpfSeguroInput(
        controller: TextEditingController(text: 'Ana Maria Soares'),
        label: 'Nome do titular',
      ),
      const SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: CpfSeguroInput(
            controller: TextEditingController(text: '12/2028'),
            label: 'Validade',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CpfSeguroInput(
            controller: TextEditingController(text: '765'),
            label: 'CVV',
            helper: 'Não fica salvo',
          ),
        ),
      ]),
      const SizedBox(height: 12),
      CpfSeguroCheckbox(
        checked: saveNewCard,
        onChanged: onToggleSave ?? (_) {},
        label: 'Salvar na minha carteira',
        description: 'Vira um código seguro — pague por aproximação depois',
      ),
    ];
  }

  // ─── pix — copia e cola + timer + confirmação automática ────────────────
  List<Widget> _pix(CpfSeguroScheme s) {
    return [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pix copia e cola', style: CpfSeguroType.subheading.copyWith(color: s.fg)),
          if (pixExpiry != null)
            Text(
              'expira em $pixExpiry',
              style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.warning03),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(CpfSeguroSpacing.s3),
        decoration: BoxDecoration(
          color: s.bg,
          borderRadius: CpfSeguroRadius.all8,
          border: Border.all(color: s.divider, width: 1),
        ),
        child: Text(
          pixCode ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: CpfSeguroType.caption.copyWith(color: s.textTertiary),
        ),
      ),
      const SizedBox(height: 16),
      for (final (i, step) in const [
        'Copie o código',
        'Pague no app do seu banco',
        'A confirmação aqui é automática',
      ].indexed)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s1),
          child: Row(children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: s.primarySubtle, shape: BoxShape.circle),
              child: Text('${i + 1}', style: CpfSeguroType.labelSm.copyWith(color: s.primary)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(step, style: CpfSeguroType.bodyMd.copyWith(color: s.textSecondary)),
            ),
          ]),
        ),
    ];
  }

  Widget _footer() {
    switch (state) {
      case CpfSeguroCheckoutSheetState.pix:
        return CpfSeguroButton(
          label: 'Copiar código Pix',
          size: CpfSeguroButtonSize.lg,
          leadIcon: CpfSeguroIcons.cloneLight,
          fullWidth: true,
          onPressed: onCopyPix,
        );
      case CpfSeguroCheckoutSheetState.summary:
        return CpfSeguroButton(
          label: pixSelected ? 'Pagar com Pix' : 'Pagar $amount',
          size: CpfSeguroButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
      case CpfSeguroCheckoutSheetState.methods:
      case CpfSeguroCheckoutSheetState.newCard:
        return CpfSeguroButton(
          label: 'Pagar $amount',
          size: CpfSeguroButtonSize.lg,
          fullWidth: true,
          onPressed: onPay,
        );
    }
  }
}
