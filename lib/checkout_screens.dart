import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';
import 'handoff_layout.dart';

/// Checkout e-commerce do SDK — como TELAS CHEIAS (não bottom sheet).
///
/// O SDK roda embarcado no app do parceiro; abrir bottom sheet nativo POR CIMA
/// do parceiro é frágil, então o checkout de pagamento vira uma jornada de
/// telas cheias. Mesmo conteúdo das sheets ([CpfSeguroCheckoutSheet] /
/// [CpfSeguroPaymentSheet]), reancorado num [HandoffPhoneShell] com top bar
/// (back + "Pagamento") e CTA na [CpfSeguroBottomApp].
///
/// [buildCheckoutScreen] expõe cada passo por chave — reusado no grupo do SDK
/// (`sdk_screen.dart`) e no fluxo de telas da aba Fluxos.
///
/// Passos: summary · summary-pix · methods · new-card · pix · face-id ·
/// processing · success · failed.
Widget buildCheckoutScreen(String key) => switch (key) {
      'summary' => const _CheckoutSummaryScreen(),
      'summary-pix' => const _CheckoutSummaryScreen(pix: true),
      'methods' => const _CheckoutMethodsScreen(),
      'new-card' => const _CheckoutNewCardScreen(),
      'pix' => const _CheckoutPixScreen(),
      'face-id' => const _CheckoutResultScreen(state: _Result.faceId),
      'processing' => const _CheckoutResultScreen(state: _Result.processing),
      'success' => const _CheckoutResultScreen(state: _Result.success),
      'failed' => const _CheckoutResultScreen(state: _Result.failed),
      _ => const SizedBox.shrink(),
    };

/// Wrapper const de [buildCheckoutScreen] — permite usar as telas de checkout
/// dentro de árvores const (ex.: o `groups: const [...]` do HandoffLayout no
/// SDK), já que a função em si não é uma expressão const.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen(this.stepKey, {super.key});
  final String stepKey;
  @override
  Widget build(BuildContext context) => buildCheckoutScreen(stepKey);
}

// ── Dados de demonstração (os mesmos dos mocks de sheet) ─────────────────────
const _merchant = 'Pague menos';
const _initials = 'PM';
const _orderRef = 'Pedido #4821';
const _amount = 'R\$ 560,00';
const _pixCode = '00020126580014BR.GOV.BCB.PIX0136a1b2c3d4-e5f6-7890-abcd-'
    'ef1234567890520400005303986540560.005802BR5912CPF SEGURO SA6009SAO '
    'PAULO62070503***6304A1B2';
const _pixExpiry = '9:58';

// ═══════════════════════════════════════════════════════════════════════════
// Scaffold compartilhado — top bar + corpo rolável + CTA na bottom bar
// ═══════════════════════════════════════════════════════════════════════════

/// Casca padrão das telas de checkout. [cta] nulo cai só no home indicator
/// (telas de processamento, que não têm ação).
Widget _checkoutScaffold({
  required String title,
  required Widget body,
  CpfSeguroNavigationButton? cta,
  bool showBack = true,
  double bottomPad = 150,
}) {
  return HandoffPhoneShell(
    topSlot: CpfSeguroTopAppBar.defaultVariant(
      navBar: CpfSeguroNavigationTopBar(
        left: showBack
            ? CpfSeguroNavigationLeftAccessory.back(onPressed: () {})
            : null,
        title: title,
      ),
    ),
    bottomSlot: cta != null
        ? CpfSeguroBottomApp.button(button: cta)
        : const CpfSeguroBottomHomeIndicator(),
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 108, 24, bottomPad),
      child: body,
    ),
  );
}

/// Cabeçalho do pedido — loja + referência (sempre no topo do corpo).
Widget _orderHeader() => const CpfSeguroAppListRow(
      left: CpfSeguroLeftAccessory.avatar(initials: _initials),
      middle: CpfSeguroMiddleAccessory.titleSubtitle(
        title: _merchant,
        subtitle: _orderRef,
      ),
    );

// ═══════════════════════════════════════════════════════════════════════════
// C1 / C4 · Resumo do pedido (cartão ou Pix)
// ═══════════════════════════════════════════════════════════════════════════

