import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';
import 'handoff_layout.dart';
import 'checkout_screens.dart';

/// Tab SDK — reproduz todas as 21 telas do handoff (~/Desktop/cpf-seguro-app)
/// em Flutter/Dart usando os widgets do DS. Sidebar de navegação à esquerda,
/// tela isolada à direita — o dev abre só o fluxo que precisa ver.
class SdkScreen extends StatelessWidget {
  const SdkScreen({super.key});

  static const String _partner = 'Banco Aurora';

  @override
  Widget build(BuildContext context) {
    return const HandoffLayout(
      title: 'SDK · Handoff',
      description: '27 telas · Migração, Gestão e Wallet/Pagamentos',
      groups: [
        HandoffGroup(
          title: 'Migração',
          subtitle: '13 telas · fluxo linear do primeiro acesso',
          screens: [
            HandoffScreen(label: 'T1 · SMS (novo cliente)', caption: 'Push nativo iOS — o CPF SEGURO ainda não existe pro usuário.', child: _SmsMock()),
            HandoffScreen(label: 'T1.1 · SMS (já tem CPF SEGURO)', caption: 'Push nativo — usuário existente, texto diferente.', child: _SmsExistenteMock()),
            HandoffScreen(label: 'T2 · Welcome (via SMS)', caption: 'Primeira tela após deep link. Cobrand + hero + PartnerButton.', child: _WelcomeMock()),
            HandoffScreen(label: 'T2.1 · Acesso pendente', caption: 'Usuário migrado sem senha ainda. Cobrand + ícone lock + CTA.', child: _AcessoPendenteMock()),
            HandoffScreen(label: 'T2.2 · Não migrado', caption: 'Novo user, fora da base de migração. Cobrand + user-plus.', child: _NaoMigradoMock()),
            HandoffScreen(label: 'T3.0 · CPF (chat)', caption: 'Chat SDK · passo 1/5. Input numérico com CPF.', child: _CpfMock()),
            HandoffScreen(label: 'T3a · Criar senha (chat)', caption: 'Chat SDK · passo 2/5. Password numérico + CriteriaBubble.', child: _CreatePasswordMock()),
            HandoffScreen(label: 'T3b · Aceitar termos (chat)', caption: 'Chat SDK · passo 3/5. Button.chatLift no meio, input disabled.', child: _TermsMock()),
            HandoffScreen(label: 'T3c · OTP celular (chat)', caption: 'Chat SDK · passo 4/5. Código SMS.', child: _OtpMock()),
            HandoffScreen(label: 'T3d · Confirmar dados', caption: 'Chat SDK · passo 5/5. Card de review clicável.', child: _ConfirmarDadosMock()),
            HandoffScreen(label: 'T5 · Sucesso (card)', caption: 'ChatCompletionCard enxuto no fim do chat.', child: _SuccessMock()),
            HandoffScreen(label: 'T4 · Ativar biometria', caption: 'Cobrand + título + 2 CTAs + toggle "pular".', child: _BiometriaMock()),
            HandoffScreen(label: 'T6 · Login recorrente', caption: 'Logo parceiro + 2 inputs + PartnerButton + CobrandedBadge.', child: _LoginRecurringMock()),
          ],
        ),
        HandoffGroup(
          title: 'Gestão de cadastro',
          subtitle: '8 telas · área lateral pós-onboarding',
          screens: [
            HandoffScreen(label: 'Meu cadastro', caption: 'Profile banner + 2 grupos de menu + cobrand.', child: _ProfileMock()),
            HandoffScreen(label: 'Dados pessoais', caption: 'PageTitle + AppListGroup com rows readonly/editáveis.', child: _DadosPessoaisMock()),
            HandoffScreen(label: 'Alterar nome', caption: 'Input + Button "Salvar".', child: _AlterarNomeMock()),
            HandoffScreen(label: 'Alterar endereço', caption: 'Múltiplos inputs + checkbox "sem número".', child: _AlterarEnderecoMock()),
            HandoffScreen(label: 'Alterar celular', caption: 'Input tel + Button "Salvar".', child: _AlterarCelularMock()),
            HandoffScreen(label: 'Segurança', caption: 'AppListGroup com 4 rows.', child: _SegurancaMock()),
            HandoffScreen(label: 'Documentos', caption: '3 rows (2 chevron + 1 disabled).', child: _DocumentosMock()),
            HandoffScreen(label: 'Excluir perfil', caption: 'RadioList com 6 motivos + Button destructive.', child: _ExcluirPerfilMock()),
          ],
        ),
        HandoffGroup(
          title: 'Wallet e Pagamentos',
          subtitle: '15 telas · o parceiro embeda UM botão; o resto é nosso',
          screens: [
            HandoffScreen(label: 'W0 · Botão no parceiro', caption: 'O único contato do parceiro: WalletButton pay/manage embedado.', child: _WalletEntryButtonMock()),
            HandoffScreen(label: 'Pagar · sheet Face ID', caption: 'PaymentSheet abre POR CIMA do app do parceiro — por isso é sheet.', child: _WalletEntrySheetMock(state: CpfSeguroPaymentSheetState.faceId)),
            HandoffScreen(label: 'Pagar · confirmar valor', caption: 'Mesmo sheet, valor recebido — user vê e toca Pagar.', child: _WalletEntrySheetMock(state: CpfSeguroPaymentSheetState.confirm)),
            HandoffScreen(label: 'Carteira · hub', caption: '"Carteira CPF Seguro" abre isto: cartão + Adicionar/Extrato/Configurações.', child: _WalletHubSheetMock()),
            HandoffScreen(label: 'Carteira · oferta (1º uso)', caption: 'Sem cartão ainda: venda da wallet + CTA Adicionar à carteira.', child: _WalletOfferMock()),
            HandoffScreen(label: 'Adicionar · aproxime (NFC)', caption: 'Sim — aproximação pega os dados também no parceiro.', child: _WalletSdkApproachMock()),
            HandoffScreen(label: 'Adicionar · dados manuais', caption: 'Número/Titular/Validade/CVV — validação via compra de R\$ 0,00.', child: _WalletCardFormMock()),
            HandoffScreen(label: 'Adicionar · salvando', caption: 'Cartão vira código seguro — parceiro não vê os dados.', child: _WalletTokenizingMock()),
            HandoffScreen(label: 'Adicionar · código no extrato', caption: 'Compra de R\$ 0,00 com código no nome — user confere no banco.', child: _Wallet3dsMock()),
            HandoffScreen(label: 'Adicionar · concluído', caption: 'Cartão pronto + Voltar ao parceiro.', child: _WalletSdkDoneMock()),
            HandoffScreen(label: 'Extrato no parceiro', caption: 'Mesmo extrato do cartão, invocado de dentro do parceiro.', child: _WalletSdkStatementMock()),
            HandoffScreen(label: 'Configurações no parceiro', caption: 'Mostrar valor, cartão padrão, Face ID obrigatório.', child: _WalletSdkSettingsMock()),
            HandoffScreen(label: 'Pagar · processando', caption: 'No MESMO sheet, sobre o parceiro.', child: _WalletEntrySheetMock(state: CpfSeguroPaymentSheetState.processing)),
            HandoffScreen(label: 'Pagar · aprovado', caption: 'No sheet: check + valor + Voltar ao Aurora.', child: _WalletEntrySheetMock(state: CpfSeguroPaymentSheetState.success)),
            HandoffScreen(label: 'Pagar · não aprovado', caption: 'No sheet: Tentar novamente / Usar outro cartão.', child: _WalletEntrySheetMock(state: CpfSeguroPaymentSheetState.failed)),
          ],
        ),
        HandoffGroup(
          title: 'Checkout e-commerce',
          subtitle: '10 telas cheias · bench iFood: resumo + Trocar, cartão e Pix',
          screens: [
            HandoffScreen(label: 'C0 · Botão na loja', caption: 'Checkout do e-commerce com o WalletButton embedado.', child: _CheckoutEntryMock()),
            HandoffScreen(label: 'C1 · Resumo do pedido', caption: 'Tela cheia (o SDK roda no parceiro — sheet nativo por cima é frágil). Valores + forma com "Trocar".', child: CheckoutScreen('summary')),
            HandoffScreen(label: 'C2 · Trocar forma', caption: 'Pix primeiro (aprovação na hora) + cartões salvos + adicionar.', child: CheckoutScreen('methods')),
            HandoffScreen(label: 'C3 · Novo cartão', caption: 'Form do cartão + "Salvar na minha carteira".', child: CheckoutScreen('new-card')),
            HandoffScreen(label: 'C4 · Resumo com Pix', caption: 'Pix selecionado — CTA vira "Pagar com Pix".', child: CheckoutScreen('summary-pix')),
            HandoffScreen(label: 'C5 · Pix copia e cola', caption: 'Código + expiração + 3 passos — confirmação automática.', child: CheckoutScreen('pix')),
            HandoffScreen(label: 'C6 · Face ID (cartão)', caption: 'Depois do Pagar com cartão, autentica na tela.', child: CheckoutScreen('face-id')),
            HandoffScreen(label: 'C7 · Processando', caption: 'Spinner + "não feche o app" — sem ação.', child: CheckoutScreen('processing')),
            HandoffScreen(label: 'C8 · Aprovado', caption: 'Check + valor + Voltar à loja (cartão ou Pix).', child: CheckoutScreen('success')),
            HandoffScreen(label: 'C9 · Não aprovado', caption: 'Retry / Usar outro cartão — volta pro C2.', child: CheckoutScreen('failed')),
          ],
        ),
      ],
    );
  }
}

