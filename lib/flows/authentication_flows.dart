import 'flow_kit.dart' show FlowEntry;
import 'mermaid_view.dart';

/// Fluxos de AUTENTICAÇÃO minerados do app real de produção
/// (~/Desktop/cpf-seguro-real, branch design-hunter).
///
/// ── Arquivos minerados ──────────────────────────────────────────────────────
/// lib/main.dart (lookingForRoot → AppBlockedComponent · blur em background ·
///   listeners de push: devicePairingStream + twoFactorAuthStream)
/// lib/modules/common/routes/app_routes.dart
/// lib/modules/authentication/ui/routes/authentication_routes.dart
/// lib/modules/onboarding/ui/view/splash/splash_page.dart
/// lib/modules/authentication/ui/view/authentication/authentication_page.dart
/// lib/modules/authentication/ui/view/login/ambiguous_login_page.dart
/// lib/modules/authentication/ui/view/biometric/biometric_page.dart
/// lib/modules/authentication/ui/view/background_block/background_app_page.dart
/// lib/modules/authentication/ui/view/ambiguous_keyboard/ambiguous_keyboard_bottomsheet.dart
/// lib/modules/authentication/ui/view/forgot_password/{cpf_input,reset_password,
///   confirm_password,forgot_password_otp,password_reset_liveness,successful_reset}_page.dart
/// lib/modules/authentication/ui/view/liveness/{password_reset_liveness_chat,
///   password_reset_liveness_result_loading}_page.dart
/// lib/modules/authentication/ui/view/authentication_webview/authentication_webview_page.dart
/// lib/modules/authentication/ui/view/components/login_page_bottomsheets/*
///   (continue_choice · confirm_replace_profile · choose_how_to_validate_device ·
///   awaiting_answer_device · device_paring_success · one_attempt_left ·
///   user_blocked_by_attempts · user_blocked · existing_account_facematch_login)
/// lib/modules/authentication/ui/view/components/forgot_password_bottomsheets/
///   otp_attempt_left_bottomsheet.dart
/// lib/modules/authentication/ui/view/components/device_pairing_response/
///   device_pairing_neglected_access_component.dart
/// lib/modules/home/ui/view/components/device_pairing_warning_bottomsheet.dart
/// lib/modules/home/ui/view/pages/two_factor_authentication/two_fa_bottomsheet.dart
/// lib/modules/home/ui/view/components/2fa_bottomsheet/two_fa_bottomsheet_confirmation.dart
/// lib/modules/home/ui/view/pages/home_loading_animation/home_loading_animation_page.dart
///
/// ── Cobertura rota → fluxo ──────────────────────────────────────────────────
/// '/' (splash)                          → Auth · splash e sessão
/// '/app-background-lock'                → Auth · splash e sessão
/// '/login'                              → Auth · login
/// '/home' (hub AuthenticationPage)      → Auth · login
/// '/biometric'                          → Auth · login
/// '/cpf-input'                          → Auth · esqueci minha senha
/// '/reset-password'                     → Auth · esqueci minha senha
/// '/confirm-password'                   → Auth · esqueci minha senha
/// '/forgot-password' (OTP)              → Auth · esqueci minha senha
/// '/password-reset-liveness'            → Auth · esqueci minha senha
/// '/sucessful-reset'                    → Auth · esqueci minha senha
/// '/password-reset-liveness-chat'       → Auth · esqueci minha senha (liveness pendente)
/// '/authentication-webview'             → Auth · esqueci minha senha (liveness pendente)
/// '/password-reset-liveness-result-loading' → Auth · esqueci minha senha (liveness pendente)
/// '/new-device-warning'                 → SEM GoRoute (só código comentado no
///   login_page legado); o aviso virou bottomsheet → Auth · device novo + 2FA push
/// '/device-pairing-neglected-access'    → SEM GoRoute; virou bottomsheet
///   (DevicePairingNeglectedAccessComponent) → Auth · device novo + 2FA push
/// '/liveness-chat-validation' · '/liveness-web-view' · '/liveness-result-loading'
///   → declaradas em app_routes.dart mas sem GoRoute e sem uso (rotas mortas)
List<FlowEntry> authenticationFlows() => [
      (
        'Auth · splash e sessão',
        'boot, conexão, update e background lock',
        () => const MermaidView(definition: _splashDef),
        null,
      ),
      (
        'Auth · login',
        'CPF, senha, bloqueios e biometria',
        () => const MermaidView(definition: _loginDef),
        null,
      ),
      (
        'Auth · device novo + 2FA push',
        'pareamento, aviso e confirmação',
        () => const MermaidView(definition: _deviceDef),
        null,
      ),
      (
        'Auth · esqueci minha senha',
        'OTP, redefinição, liveness e sucesso',
        () => const MermaidView(definition: _forgotDef),
        null,
      ),
    ];