class _CheckoutSummaryScreen extends StatelessWidget {
  const _CheckoutSummaryScreen({this.pix = false});
  final bool pix;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    Widget line(String label, String value, {bool emph = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: CpfSeguroSpacing.s1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: emph
                      ? CpfSeguroType.heading
                          .copyWith(color: s.fg, letterSpacing: 0)
                      : CpfSeguroType.bodyMd.copyWith(color: s.textTertiary)),
              Text(value,
                  style: emph
                      ? CpfSeguroType.heading
                          .copyWith(color: s.fg, letterSpacing: 0)
                      : CpfSeguroType.bodyMd.copyWith(color: s.textSecondary)),
            ],
          ),
        );

    return _checkoutScaffold(
      title: 'Pagamento',
      cta: CpfSeguroNavigationButton(
        primary: CpfSeguroNavigationAction(
            label: pix ? 'Pagar com Pix' : 'Pagar $_amount'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _orderHeader(),
          const SizedBox(height: 8),
          Container(height: 1, color: s.divider),
          const SizedBox(height: 12),
          line('Subtotal', 'R\$ 545,00'),
          line('Taxa de serviço', 'R\$ 15,00'),
          line('Total', _amount, emph: true),
          const SizedBox(height: 12),
          Container(height: 1, color: s.divider),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Forma de pagamento',
                  style: CpfSeguroType.subheading.copyWith(color: s.fg)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Text('Trocar',
                      style: CpfSeguroType.label.copyWith(color: s.primary)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CpfSeguroAppList.carded(children: [
            pix
                ? const CpfSeguroAppListRow(
                    left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.pixLight),
                    middle: CpfSeguroMiddleAccessory.titleSubtitle(
                      title: 'Pix',
                      subtitle: 'Aprovação na hora',
                    ),
                  )
                : const CpfSeguroAppListRow(
                    left: CpfSeguroLeftAccessory.spotIcon(
                        icon: CpfSeguroIcons.creditCardLight),
                    middle: CpfSeguroMiddleAccessory.titleSubtitle(
                      title: 'CPF Seguro •••• 7654',
                      subtitle: 'Cartão padrão',
                    ),
                  ),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// C2 · Trocar forma — Pix primeiro + cartões + adicionar
// ═══════════════════════════════════════════════════════════════════════════

class _CheckoutMethodsScreen extends StatelessWidget {
  const _CheckoutMethodsScreen();

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return _checkoutScaffold(
      title: 'Forma de pagamento',
      cta: const CpfSeguroNavigationButton(
        primary: CpfSeguroNavigationAction(label: 'Pagar $_amount'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _orderHeader(),
          const SizedBox(height: 16),
          Text('Pagar com',
              style: CpfSeguroType.subheading.copyWith(color: s.fg)),
          const SizedBox(height: 8),
          CpfSeguroAppList.carded(children: [
            CpfSeguroAppListRow(
              onTap: () {},
              left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.pixLight),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                title: 'Pix',
                subtitle: 'Aprovação na hora',
              ),
              right: CpfSeguroRightAccessory.radio(
                  selected: false, onPressed: () {}),
            ),
            CpfSeguroAppListRow(
              onTap: () {},
              left: const CpfSeguroLeftAccessory.spotIcon(
                  icon: CpfSeguroIcons.creditCardLight),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                title: 'CPF Seguro •••• 7654',
                subtitle: 'Cartão padrão',
              ),
              right: CpfSeguroRightAccessory.radio(
                  selected: true, onPressed: () {}),
            ),
            CpfSeguroAppListRow(
              onTap: () {},
              left: const CpfSeguroLeftAccessory.spotIcon(
                  icon: CpfSeguroIcons.creditCardLight),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                title: 'CPF Seguro •••• 8890',
                subtitle: 'Crédito',
              ),
              right: CpfSeguroRightAccessory.radio(
                  selected: false, onPressed: () {}),
            ),
            CpfSeguroAppListRow(
              onTap: () {},
              left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.plusLight),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                title: 'Adicionar novo cartão',
                subtitle: 'Crédito ou débito — dá pra salvar na carteira',
              ),
              right: const CpfSeguroRightAccessory.action(
                  direction: CpfSeguroActionDirection.right),
            ),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// C3 · Novo cartão — form + salvar na carteira
// ═══════════════════════════════════════════════════════════════════════════

class _CheckoutNewCardScreen extends StatelessWidget {
  const _CheckoutNewCardScreen();

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return _checkoutScaffold(
      title: 'Novo cartão',
      cta: const CpfSeguroNavigationButton(
        primary: CpfSeguroNavigationAction(label: 'Pagar $_amount'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _orderHeader(),
          const SizedBox(height: 16),
          Text('Dados do cartão',
              style: CpfSeguroType.subheading.copyWith(color: s.fg)),
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
            checked: true,
            onChanged: (_) {},
            label: 'Salvar na minha carteira',
            description: 'Vira um código seguro — pague por aproximação depois',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// C5 · Pix copia e cola — código + timer + 3 passos
// ═══════════════════════════════════════════════════════════════════════════

class _CheckoutPixScreen extends StatelessWidget {
  const _CheckoutPixScreen();

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return _checkoutScaffold(
      title: 'Pagar com Pix',
      cta: const CpfSeguroNavigationButton(
        primary: CpfSeguroNavigationAction(
            label: 'Copiar código Pix', leadIcon: CpfSeguroIcons.cloneLight),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _orderHeader(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pix copia e cola',
                  style: CpfSeguroType.subheading.copyWith(color: s.fg)),
              Text('expira em $_pixExpiry',
                  style: CpfSeguroType.labelSm
                      .copyWith(color: CpfSeguroColors.warning03)),
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
            child: Text(_pixCode,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CpfSeguroType.caption.copyWith(color: s.textTertiary)),
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
                  decoration: BoxDecoration(
                      color: s.primarySubtle, shape: BoxShape.circle),
                  child: Text('${i + 1}',
                      style: CpfSeguroType.labelSm.copyWith(color: s.primary)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(step,
                      style: CpfSeguroType.bodyMd
                          .copyWith(color: s.textSecondary)),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// C6-C8 · Resultado — Face ID → processando → aprovado / não aprovado
// ═══════════════════════════════════════════════════════════════════════════

enum _Result { faceId, processing, success, failed }

class _CheckoutResultScreen extends StatelessWidget {
  const _CheckoutResultScreen({required this.state});
  final _Result state;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);

    final (Widget body, CpfSeguroNavigationButton? cta, bool back) =
        switch (state) {
      _Result.faceId => (
          const Center(child: CpfSeguroFaceIdCard()),
          null,
          true,
        ),
      _Result.processing => (
          Column(mainAxisSize: MainAxisSize.min, children: [
            const CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.lg),
            const SizedBox(height: 16),
            Text('Processando pagamento...',
                style:
                    CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)),
            const SizedBox(height: 4),
            Text('Não feche o app — leva só alguns segundos.',
                textAlign: TextAlign.center,
                style: CpfSeguroType.caption.copyWith(color: s.textMuted)),
          ]),
          null,
          false,
        ),
      _Result.success => (
          Column(mainAxisSize: MainAxisSize.min, children: [
            const CpfSeguroIconAccessory(
                icon: CpfSeguroIcons.circleCheckLight,
                padding: 0,
                size: 44,
                color: CpfSeguroColors.success04),
            const SizedBox(height: 16),
            Text('Pagamento efetuado',
                style:
                    CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)),
            const SizedBox(height: 2),
            Text('hoje às 17:43',
                style: CpfSeguroType.caption.copyWith(color: s.textMuted)),
            const SizedBox(height: 16),
            _valuePill(s, CpfSeguroColors.success04),
          ]),
          const CpfSeguroNavigationButton(
            primary: CpfSeguroNavigationAction(label: 'Voltar à loja'),
          ),
          false,
        ),
      _Result.failed => (
          Column(mainAxisSize: MainAxisSize.min, children: [
            const CpfSeguroSpotIcon(
              icon: CpfSeguroIcons.triangleExclamationLight,
              type: CpfSeguroSpotType.outline,
              state: CpfSeguroSpotState.error,
              size: 44,
            ),
            const SizedBox(height: 16),
            Text('Pagamento não aprovado',
                style:
                    CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)),
            const SizedBox(height: 4),
            Text('O emissor recusou a transação. Você não foi cobrado.',
                textAlign: TextAlign.center,
                style: CpfSeguroType.caption.copyWith(color: s.textMuted)),
          ]),
          const CpfSeguroNavigationButton(
            primary: CpfSeguroNavigationAction(label: 'Tentar novamente'),
            secondary: CpfSeguroNavigationAction(label: 'Usar outro cartão'),
          ),
          false,
        ),
    };

    // Resultado é conteúdo centrado — envolve num layout que ocupa a tela.
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: CpfSeguroNavigationTopBar(
          left: back
              ? CpfSeguroNavigationLeftAccessory.back(onPressed: () {})
              : null,
          title: 'Pagamento',
        ),
      ),
      bottomSlot: cta != null
          ? CpfSeguroBottomApp.button(button: cta)
          : const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 108, 24, 150),
        child: Center(child: body),
      ),
    );
  }

  Widget _valuePill(CpfSeguroScheme s, Color accent) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CpfSeguroSpacing.s8, vertical: CpfSeguroSpacing.s2),
        decoration: BoxDecoration(
          border: Border.all(color: accent, width: 1.5),
          borderRadius: CpfSeguroRadius.pillAll,
        ),
        child: Text(_amount, style: CpfSeguroType.title.copyWith(color: s.fg)),
      );
}