/// Mock do iPhone 16 (393×852).

/// Stepper cobrand pra chat SDK (fixo: partner + logoSize 36 + textSize 11).
const _cobrandStepper = CpfSeguroCobrandMark(
  partnerName: SdkScreen._partner,
  logoSize: 36,
  textSize: 11,
);

/// TopAppBar do fluxo chat — recebe título + step/total. Sempre showClose=false
/// pra migração (user não pode abandonar sem completar).
Widget _chatTopBar({required String title, required int step, required int total, bool showClose = false}) {
  return CpfSeguroTopAppBar.stepper(
    navBar: CpfSeguroNavigationTopBar(
      left: showClose ? const CpfSeguroNavigationLeftAccessory.close() : null,
      title: title,
    ),
    stepper: CpfSeguroStepper(current: step, total: total, label: _cobrandStepper),
  );
}

/// Padding pro scroll do chat (topBar 146 + gap 16, bottomBar height + gap 16).
EdgeInsets _chatPadding(double bottomHeight) =>
    EdgeInsets.fromLTRB(16, 146 + 16, 16, bottomHeight + 16);

// ═══════════════════════════════════════════════════════════════════════════
// Migração — 13 telas
// ═══════════════════════════════════════════════════════════════════════════

// T1 · SMS (novo cliente CPF SEGURO) — mock iOS Messages
class _SmsMock extends StatelessWidget {
  const _SmsMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bg: s.bg,
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: _SmsBody(text:
          'Seu acesso ao Banco Aurora agora é protegido pelo CPF SEGURO. '
          'Abra o app pra criar sua nova senha: aurora.app/seguranca\n\n'
          '🔒 Não compartilhe esse SMS. Nunca pedimos senha por mensagem.'),
    );
  }
}

// T1.1 · SMS (usuário já tem CPF SEGURO)
class _SmsExistenteMock extends StatelessWidget {
  const _SmsExistenteMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bg: s.bg,
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: _SmsBody(text:
          'O Banco Aurora agora aceita seu login CPF SEGURO. Use a mesma senha '
          'e biometria que já usa no app do CPF SEGURO pra entrar: aurora.app/seguranca\n\n'
          '🔒 Não compartilhe esse SMS.'),
    );
  }
}