// ═══════════════════════════════════════════════════════════════════════════
// 1 · SPLASH E SESSÃO — '/' + '/app-background-lock'
// ═══════════════════════════════════════════════════════════════════════════

const _splashDef = '''
flowchart TD
  START(( )) -->|abrir o app| SPLASH["<b>Splash ( / )</b><br/>logo em fundo primary + 'carregando'"]
  SPLASH --> DECCON{"tem<br/>conexão?"}
  DECCON -->|não| ERRCON["<b>Erro de conexão</b><br/>Tentar novamente · Fechar o app"]:::err
  ERRCON -.->|tentar novamente · volta a checar| DECCON
  DECCON -->|sim| DECUPD{"update<br/>obrigatório?"}
  DECUPD -->|sim| MODUPD["<b>Modal · atualização</b><br/>sem fechar; botão abre a loja"]:::state
  DECUPD -->|não| DECPRIM{"primeiro<br/>acesso?"}
  DECPRIM -->|sim| ONB(["→ Onboarding · boas-vindas"]):::fim
  DECPRIM -->|não| DECCPF{"tem CPF<br/>salvo?"}
  DECCPF -->|não| LOGINFIM(["→ Login ( /login )"]):::fim
  DECCPF -->|sim| HUB["<b>Hub ( /home )</b><br/>avatar + Entrar + atalhos"]
  HUB --> HUBFIM(["→ Auth · login (hub)"]):::fim

  subgraph BIOM["DESVIO · SPLASH COM BIOMETRIA (login automático ativo)"]
    SPLASHBIO["<b>Splash com botões</b><br/>Entrar com biometria · com senha"]:::opt
    SPLASHBIO -->|passkey ok| BIOHOME(["→ Home"]):::fim
    SPLASHBIO -->|falha / Google indisponível| BIOTOAST["<b>Toast + Login</b><br/>cai no /login com senha"]:::err
  end

  subgraph BG["DESVIO · APP EM BACKGROUND (blur lock)"]
    BGSTATE["<b>App em background</b><br/>blur 30 + preto 60% sobre tudo"]:::state
    BGSTATE -->|voltar ao app| LOCK["<b>Lock ( /app-background-lock )</b><br/>logo em fundo primary"]
    LOCK -->|passkey ou senha no teclado ambíguo| BGVOLTA(["→ volta de onde parou"]):::fim
    LOCK -->|falhou / cancelou| LOGOUT["<b>Logout</b><br/>sessão limpa → Splash"]:::err
  end

  subgraph TRANS["ESTADOS TRANSVERSAIS"]
    ROOT["<b>Root / jailbreak</b><br/>AppBlocked no lugar do app inteiro"]:::err
    PUSHSEM["<b>Push 2FA sem login</b><br/>banner no topo → tap → Splash"]:::state
  end
''';

// ═══════════════════════════════════════════════════════════════════════════
// 2 · LOGIN — '/login' + '/home' (hub) + '/biometric'
// ═══════════════════════════════════════════════════════════════════════════