class _SmsBody extends StatelessWidget {
  const _SmsBody({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          // Header estilo Messages iOS: avatar circular partner + nome
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CpfSeguroColors.partnerPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: CpfSeguroText('BA', style: CpfSeguroType.heading.copyWith(color: CpfSeguroColors.white, letterSpacing: 0)),
                ),
                const SizedBox(height: 4),
                CpfSeguroText('Banco Aurora', style: CpfSeguroType.label.copyWith(color: s.fg)),
                CpfSeguroText('Aviso oficial', style: CpfSeguroType.caption.copyWith(color: s.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CpfSeguroText('Hoje 14:32', style: CpfSeguroType.labelSm.copyWith(color: s.textPlaceholder)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: s.surfaceMuted,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: CpfSeguroText(text, style: CpfSeguroType.bodyMd.copyWith(color: s.fg)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// T2 · Welcome (via SMS) — usa SdkScreen com fingerprint + PartnerButton
class _WelcomeMock extends StatelessWidget {
  const _WelcomeMock();
  @override
  Widget build(BuildContext context) {
    return const HandoffPhoneShell(
      bottomSlot: CpfSeguroBottomHomeIndicator(),
      child: CpfSeguroSdkScreen(
        partnerName: SdkScreen._partner,
        illustration: CpfSeguroIllustration.fingerprint,
        title: 'Seu login agora é com a gente',
        subtitle: 'Crie uma senha pelo CPF SEGURO em menos de 1 minuto.',
        primaryLabel: 'Criar nova senha',
      ),
    );
  }
}

// T2.1 · Acesso pendente (user migrado, sem senha ainda)
class _AcessoPendenteMock extends StatelessWidget {
  const _AcessoPendenteMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Criar minha senha'),
        ),
      ),
      child: const _HeroIconScreen(
        icon: CpfSeguroIcons.lockLight,
        title: 'Seu login agora é CPF SEGURO',
        subtitle: 'Pra continuar acessando o Banco Aurora, crie uma nova senha agora em menos de um minuto.',
      ),
    );
  }
}

// T2.2 · Não migrado (novo usuário, sem base de migração)
class _NaoMigradoMock extends StatelessWidget {
  const _NaoMigradoMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Fazer meu cadastro'),
        ),
      ),
      child: const _HeroIconScreen(
        icon: CpfSeguroIcons.userPlusLight,
        title: 'Conheça o CPF SEGURO',
        subtitle: 'Uma nova camada de segurança pro seu acesso ao Banco Aurora. Faça seu cadastro em menos de um minuto pra começar a usar.',
      ),
    );
  }
}

// Layout compartilhado T2.1 / T2.2: Cobrand + círculo com ícone + título + subtítulo
class _HeroIconScreen extends StatelessWidget {
  const _HeroIconScreen({required this.icon, required this.title, required this.subtitle});
  final String icon, title, subtitle;
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 122 + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CpfSeguroCobrandMark(logoSize: 68, center: false),
          const SizedBox(height: 40),
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: s.primarySubtle, shape: BoxShape.circle),
            child: CpfSeguroIcon(name: icon, size: 40, color: s.primary),
          ),
          const SizedBox(height: 24),
          CpfSeguroText(title, style: CpfSeguroType.title.copyWith(color: s.fg)),
          const SizedBox(height: 8),
          CpfSeguroText(subtitle, style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary)),
        ],
      ),
    );
  }
}

// T3.0 · CPF — chat com input numérico pedindo CPF
class _CpfMock extends StatelessWidget {
  const _CpfMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Seu CPF', step: 1, total: 5),
      bottomSlot: CpfSeguroBottomApp.chatInputAndKeyboard(
        input: CpfSeguroChatInput(
          controller: TextEditingController(),
          placeholder: 'Envie seu CPF',
          type: CpfSeguroChatInputType.numeric,
          maxLength: 11,
        ),
        keyboard: CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
      ),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(369),
        child: const CpfSeguroChatScroll(children: [
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Bem-vindo ao CPF SEGURO 👋')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Pra começar, me diga qual é o seu CPF.')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Ele fica seguro e só é usado pra proteger seu acesso ao Banco Aurora.')),
        ]),
      ),
    );
  }
}

// T3a · Criar senha (chat) — passo 2/5 com criteria bubble
class _CreatePasswordMock extends StatelessWidget {
  const _CreatePasswordMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Criar sua senha', step: 2, total: 5),
      bottomSlot: CpfSeguroBottomApp.chatInputAndKeyboard(
        input: CpfSeguroChatInput(
          controller: TextEditingController(),
          placeholder: 'Envie sua senha',
          type: CpfSeguroChatInputType.numeric,
          password: true,
          maxLength: 6,
        ),
        keyboard: CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
      ),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(369),
        child: const CpfSeguroChatScroll(children: [
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('086.***.***-49')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Encontrei você, Ana Maria!')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Crie uma senha de 6 dígitos pra acessar o Aurora com mais segurança.')),
          CpfSeguroChatCriteriaBubble(
            title: 'Requisitos pra senha:',
            items: [
              CpfSeguroCriteriaItem(label: '6 dígitos numéricos'),
              CpfSeguroCriteriaItem(label: 'Não ser sequência numérica'),
              CpfSeguroCriteriaItem(label: 'Não ter todos os dígitos iguais'),
              CpfSeguroCriteriaItem(label: 'Não ser sua data de nascimento'),
            ],
          ),
        ]),
      ),
    );
  }
}

// T3b · Aceitar termos (chat) — passo 3/5 com Button.chatLift no meio
class _TermsMock extends StatelessWidget {
  const _TermsMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Aceitar os termos', step: 3, total: 5),
      bottomSlot: CpfSeguroBottomApp.chatInput(
        input: CpfSeguroChatInput(
          controller: TextEditingController(),
          placeholder: 'Abra e aceite os termos',
          disabled: true,
        ),
      ),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(122),
        child: CpfSeguroChatScroll(children: [
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('••••••')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Senha criada!')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Pra continuar, você precisa aceitar os Termos de Uso do CPF SEGURO.')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Abra os termos e vá até o final do texto pra aceitar e continuar.')),
          CpfSeguroButton.chatLift(label: 'Abrir termos de uso', onPressed: () {}),
        ]),
      ),
    );
  }
}

// T3c · OTP celular (chat) — passo 4/5
class _OtpMock extends StatelessWidget {
  const _OtpMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Confirmar celular', step: 4, total: 5),
      bottomSlot: CpfSeguroBottomApp.chatInputAndKeyboard(
        input: CpfSeguroChatInput(
          controller: TextEditingController(),
          placeholder: 'Envie o código que recebeu',
          type: CpfSeguroChatInputType.numeric,
          maxLength: 6,
        ),
        keyboard: CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
      ),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(369),
        child: const CpfSeguroChatScroll(children: [
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('Li e aceito os termos')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Tudo certo')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Pra finalizar, vamos confirmar seu celular pra te avisar de logins e atividades importantes.')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('(11) 9 8765-9876')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Enviamos um código via SMS pro seu aparelho.')),
          CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Informe o código recebido.')),
        ]),
      ),
    );
  }
}

// T3d · Confirmar dados — passo 5/5 com card de review
class _ConfirmarDadosMock extends StatelessWidget {
  const _ConfirmarDadosMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Confirme seus dados', step: 5, total: 5),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Confirmar e finalizar'),
        ),
      ),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(122),
        child: CpfSeguroChatScroll(children: [
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('••••••')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Código confirmado')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Última coisa — confira se está tudo certo com seus dados.')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Escondi as partes sensíveis. Toque em qualquer item pra editar.')),
          CpfSeguroAppList.carded(children: [
            CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.userLight, title: 'Nome', subtitle: 'Ana ***** Silva'),
            CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.idCardLight, title: 'CPF', subtitle: '086.***.***-49', disabled: true),
            CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.mobileLight, title: 'Celular', subtitle: '(11) *****-4321'),
            CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.envelopeLight, title: 'E-mail', subtitle: 'a****@gmail.com'),
          ]),
        ]),
      ),
    );
  }
}

// T5 · Sucesso (card) — 3/3 com ChatCompletionCard enxuto
class _SuccessMock extends StatelessWidget {
  const _SuccessMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      hideStatusBar: true,
      topSlot: _chatTopBar(title: 'Tudo pronto', step: 3, total: 3),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        reverse: true,
        padding: _chatPadding(34),
        child: CpfSeguroChatScroll(children: [
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('Li e aceito os termos')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Tudo certo')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Enviamos um código via SMS pro seu aparelho.')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.user, editable: true, child: CpfSeguroText('123456')),
          const CpfSeguroChatBubble(from: CpfSeguroChatFrom.bot, child: CpfSeguroText('Código confirmado')),
          CpfSeguroChatCompletionCard(
            title: 'Tudo pronto!',
            primary: CpfSeguroCtaAction(label: 'Continuar', onPressed: () {}),
          ),
        ]),
      ),
    );
  }
}

// T4 · Ativar biometria (último) — cobrand + título + 2 CTAs + toggle "pular"
class _BiometriaMock extends StatelessWidget {
  const _BiometriaMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Faixa "pular explicação" com toggle
          Container(
            color: s.bg,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: CpfSeguroText(
                    'Pular essa explicação da próxima vez que eu entrar no aplicativo CPF SEGURO',
                    style: CpfSeguroType.caption.copyWith(color: s.textTertiary),
                  ),
                ),
                const SizedBox(width: 12),
                CpfSeguroToggleSwitch(value: false, onChanged: (_) {}),
              ],
            ),
          ),
          CpfSeguroBottomApp.button(
            button: const CpfSeguroNavigationButton(
              primary: CpfSeguroNavigationAction(label: 'Ativar biometria/face id'),
              secondary: CpfSeguroNavigationAction(label: 'Continuar com senha'),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CpfSeguroCobrandMark(logoSize: 68, center: false),
            const SizedBox(height: 40),
            CpfSeguroText('O uso da biometria/face id agiliza o acesso e transações no app.',
                style: CpfSeguroType.title.copyWith(color: s.fg)),
          ],
        ),
      ),
    );
  }
}

// T6 · Login recorrente — logo partner grande + 2 inputs + botão
class _LoginRecurringMock extends StatelessWidget {
  const _LoginRecurringMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 88, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CpfSeguroText(
              'Banco Aurora',
              textAlign: TextAlign.center,
              style: CpfSeguroType.title.copyWith(
                color: CpfSeguroColors.partnerPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 48),
            CpfSeguroInput(
              label: 'Email ou CPF',
              controller: TextEditingController(text: 'ana.silva@email.com'),
              placeholder: 'seuemail@exemplo.com',
            ),
            const SizedBox(height: 16),
            CpfSeguroInput(
              label: 'Senha',
              type: CpfSeguroInputType.password,
              controller: TextEditingController(text: '••••••'),
              placeholder: 'Sua senha CPF SEGURO',
            ),
            const SizedBox(height: 12),
            CpfSeguroText(
              'Esqueci minha senha →',
              style: CpfSeguroType.label.copyWith(color: CpfSeguroColors.partnerPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),
            CpfSeguroPartnerButton(label: 'Entrar', onPressed: () {}),
            const Spacer(),
            const CpfSeguroCobrandedBadge(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Gestão de cadastro — 8 telas
// ═══════════════════════════════════════════════════════════════════════════

// Meu cadastro — profile banner + 2 grupos de menu + cobrand rodapé
class _ProfileMock extends StatelessWidget {
  const _ProfileMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Meu cadastro',
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 92, 16, 34 + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CpfSeguroAppListRow.profileBanner(initials: 'AM', name: 'Ana Maria', subtitle: 'CPF 086.***.***-49'),
            const SizedBox(height: 24),
            CpfSeguroAppList.carded(title: 'Meus dados', children: [
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.userLight, title: 'Dados pessoais', subtitle: 'Nome, CPF, nascimento', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.lockLight, title: 'Segurança', subtitle: 'Senha e biometria', onTap: () {}),
            ]),
            const SizedBox(height: 24),
            CpfSeguroAppList.carded(title: 'Minha conta', children: [
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.fileLight, title: 'Documentos', subtitle: 'Termos e privacidade', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.fileSlashLight, title: 'Excluir perfil', subtitle: 'Encerra a conta', onTap: () {}),
            ]),
            const SizedBox(height: 32),
            const Center(child: CpfSeguroCobrandMark()),
          ],
        ),
      ),
    );
  }
}