const _loginDef = '''
flowchart TD
  START(( )) --> LOGIN["<b>Login ( /login )</b><br/>logo + campo CPF + Continuar"]
  LOGIN -->|validação inline| CPFINV["<b>CPF inválido</b><br/>erro abaixo do campo"]:::err
  LOGIN -->|validação inline| NAOENC["<b>Usuário não encontrado</b><br/>erro abaixo do campo"]:::err
  NAOENC -.->|criar conta| ONB(["→ Onboarding"]):::fim
  LOGIN -->|Continuar| DECFACE{"conta com<br/>facematch?"}
  DECFACE -->|sim| FACE["<b>Sheet · conta existente</b><br/>entrar com selfie (FaceTec)"]:::opt
  FACE -->|match ok| FACEHOME(["→ Home"]):::fim
  FACE -.->|falha → toast + teclado de senha| TECLADO
  DECFACE -->|não| DECTROCA{"trocou de<br/>usuário?"}
  DECTROCA -->|sim| SHEETCOMO["<b>Sheet · continuar como?</b><br/>Pausar este CPF · Usar este device"]:::state
  SHEETCOMO -->|usar este device| SHEETSUB["<b>Sheet · substituir perfil</b><br/>Continuar · Cancelar"]
  SHEETCOMO -.->|pausar → senha temporária → sheets de pausa| PAUSAFIM(["→ Splash"]):::fim
  SHEETSUB -->|Continuar| TECLADO
  DECTROCA -->|não| TECLADO["<b>Sheet · teclado ambíguo</b><br/>6 dígitos, teclas em pares"]
  TECLADO -->|sem layout| TOASTLAY["<b>Toast · layout não achado</b><br/>erro no teclado seguro"]:::err
  TECLADO -.->|esqueci minha senha| ESQFIM(["→ Auth · esqueci minha senha"]):::fim
  TECLADO -->|Entrar| DECSENHA{"senha<br/>ok?"}
  DECSENHA -.->|senha ok, mas device novo| DEVFIM(["→ Auth · device novo + 2FA push"]):::fim
  DECSENHA -->|sim| DECBIO{"oferecer<br/>biometria?"}
  DECBIO -->|sim| BIOP["<b>Biometria ( /biometric )</b><br/>Ativar passkey · Agora não<br/>toggle 'não mostrar de novo' · falha na ativação → toast"]:::opt
  DECBIO -->|não| HOMEFIM(["→ Home (loading animation)"]):::fim
  BIOP -->|concluiu| HOMEFIM

  subgraph BLOQ["DESVIOS · SENHA ERRADA (sheets de bloqueio)"]
    TOASTINV["<b>Toast · login inválido</b><br/>CPF ou senha incorretos"]:::err
    TOASTINV -->|resta 1 tentativa| ULTIMA["<b>Sheet · última tentativa</b><br/>Redefinir senha · Tentar de novo"]:::err
    ULTIMA -->|errou de novo| TEMPBLQ["<b>Sheet · bloqueio temporário</b><br/>aguarde Xh, volta às HH:MM · Entendi"]:::err
    TEMPBLQ -->|conta bloqueada| CONTABLQ["<b>Sheet · conta bloqueada</b><br/>sad face · Falar com suporte (email)"]:::err
  end
  DECSENHA -->|não| TOASTINV

  subgraph HUBSG["HUB AUTENTICADO ( /home · CPF salvo )"]
    HUB["<b>Hub ( /home )</b><br/>nome + CPF mascarado + Trocar usuário<br/>shimmer enquanto carrega"]
    HUB -->|Entrar / Pausar CPF / Sou eu!| PASSKEY["<b>Passkey ou teclado</b><br/>login automático tenta passkey antes"]
    PASSKEY -->|ok| HUBHOME(["→ Home + atalho"]):::fim
  end
  HUB -.->|trocar usuário| LOGIN
''';