// Dados pessoais — PageTitle + AppListGroup com 5 rows readonly/editáveis
class _DadosPessoaisMock extends StatelessWidget {
  const _DadosPessoaisMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Dados pessoais',
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 34 + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Dados pessoais', subtitle: 'Toque num item pra editar.'),
            const SizedBox(height: 24),
            CpfSeguroAppList.carded(children: [
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.userLight, title: 'Nome completo', subtitle: 'Ana Maria Souza Silva', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.idCardLight, title: 'CPF', subtitle: '086.***.***-49', disabled: true),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.calendarLight, title: 'Data de nascimento', subtitle: '18/09/1998', disabled: true),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.houseLight, title: 'Endereço', subtitle: 'R. das Flores, 42 · São Paulo/SP', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.mobileLight, title: 'Celular', subtitle: '(11) 9 8765-4321', onTap: () {}),
            ]),
          ],
        ),
      ),
    );
  }
}

// Alterar nome — Input + Button primary "Salvar"
class _AlterarNomeMock extends StatelessWidget {
  const _AlterarNomeMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Nome',
        ),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Salvar'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Nome', subtitle: 'Como você quer ser chamado.'),
            const SizedBox(height: 24),
            CpfSeguroInput(
              label: 'Nome completo',
              controller: TextEditingController(text: 'Ana Maria Souza Silva'),
            ),
          ],
        ),
      ),
    );
  }
}

// Alterar endereço — step 2 (Detalhes) com múltiplos Inputs + Checkbox "sem número"
class _AlterarEnderecoMock extends StatelessWidget {
  const _AlterarEnderecoMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Endereço',
        ),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Salvar'),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Seu endereço', subtitle: 'Confira e complete os campos.'),
            const SizedBox(height: 24),
            CpfSeguroInput(label: 'CEP', controller: TextEditingController(text: '01310-100'), disabled: true),
            const SizedBox(height: 16),
            CpfSeguroInput(label: 'Logradouro', controller: TextEditingController(text: 'R. das Flores'), disabled: true),
            const SizedBox(height: 16),
            CpfSeguroInput(label: 'Bairro', controller: TextEditingController(text: 'Bela Vista'), disabled: true),
            const SizedBox(height: 16),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 2, child: CpfSeguroInput(label: 'Cidade', controller: TextEditingController(text: 'São Paulo'), disabled: true)),
              const SizedBox(width: 12),
              Expanded(child: CpfSeguroInput(label: 'UF', controller: TextEditingController(text: 'SP'), disabled: true)),
            ]),
            const SizedBox(height: 16),
            CpfSeguroInput(label: 'Número', controller: TextEditingController(text: '42')),
            const SizedBox(height: 8),
            CpfSeguroCheckbox(checked: false, label: 'Sem número', onChanged: (_) {}),
            const SizedBox(height: 16),
            CpfSeguroInput(label: 'Complemento', controller: TextEditingController(), placeholder: 'Apto, bloco, etc.'),
          ],
        ),
      ),
    );
  }
}

// Alterar celular — Input tel + Button "Salvar alterações"
class _AlterarCelularMock extends StatelessWidget {
  const _AlterarCelularMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(left: CpfSeguroNavigationLeftAccessory.back()),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Salvar alterações'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Alterar número de celular', subtitle: 'Vamos enviar um código pra confirmar.'),
            const SizedBox(height: 24),
            CpfSeguroInput(
              label: 'Celular',
              controller: TextEditingController(text: '(11) 9 8765-4321'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}

// Segurança — PageTitle + AppListGroup com 4 rows (Alterar senha, Esqueci, Dispositivos, Biometria)
class _SegurancaMock extends StatelessWidget {
  const _SegurancaMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(left: CpfSeguroNavigationLeftAccessory.back()),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 34 + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Segurança', subtitle: 'Gerencie senha, biometria e dispositivos.'),
            const SizedBox(height: 24),
            CpfSeguroAppList.carded(children: [
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.lockLight, title: 'Alterar senha', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.keyLight, title: 'Esqueci minha senha', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.mobileLight, title: 'Dispositivos', subtitle: '2 conectados', onTap: () {}),
              CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.fingerprintLight, title: 'Biometria', subtitle: 'Ativa nesse dispositivo', onTap: () {}),
            ]),
          ],
        ),
      ),
    );
  }
}

// Documentos — 3 rows (2 chevron + 1 disabled)
class _DocumentosMock extends StatelessWidget {
  const _DocumentosMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Documentos',
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 34 + 24),
        child: CpfSeguroAppList.carded(children: [
          CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.fileLight, title: 'Termos de uso', onTap: () {}),
          CpfSeguroAppListRow.menuItem(icon: 'shield-light', title: 'Política de privacidade', onTap: () {}),
          CpfSeguroAppListRow.menuItem(icon: CpfSeguroIcons.receiptLight, title: 'Imposto de renda', subtitle: 'indisponível', disabled: true),
        ]),
      ),
    );
  }
}