// ═══════════════════════════════════════════════════════════════════════════
// 3 · DEVICE NOVO + 2FA PUSH — pareamento (sheets) + confirmação transacional
// ═══════════════════════════════════════════════════════════════════════════

const _deviceDef = '''
flowchart TD
  START(( )) -->|senha ok, mas device novo| DETECT["<b>Device não reconhecido</b><br/>login detecta troca de aparelho"]:::state
  DETECT --> COMO["<b>Sheet · como validar?</b><br/>Confirmar no antigo · Enviar selfie"]
  COMO --> DECMET{"método?"}
  DECMET -->|enviar selfie| FACETEC["<b>FaceTec · liveness match</b><br/>selfie valida o pareamento"]:::opt
  FACETEC -->|match falhou| TOASTMATCH["<b>Toast · não rolou o match</b><br/>erro de validação facial"]:::err
  DECMET -->|confirmar no device antigo| AGUARDA["<b>Sheet · aguardando resposta</b><br/>timer 120s + polling 6s + 'já aprovei'"]
  AGUARDA -->|negou no antigo| NEGADO["<b>Sheet · acesso negado</b><br/>sad face · Entendi"]:::err
  AGUARDA -->|tempo esgotou| TIMEOUT["<b>Sheet fecha sozinho</b><br/>volta pro login"]:::state
  AGUARDA -->|aprovado| CONFIRMADO["<b>Sheet · device confirmado</b><br/>Ir para o app"]
  FACETEC -->|match ok| CONFIRMADO
  CONFIRMADO -->|falha ao concluir| TOASTPAR["<b>Toast · erro no pareamento</b><br/>não completou o login"]:::err
  CONFIRMADO --> DEVEND(["→ Biometria ou Home"]):::fim

  subgraph ANTIGO["NO DEVICE ANTIGO · PUSH DE PAREAMENTO"]
    PUSHPAR["<b>Push de pareamento</b><br/>chega a qualquer momento"]:::state
    PUSHPAR --> DEVNOVO["<b>Sheet · device novo?</b><br/>modelo + SO + local do pedido"]
    DEVNOVO -->|Confirmar novo device| CONFOK["<b>Sheet · confirmado</b><br/>título muda no próprio sheet"]
    DEVNOVO -->|Manter este device · botão vermelho| MANTIDO["<b>Sheet · mantido</b><br/>novo device fica de fora"]
    DEVNOVO -->|erro na resposta| TOASTRESP["<b>Toast + fecha o sheet</b>"]:::err
  end

  subgraph DUOFA["2FA POR PUSH · CONFIRMAÇÃO DE TRANSAÇÃO"]
    PUSH2FA["<b>Push 2FA</b><br/>payload criptografado (RSA)"]:::state
    PUSH2FA -->|sem login · banner no topo → Splash| SHEET2FA["<b>Sheet · confirmação 2FA</b><br/>logo do cliente + data + pedido"]
    PUSH2FA -->|sem chave privada / decrypt falhou| SEMCHAVE["<b>Toast · notificação indisponível</b>"]:::err
    SHEET2FA -->|desafio| DESAFIO["<b>3 tipos de desafio</b><br/>Sim/Não · escolher número · FaceTec"]
    DESAFIO -->|responder| ENVIADA["<b>Toast · confirmação enviada</b><br/>checa se há mais pedidos na fila"]
    DESAFIO -->|falha ao responder| NAOENV["<b>Toast · não foi possível enviar</b>"]:::err
    SHEET2FA -->|pedido já encerrado| ENCERRADO["<b>Toast · pedido já encerrado</b><br/>sheet fecha sozinho"]:::err
  end
''';

// ═══════════════════════════════════════════════════════════════════════════
// 4 · ESQUECI MINHA SENHA — '/cpf-input' → ... → '/sucessful-reset'
// ═══════════════════════════════════════════════════════════════════════════