// Excluir perfil — RadioList com 6 opções + Button primary state=error
class _ExcluirPerfilMock extends StatelessWidget {
  const _ExcluirPerfilMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(left: CpfSeguroNavigationLeftAccessory.back()),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Excluir tudo e encerrar', state: CpfSeguroButtonState.error),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(title: 'Solicitação de encerramento', subtitle: 'A exclusão é definitiva.'),
            const SizedBox(height: 24),
            CpfSeguroRadioList(
              title: 'Selecione o motivo do encerramento',
              value: 'oferta',
              onChanged: (_) {},
              options: const [
                CpfSeguroRadioOption(value: 'oferta', label: 'Recebi oferta de outro banco'),
                CpfSeguroRadioOption(value: 'tarifas', label: 'Insatisfação com o preço das tarifas'),
                CpfSeguroRadioOption(value: 'atendimento', label: 'Insatisfação com o atendimento'),
                CpfSeguroRadioOption(value: 'seguranca', label: 'Preocupação com segurança'),
                CpfSeguroRadioOption(value: 'nao-uso', label: 'Não uso mais o app'),
                CpfSeguroRadioOption(value: 'outro', label: 'Outro motivo'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Wallet e Pagamentos — SDK embarcado no parceiro (tokenização Cielo)
// ═══════════════════════════════════════════════════════════════════════════

/// W1 · Oferta — cobrand + cartão hero + CTA.
class _WalletOfferMock extends StatelessWidget {
  const _WalletOfferMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: CpfSeguroCobrandEyebrow(partnerName: SdkScreen._partner)),
            const SizedBox(height: 32),
            const CpfSeguroWalletCard.cpfSeguro(),
            const SizedBox(height: 32),
            const CpfSeguroPageTitle(
              title: 'Pague por aproximação com o CPF Seguro',
              subtitle: 'Adicione seu cartão Aurora à carteira e pague com '
                  'Pix aproximação ou QR Code. O comércio nunca vê o '
                  'número do seu cartão.',
            ),
            const Spacer(),
            CpfSeguroPartnerButton(label: 'Adicionar à carteira', onPressed: () {}),
            const SizedBox(height: 8),
            CpfSeguroButton(
              label: 'Agora não',
              type: CpfSeguroButtonType.tertiary,
              fullWidth: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// W2 · Dados do cartão — campos da tokenização Cielo (POST /1/card).
class _WalletCardFormMock extends StatelessWidget {
  const _WalletCardFormMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
          title: 'Adicionar cartão',
        ),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Validar cartão'),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 116, 24, 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroPageTitle(
              title: 'Dados do cartão',
              subtitle: 'Pra validar, fazemos uma compra de R\$ 0,00 no seu '
                  'cartão — nada é cobrado.',
            ),
            const SizedBox(height: 16),
            CpfSeguroInput(
              controller: TextEditingController(text: '5502 09** **** 7665'),
              label: 'Número do cartão',
            ),
            const SizedBox(height: 16),
            CpfSeguroInput(
              controller: TextEditingController(text: 'Ana Maria Soares'),
              label: 'Nome do titular',
              helper: 'Como está impresso no cartão',
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: CpfSeguroInput(
                  controller: TextEditingController(text: '12/2028'),
                  label: 'Validade',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CpfSeguroInput(
                  controller: TextEditingController(text: '765'),
                  label: 'CVV',
                  helper: 'Não fica salvo',
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// W3 · Tokenizando — CardToken Cielo sendo gerado.
class _WalletTokenizingMock extends StatelessWidget {
  const _WalletTokenizingMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 34),
        child: Column(
          children: [
            const Center(child: CpfSeguroCobrandEyebrow(partnerName: SdkScreen._partner)),
            const SizedBox(height: 120),
            const CpfSeguroWalletCard.skeleton(),
            const SizedBox(height: 48),
            CpfSeguroText(
              'Gerando seu\ncartão seguro',
              textAlign: TextAlign.center,
              style: CpfSeguroType.title.copyWith(color: s.textSecondary),
            ),
            const SizedBox(height: 8),
            CpfSeguroText(
              'Seus dados não são compartilhados com o parceiro nem com o comércio',
              textAlign: TextAlign.center,
              style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary),
            ),
            const SizedBox(height: 32),
            const CpfSeguroLoadingSpinner(),
          ],
        ),
      ),
    );
  }
}

/// W4 · Validação por compra de R\$ 0,00 — código no nome da compra.
class _Wallet3dsMock extends StatelessWidget {
  const _Wallet3dsMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.back(),
        ),
      ),
      bottomSlot: CpfSeguroBottomApp.button(
        button: const CpfSeguroNavigationButton(
          primary: CpfSeguroNavigationAction(label: 'Confirmar'),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 116, 24, 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CpfSeguroPageTitle(
              title: 'Confira o código no app do seu banco',
              subtitle: 'Fizemos uma compra de R\$ 0,00 no seu cartão. O nome '
                  'da compra é um código — abra o extrato do seu banco e '
                  'digite o código aqui.',
            ),
            const SizedBox(height: 16),
            CpfSeguroAppListDayGroup(label: 'No extrato do seu banco', children: [
              CpfSeguroAppListRow.transactionItem(
                icon: CpfSeguroIcons.creditCardLight,
                title: 'CPFSEG·481632',
                source: 'Compra aprovada',
                time: 'agora',
                amount: 'R\$ 0,00',
                negative: false,
              ),
            ]),
            const SizedBox(height: 24),
            const Center(child: CpfSeguroOtpInput(value: '481632')),
            const SizedBox(height: 24),
            Center(
              child: CpfSeguroButton(
                label: 'Não achei o código',
                type: CpfSeguroButtonType.tertiary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// W6 · Pagamento aprovado — mesmo design do detalhe de transação:

/// Conteúdo fake do app do PARCEIRO — blocos cinza representando a UI dele.
/// O que importa: o parceiro só embeda o [CpfSeguroWalletButton].
Widget _partnerAppSkeleton({required CpfSeguroScheme s}) {
  Widget block(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: s.surfaceMuted,
          borderRadius: CpfSeguroRadius.all8,
        ),
      );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: CpfSeguroColors.partnerPrimary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        block(140, 16),
      ]),
      const SizedBox(height: 24),
      block(double.infinity, 120),
      const SizedBox(height: 12),
      block(220, 14),
      const SizedBox(height: 8),
      block(160, 14),
    ],
  );
}