const _forgotDef = '''
flowchart TD
  START(( )) -->|esqueci minha senha no teclado ou sheet de última tentativa| CPFIN["<b>CPF ( /cpf-input )</b><br/>digitar CPF + Avançar"]
  CPFIN -->|não existe| NAOENC["<b>Toast · usuário não encontrado</b><br/>permanece na tela"]:::err
  CPFIN -->|erro da API| TOASTAPI["<b>Toast · erro da API</b><br/>mensagem da exceção"]:::err
  CPFIN -->|CPF ok| NOVA["<b>Nova senha ( /reset-password )</b><br/>checklist ao vivo: tamanho, sequência,<br/>dígitos repetidos, relação com CPF"]
  NOVA -->|Avançar| CONFSEN["<b>Confirmar ( /confirm-password )</b><br/>inline: 'senhas não conferem'"]
  CONFSEN -->|falha no envio| TOASTENV["<b>Toast · erro ao enviar código</b><br/>permanece na tela"]:::err
  CONFSEN -.->|cooldown de reenvio trava o botão mm:ss| CONFSEN
  CONFSEN -->|enviar código| OTP["<b>Código ( /forgot-password )</b><br/>OTP 6 dígitos por SMS + Reenviar"]
  OTP -->|código errado| PINERR["<b>Erro inline no PIN</b><br/>campos ficam vermelhos"]:::err
  PINERR -->|limite de tentativas| MUITAS["<b>Sheet · muitas tentativas</b><br/>Começar de novo (→ /login) · Tentar de novo"]:::err
  MUITAS -.->|Tentar de novo| OTP
  OTP -.->|senha reprovada no servidor · toast| NOVA
  OTP -->|Continuar| DECAPLICA{"aplicou<br/>na hora?"}
  DECAPLICA -->|não| LIVE["<b>Liveness ( /password-reset-liveness )</b><br/>validar identidade com selfie (FaceTec)"]:::state
  LIVE -->|selfie falhou / apply falhou| TOASTLIVE["<b>Toast de erro</b><br/>selfie falhou · apply falhou"]:::err
  DECAPLICA -->|sim · toast de sucesso| SUCESSO["<b>Sucesso ( /sucessful-reset )</b><br/>ilustração + botão Entrar"]
  LIVE -->|selfie ok| SUCESSO
  SUCESSO -->|login falhou| VOLTALOGIN["<b>Volta pro /login</b><br/>CPF já preenchido"]:::err
  SUCESSO -->|Entrar| FIMOK(["→ Biometria ou Home"]):::fim

  subgraph PEND["DESVIO · LIVENESS PENDENTE (entrou de novo sem validar)"]
    HOMELOAD["<b>Home loading detecta pendência</b><br/>usuário aguardando liveness"]:::state
    HOMELOAD --> CHAT["<b>Chat ( /password-reset-liveness-chat )</b><br/>bolhas explicam + Tirar fotos"]
    CHAT -->|Tirar fotos| WEBV["<b>Webview ( /authentication-webview )</b><br/>liveness web (cadastro.io)"]
    WEBV -->|terminou| LOADR["<b>Loading ( /password-reset-liveness-result-loading )</b><br/>checa status do usuário"]
    LOADR -->|aprovado| PENDHOME(["→ Home"]):::fim
    WEBV -->|fechou a webview| FECHOU["<b>Fechou a webview</b><br/>chat mostra erro: Tirar de novo · Salvar e sair"]:::err
    FECHOU -.->|Tirar de novo| WEBV
    LOADR -->|reprovado| REPROV["<b>Reprovado no loading</b><br/>toast de aviso → volta pro /login"]:::err
    WEBV -->|URL vazia| URLVAZIA["<b>URL vazia na webview</b><br/>toast 'Unable to get URL'"]:::err
  end
''';