/// W0 · O botão que o parceiro embeda — checkout fake do Aurora com os dois
/// pontos de entrada (pagar + gerenciar carteira).
class _WalletEntryButtonMock extends StatelessWidget {
  const _WalletEntryButtonMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _partnerAppSkeleton(s: s),
            const Spacer(),
            CpfSeguroWalletButton(
              variant: CpfSeguroWalletButtonVariant.pay,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            CpfSeguroWalletButton(
              variant: CpfSeguroWalletButtonVariant.manage,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// W0.1/W0.2 · PaymentSheet por cima do app do parceiro — o motivo de ser
/// sheet: funciona fora do nosso app.
class _WalletEntrySheetMock extends StatelessWidget {
  const _WalletEntrySheetMock({required this.state});
  final CpfSeguroPaymentSheetState state;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      overlay: CpfSeguroPaymentSheet(
        open: true,
        onClose: () {},
        state: state,
        value: state == CpfSeguroPaymentSheetState.confirm ||
                state == CpfSeguroPaymentSheetState.success
            ? 'R\$ 1,00'
            : null,
        timestamp: state == CpfSeguroPaymentSheetState.success ? 'hoje às 17:43' : null,
        successLabel: 'Voltar ao Aurora',
        onSuccessAction: () {},
        onRetry: () {},
        onChangeCard: () {},
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _partnerAppSkeleton(s: s),
            const Spacer(),
            CpfSeguroWalletButton(
              variant: CpfSeguroWalletButtonVariant.pay,
              onPressed: () {},
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

/// Carteira · hub — o que abre no "Carteira CPF Seguro": sheet com o cartão
/// e as 3 ações (adicionar, extrato, configurações). Tudo a um toque.
class _WalletHubSheetMock extends StatelessWidget {
  const _WalletHubSheetMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      overlay: Positioned.fill(
        child: Stack(children: [
          const Positioned.fill(
            child: ColoredBox(color: CpfSeguroColors.blackAlpha40),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
                    navBar: const CpfSeguroNavigationTopBar(
                      left: CpfSeguroNavigationLeftAccessory.close(),
                      title: 'Carteira',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CpfSeguroWalletCard.cpfSeguro(),
                        const SizedBox(height: 24),
                        CpfSeguroAppList.carded(children: [
                          CpfSeguroAppListRow(
                            onTap: () {},
                            left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.plusLight),
                            middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                              title: 'Adicionar cartão',
                              subtitle: 'Por aproximação ou digitando os dados',
                            ),
                            right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
                          ),
                          CpfSeguroAppListRow(
                            onTap: () {},
                            left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.receiptLight),
                            middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                              title: 'Extrato',
                              subtitle: 'Compras, Pix aproximação e estornos',
                            ),
                            right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
                          ),
                          CpfSeguroAppListRow(
                            onTap: () {},
                            left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.gearLight),
                            middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                              title: 'Configurações',
                              subtitle: 'Confirmação de valor, cartão padrão',
                            ),
                            right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const CpfSeguroBottomHomeIndicator(),
                ],
              ),
            ),
          ),
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _partnerAppSkeleton(s: s),
            const Spacer(),
            CpfSeguroWalletButton(
              variant: CpfSeguroWalletButtonVariant.manage,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Adicionar · aproxime — o NFC também funciona no contexto do parceiro.
class _WalletSdkApproachMock extends StatelessWidget {
  const _WalletSdkApproachMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.close(),
          title: 'Adicionar cartão',
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Stack(
        children: [
          const Positioned(
            top: 116,
            left: 24,
            right: 24,
            child: CpfSeguroWalletCard.skeleton(),
          ),
          const Positioned(
            top: 192,
            left: 0,
            right: 0,
            child: Center(
              child: CpfSeguroIllustrationAccessory(
                  illustration: CpfSeguroIllustration.phoneApproach,
                  size: CpfSeguroIllustrationSize.xl),
            ),
          ),
          const Positioned(
            top: 268,
            left: 0,
            right: 0,
            child: Center(
              child: CpfSeguroLogo(
                variant: CpfSeguroLogoVariant.full,
                size: 40,
                color: CpfSeguroColors.neutral07,
              ),
            ),
          ),
          Positioned(
            top: 346,
            left: 72,
            right: 72,
            child: CpfSeguroGlassSurface(
              borderRadius: CpfSeguroRadius.all24,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CpfSeguroText(
                        'Aproxime\ndo cartão',
                        textAlign: TextAlign.center,
                        style: CpfSeguroType.title.copyWith(color: s.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      CpfSeguroText(
                        'Aproxime o celular do chip do cartão para adicioná-lo à carteira',
                        textAlign: TextAlign.center,
                        style: CpfSeguroType.bodyMd.copyWith(color: s.textTertiary),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          // CTA 40px acima do home indicator (34 + 40 = 74).
          Positioned(
            bottom: 74,
            left: 0,
            right: 0,
            child: Center(
              child: CpfSeguroButton(
                label: 'Inserir manualmente',
                type: CpfSeguroButtonType.tertiary,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Adicionar · concluído (SDK) — cartão pronto + volta pro parceiro.
class _WalletSdkDoneMock extends StatelessWidget {
  const _WalletSdkDoneMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: CpfSeguroCobrandEyebrow(partnerName: SdkScreen._partner)),
            const SizedBox(height: 32),
            const CpfSeguroWalletCard.cpfSeguro(),
            const SizedBox(height: 32),
            const CpfSeguroPageTitle(
              title: 'Cartão adicionado!',
              subtitle: 'Seu cartão foi salvo como um código seguro — o '
                  'Aurora e o comércio nunca veem o número.',
            ),
            const Spacer(),
            CpfSeguroPartnerButton(label: 'Voltar ao Aurora', onPressed: () {}),
            const SizedBox(height: 8),
            CpfSeguroButton(
              label: 'Fazer um pagamento',
              type: CpfSeguroButtonType.tertiary,
              leadIcon: CpfSeguroIcons.qrcodeLight,
              fullWidth: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Extrato do cartão invocado de dentro do parceiro (close, não back).
class _WalletSdkStatementMock extends StatelessWidget {
  const _WalletSdkStatementMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: CpfSeguroNavigationTopBar(
          left: const CpfSeguroNavigationLeftAccessory.close(),
          title: 'Extrato',
          right: CpfSeguroNavigationRightAccessory.inputChip(label: '•••• 7654', onPressed: () {}),
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 108, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroAmountDisplay(
              label: 'Gasto no mês',
              value: 'R\$ 1.155,00',
              centered: false,
            ),
            const SizedBox(height: 24),
            CpfSeguroAppListDayGroup(label: 'Hoje', children: [
              CpfSeguroAppListRow.transactionItem(
                icon: CpfSeguroIcons.creditCardLight,
                title: 'Compra em Pague menos',
                source: 'Cartão •••• 7654',
                time: '12:04',
                amount: 'R\$ 560,00',
              ),
              CpfSeguroAppListRow.transactionItem(
                title: 'Pix aproximação',
                source: 'Directo Pagamentos',
                time: '11:32',
                amount: 'R\$ 35,00',
              ),
            ]),
            const SizedBox(height: 24),
            CpfSeguroAppListDayGroup(label: '14/05', children: [
              CpfSeguroAppListRow.transactionItem(
                title: 'Pix aproximação',
                source: 'Pague menos',
                time: '18:22',
                amount: 'R\$ 560,00',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Configurações da carteira invocadas de dentro do parceiro.
class _WalletSdkSettingsMock extends StatelessWidget {
  const _WalletSdkSettingsMock();
  @override
  Widget build(BuildContext context) {
    return HandoffPhoneShell(
      topSlot: CpfSeguroTopAppBar.defaultVariant(
        navBar: const CpfSeguroNavigationTopBar(
          left: CpfSeguroNavigationLeftAccessory.close(),
          title: 'Carteira',
        ),
      ),
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 116, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CpfSeguroSectionHeader(label: 'PAGAMENTO'),
            const SizedBox(height: 12),
            CpfSeguroAppList.carded(children: [
              CpfSeguroAppListRow(
                left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.circleCheckLight),
                middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                  title: 'Mostrar valor antes de pagar',
                  subtitle: 'Você confere o valor e toca em Pagar antes de concluir',
                ),
                right: CpfSeguroRightAccessory.toggle(value: true, onChanged: (_) {}),
              ),
              CpfSeguroAppListRow(
                onTap: () {},
                left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.creditCardLight),
                middle: const CpfSeguroMiddleAccessory.titleSubtitle(
                  title: 'Cartão padrão',
                  subtitle: 'CPF Seguro •••• 7654',
                ),
                right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
              ),
            ]),
            const SizedBox(height: 24),
            const CpfSeguroSectionHeader(label: 'SEGURANÇA'),
            const SizedBox(height: 12),
            CpfSeguroAppList.carded(children: const [
              CpfSeguroAppListRow(
                left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.faceIdLight),
                middle: CpfSeguroMiddleAccessory.titleSubtitle(
                  title: 'Face ID em toda transação',
                  subtitle: 'Toda compra exige sua biometria — isso não pode ser desligado',
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Checkout e-commerce — pagar uma compra na loja do parceiro
// ═══════════════════════════════════════════════════════════════════════════

/// Checkout fake do e-commerce — carrinho + total + WalletButton.
Widget _ecommerceSkeleton({required CpfSeguroScheme s}) {
  Widget block(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: s.surfaceMuted,
          borderRadius: CpfSeguroRadius.all8,
        ),
      );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      block(140, 16),
      const SizedBox(height: 16),
      for (var i = 0; i < 2; i++) ...[
        Row(children: [
          block(56, 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              block(160, 14),
              const SizedBox(height: 6),
              block(90, 12),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CpfSeguroText('Total', style: CpfSeguroType.heading.copyWith(color: s.fg, letterSpacing: 0)),
          CpfSeguroText('R\$ 560,00', style: CpfSeguroType.title.copyWith(color: s.fg)),
        ],
      ),
    ],
  );
}

/// C0 · Botão na loja — o e-commerce embeda o mesmo WalletButton.
class _CheckoutEntryMock extends StatelessWidget {
  const _CheckoutEntryMock();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return HandoffPhoneShell(
      bottomSlot: const CpfSeguroBottomHomeIndicator(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ecommerceSkeleton(s: s),
            const Spacer(),
            CpfSeguroWalletButton(
              variant: CpfSeguroWalletButtonVariant.pay,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// C1–C9 · O checkout de pagamento agora é TELA CHEIA (não sheet) — ver
// `checkout_screens.dart` / [buildCheckoutScreen]. O SDK roda embarcado no
// parceiro; abrir bottom sheet nativo por cima dele é frágil.
