import 'flow_kit.dart' show FlowEntry;
import 'mermaid_view.dart';

/// Fluxos de ONBOARDING minerados do app real de produção
/// (~/Desktop/cpf-seguro-real, branch design-hunter).
///
/// FONTES (paths relativos a lib/ do app real):
/// - Fluxo "entrada":
///   modules/onboarding/ui/view/splash/splash_page.dart
///   modules/onboarding/ui/controller/splash_connectivity_controller.dart
///   modules/onboarding/ui/view/components/update_required_modal.dart
///   modules/onboarding/ui/view/welcome/welcome_page.dart
/// - Fluxo "cadastro (chat)":
///   modules/onboarding/ui/view/onboarding/onboarding_page.dart
///   modules/onboarding/ui/controller/onboarding_controller.dart
///   modules/onboarding/ui/view/onboarding/widgets/onboarding_steps.dart
///   modules/onboarding/ui/view/onboarding/widgets/onboarding_live_input_actions.dart
///   modules/onboarding/ui/view/onboarding/terms_of_use_web_view_page.dart
///   modules/onboarding/ui/view/onboarding/widgets/bottom_sheets/cancel_account_bottom_sheet.dart
///   modules/onboarding/ui/view/onboarding/widgets/bottom_sheets/save_quick_on_boarding_bottom_sheet.dart
///   modules/onboarding/ui/view/onboarding/widgets/address/insert_address_bottomsheet.dart
///   modules/onboarding/ui/view/onboarding/widgets/edit_message.dart
///   modules/onboarding/ui/view/onboarding/widgets/review_data_edit.dart
///   modules/onboarding/ui/view/onboarding/widgets/informative_mother_name.dart
/// - Fluxo "KYC pós-login":
///   modules/home/ui/view/pages/home_body_page.dart (entrada via banner, l.255)
///   modules/onboarding/ui/view/onboarding/kyc/onboarding_kyc_page.dart
///   modules/onboarding/ui/view/onboarding/kyc/bank_account_kyc_page.dart
///   modules/onboarding/ui/view/onboarding/kyc/documents_web_view_page.dart
///   modules/onboarding/ui/controller/kyc_onboarding_controller.dart
/// - Fluxo "new onboarding":
///   modules/new_onboarding/ui/view/pages/new_onboarding_page.dart
///   modules/new_onboarding/ui/controller/new_onboarding_controller.dart
///   modules/new_onboarding/ui/view/widgets/new_onboarding_step_widget.dart
///   modules/new_onboarding/ui/view/widgets/inputs/live_input/new_onboarding_live_input_actions.dart
///   modules/new_onboarding/ui/view/pages/new_onboarding_terms_of_use_web_view_page.dart
///   modules/new_onboarding/ui/view/widgets/bottom_sheets/* (exit_confirmation,
///     time_blocked, unstable_connection, error, edit_message)
///   modules/new_onboarding/ui/view/widgets/level_card/* (level_info, access_level)
///
/// COBERTURA rota → fluxo (modules/common/routes/app_routes.dart):
/// - '/' (splash) ........................... Entrada
/// - '/onboarding/welcome' .................. Entrada
/// - '/onboarding/register' ................. Cadastro (chat)
/// - '/onboarding/terms-of-use' ............. Cadastro (chat) — caixa "Termos de uso"
/// - '/onboarding/account' .................. Cadastro (chat) — seção "conta digital"
/// - '/onboarding/kyc' ...................... KYC pós-login
/// - '/onboarding/kyc-only-liveness' ........ KYC pós-login (ramo "só selfie")
/// - '/onboarding/documents-web-view' ....... KYC pós-login — caixa "Webview de docs"
/// - '/onboarding/bank-account-kyc' ......... KYC pós-login — lane "variante bancária"
///   (rota registrada mas SEM caller no app hoje; mapeada como variante)
/// - '/new-onboarding/register' ............. New onboarding
/// - '/new-onboarding/terms-of-use' ......... New onboarding — caixa "Termos de uso"
///
/// FORA DOS DIAGRAMAS (código morto no app real, sem caller):
/// - onboarding_controller.handlerDigitalAccountStep / ProductSelection
///   (oferta de conta digital dentro do chat) e handlerWhiteListStep.
List<FlowEntry> onboardingFlows() => [
      (
        'Onboarding · entrada',
        'splash, conexão, update e boas-vindas',
        () => const MermaidView(definition: _entradaDef),
        null,
      ),
      (
        'Onboarding · cadastro (chat)',
        'CPF→dados→selfie→docs + conta digital',
        () => const MermaidView(definition: _cadastroChatDef),
        null,
      ),
      (
        'Onboarding · KYC pós-login',
        'docs na webview, localização e biometria',
        () => const MermaidView(definition: _kycDef),
        null,
      ),
      (
        'New onboarding · níveis',
        'chat novo com stepper e sheets de erro',
        () => const MermaidView(definition: _newOnboardingDef),
        null,
      ),
    ];

// ═══════════════════════════════════════════════════════════════════════════
// 1 · ENTRADA — splash ('/') e boas-vindas ('/onboarding/welcome')
// ═══════════════════════════════════════════════════════════════════════════

const _entradaDef = '''
flowchart TD
  START(( )) -->|abrir o app| SPLASH["<b>Splash · /</b><br/>logo + 'carregando...'"]
  SPLASH --> CONEXAO{"tem conexão?"}
  CONEXAO -->|não| SEMCONEXAO["<b>Sem conexão</b><br/>tentar de novo ou fechar o app"]:::err
  SEMCONEXAO -.->|tentar de novo · revalida e segue| CONEXAO
  CONEXAO -->|sim| UPDATE{"update obrigatório?"}
  UPDATE -->|sim| UPDATEMODAL["<b>Atualização obrigatória</b><br/>modal bloqueante → loja"]:::state
  UPDATE -->|não| PUSH2FA{"push de 2FA pendente?"}
  PUSH2FA -->|sim| AUTENTICA["<b>Autentica (passkey/senha)</b><br/>falha vira toast de erro"]:::opt
  AUTENTICA -->|ok| HOME2FA(["→ /home"]):::fim
  PUSH2FA -->|não| PRIMEIRO{"primeiro acesso?"}
  PRIMEIRO -->|não| CONHECIDO["<b>Usuário conhecido</b><br/>CPF salvo → /home · senão → /login"]
  PRIMEIRO -->|sim| WELCOME["<b>Boas-vindas</b><br/>/onboarding/welcome · features + botões"]
  WELCOME -->|Criar conta / Continuar cadastro| CADASTRO["<b>Cadastro (chat)</b><br/>flag newOnboarding decide o chat"]
  CADASTRO --> FIMCADASTRO(["→ fluxo de cadastro"]):::fim

  subgraph LOGINAUTO["DESVIO · LOGIN AUTOMÁTICO NO SPLASH"]
    BIOSPLASH["<b>Splash com biometria</b><br/>Entrar com biometria / com senha"]:::opt
    BIOSPLASH -->|biometria ok| HOMEBIO(["→ home loading"]):::fim
    BIOSPLASH -->|passkey falha| TOASTGOOGLE["<b>Toast Google indisponível</b><br/>cai pro login com senha"]:::err
    TOASTGOOGLE --> LOGINBIO(["→ /login"]):::fim
  end

  subgraph TRANS["ESTADOS TRANSVERSAIS"]
    BOTAOENTRAR["<b>Botão 'Entrar' (welcome)</b><br/>sempre disponível → /login"]:::opt
    RASCUNHO["<b>Rascunho de cadastro</b><br/>muda o CTA pra 'Continuar'"]:::state
  end
''';

// ═══════════════════════════════════════════════════════════════════════════
// 2 · CADASTRO (CHAT CLÁSSICO) — '/onboarding/register', '/onboarding/terms-of-use'
//     + continuação de conta digital ('/onboarding/account')
// ═══════════════════════════════════════════════════════════════════════════

const _cadastroChatDef = '''
flowchart TD
  subgraph FELIZ["CAMINHO FELIZ · CADASTRO RÁPIDO"]
    START(( )) --> CHAT["<b>Chat · /onboarding/register</b><br/>boas-vindas do assistente"]
    CHAT --> RASCUNHO{"rascunho salvo?"}
    RASCUNHO -->|sim| RESTAURAR["<b>Continuar de onde parou?</b><br/>Sim restaura · Não recomeça"]:::state
    RASCUNHO -->|não| CPF["<b>CPF</b><br/>input validado + loading"]
    CPF -->|"elegível (desvios abaixo)"| NOME["<b>Nome completo</b><br/>valida no input · erro inline"]
    NOME --> NOMESOCIAL{"nome social?"}
    NOMESOCIAL -->|sim| INFORMARSOCIAL["<b>Informar nome social</b><br/>input de texto"]:::opt
    NOMESOCIAL -->|não| NASCIMENTO["<b>Data de nascimento</b><br/>valida formato/idade inline"]
    NASCIMENTO --> TERMOS["<b>Termos de uso</b><br/>webview · aceite só no fim do scroll"]
    TERMOS -->|li e concordo| TELEFONE["<b>Telefone</b><br/>checa se já existe na base"]
    TELEFONE -->|envia SMS| SMS["<b>Código SMS</b><br/>OTP + reenviar com timer"]
    SMS -->|código válido| SENHA["<b>Senha</b><br/>regras contra data e CPF"]
    SENHA --> CONFIRMARSENHA["<b>Confirmar senha</b><br/>precisa conferir com a anterior"]
    CONFIRMARSENHA --> REVISAO["<b>Revisão dos dados</b><br/>'Tudo certo' ou editar por campo"]
    REVISAO -->|Tudo certo| SALVANDO["<b>Salvando cadastro</b><br/>loading · erro vira bolha no chat"]:::state
    SALVANDO -->|login automático| SELFIE["<b>Selfie (liveness)</b><br/>enviar agora ou deixar pra depois"]
    SELFIE -->|aprovada| DOCUMENTO["<b>Documento (photo ID)</b><br/>enviar agora ou deixar pra depois"]
    DOCUMENTO -->|aprovado| LOCALIZACAO["<b>Localização</b><br/>já concedida pula o pedido"]
    LOCALIZACAO --> CONTACRIADA["<b>Conta criada</b><br/>em análise + oferta de biometria"]
    CONTACRIADA -->|ativar / talvez depois| FIMFELIZ(["→ home loading"]):::fim
  end

  subgraph DESVIOSCPF["DESVIOS DO CPF (elegibilidade)"]
    CPFJA["<b>CPF já cadastrado</b><br/>mensagem + redirect automático"]:::err
    CPFJA -->|3s| LOGINCPF(["→ /login"]):::fim
    LIVENESS["<b>Conta existe + liveness</b><br/>oferece login por selfie"]:::opt
    LIVENESS -->|facematch ok| BIOMETRIC(["→ /biometric"]):::fim
    LIVENESS -->|falha| LOGINLIVENESS(["→ /login"]):::fim
    INVALIDADA["<b>Conta invalidada</b><br/>revalidação por selfie"]:::err
    INVALIDADA -->|facematch falha| ERRORECONHECIMENTO["<b>Erro de reconhecimento</b><br/>tentar de novo ou e-mail do suporte"]:::err
    WHITELIST["<b>Fora da whitelist</b><br/>oferta de lista de espera"]:::empty
    WHITELIST -->|quero entrar| LISTAESPERA["<b>Nome + telefone</b><br/>inscrição na lista"]
    LISTAESPERA -->|ok / já inscrito / erro| FIMSPLASH(["→ splash"]):::fim
  end
  CPF --> CPFJA
  CPF --> LIVENESS
  CPF --> INVALIDADA
  CPF --> WHITELIST
  INVALIDADA -.->|sucesso retoma no passo do nome| NOME

  subgraph DESVIOSOTP["DESVIOS DE CONTATO E OTP"]
    TELEFONEJA["<b>Telefone já cadastrado</b><br/>botão 'usar outro número'"]:::err
    TELEFONEJA -->|editar| SHEETTELEFONE["<b>Sheet editar telefone</b><br/>revalida · toast se ainda existir"]
    SMSINVALIDO["<b>Código SMS inválido</b><br/>reenviar código (timer)"]:::err
    SMSFALHA["<b>Falha ao enviar código</b><br/>salvar e sair / sair sem salvar"]:::err
    SMSLIMITE["<b>Limite de SMS excedido</b><br/>bolha de limite atingido"]:::err
    SELFIEREPROVADA["<b>Selfie reprovada</b><br/>e-mail do suporte (fluxo rápido)"]:::err
    DOCREPROVADO["<b>Documento reprovado</b><br/>mensagem + tentar de novo"]:::err
  end
  TELEFONE --> TELEFONEJA
  SMS --> SMSINVALIDO
  SMS --> SMSFALHA
  SMS --> SMSLIMITE
  SELFIE --> SELFIEREPROVADA
  DOCUMENTO --> DOCREPROVADO

  subgraph SAIDACHAT["SAÍDA DO CHAT (X ou voltar)"]
    XVOLTAR["<b>X / voltar</b><br/>PopScope intercepta"]:::opt
    XVOLTAR --> SHEETSAIDA["<b>Sheet de saída</b><br/>com rascunho: salvar/sair · sem: sim/não"]
    SHEETSAIDA -->|confirma| LOGINSAIDA(["→ /login"]):::fim
    JASALVO["<b>Cadastro já salvo</b><br/>sheet 'continue depois' ao sair"]:::state
    JASALVO -->|sair| LOGINSALVO(["→ /login"]):::fim
  end

  subgraph CONTADIGITAL["CONTINUAÇÃO · CONTA DIGITAL (/onboarding/account)"]
    DETALHES["<b>Detalhes da conta</b><br/>CTA pós-login abre o chat de conta"]
    DETALHES --> CHATCONTA["<b>Chat · /onboarding/account</b><br/>mesmo chat, fluxo de conta"]
    CHATCONTA --> EMAIL["<b>E-mail</b><br/>checa se já existe na base"]
    EMAIL -->|já existe| EMAILJA["<b>Usar outro e-mail</b><br/>sheet de edição + revalida"]:::err
    EMAIL -->|envia código| EMAILOTP["<b>Código do e-mail</b><br/>OTP + reenviar com timer"]
    EMAILOTP -->|falha de envio| EMAILFALHA["<b>Não deu pra enviar</b><br/>bolha de erro + sair/salvar"]:::err
    EMAILOTP -->|válido| NOMEMAE["<b>Nome da mãe</b><br/>checkbox 'não sei' + sheet informativo"]
    NOMEMAE --> CEP["<b>CEP</b><br/>busca endereço com loading"]
    CEP -->|CEP inválido| CEPERRO["<b>Endereço não achado</b><br/>texto de erro no lugar do endereço"]:::err
    CEP --> SHEETENDERECO["<b>Sheet endereço completo</b><br/>número/complemento · fechar → sheet sair"]
    SHEETENDERECO -->|salvar| PIN["<b>PIN + confirmação</b><br/>4 dígitos · regras contra data"]
    PIN --> REVISAOCONTA["<b>Revisão completa</b><br/>Tudo certo / editar por campo"]
    REVISAOCONTA -->|Tudo certo| SOLICITANDO["<b>Solicitando conta</b><br/>loading no chat"]:::state
    SOLICITANDO -->|erro| SOLICITARERRO["<b>CEP não encontrado / falha</b><br/>bolha de erro no chat"]:::err
    SOLICITANDO -->|docs/selfie só se faltarem| ENVIADA["<b>Solicitação enviada</b><br/>conta em análise + aviso por push"]
    ENVIADA -->|Ok| FIMCONTA(["→ volta (pop)"]):::fim
  end

  subgraph TRANSCHAT["ESTADOS TRANSVERSAIS (qualquer passo)"]
    RASCUNHOLOCAL["<b>Rascunho local</b><br/>progresso salvo a cada passo"]:::state
    BOLHALOADING["<b>Bolha de loading</b><br/>três pontinhos no chat"]:::state
    TOASTCAMPO["<b>Toast 'campo atualizado'</b><br/>após edição na revisão"]:::state
  end
''';

// ═══════════════════════════════════════════════════════════════════════════
// 3 · KYC PÓS-LOGIN — '/onboarding/kyc', '/onboarding/kyc-only-liveness',
//     '/onboarding/documents-web-view' (+ variante '/onboarding/bank-account-kyc')
// ═══════════════════════════════════════════════════════════════════════════

const _kycDef = '''
flowchart TD
  START(( )) -->|"banner na Home · 'termine o cadastro'"| KYCURL{"kycUrl existe?"}
  KYCURL -->|não| TOASTERRO["<b>Toast de erro</b><br/>não deu pra abrir o cadastro"]:::err
  KYCURL -->|sim| PRECISADOCS{"precisa de documentos?"}
  PRECISADOCS -->|sim| CHATKYC["<b>Chat KYC · /onboarding/kyc</b><br/>instruções pras fotos"]
  PRECISADOCS -->|não| SOSELFIE["<b>Chat KYC · só selfie</b><br/>/onboarding/kyc-only-liveness"]
  CHATKYC -->|Tirar fotos| WEBVIEWDOCS["<b>Webview de docs</b><br/>/onboarding/documents-web-view"]
  WEBVIEWDOCS --> FOTOS{"fotos concluídas?"}
  FOTOS -->|não| SEMFOTOS["<b>Não tirou as fotos</b><br/>tentar de novo / salvar e sair"]:::err
  SEMFOTOS -.->|tentar de novo reabre a webview| WEBVIEWDOCS
  SEMFOTOS -->|sair| HOMESAIR(["→ home"]):::fim
  FOTOS -->|"sim (ONBOARDING_FINISHED)"| LOCALIZACAO["<b>Localização</b><br/>pedido de permissão no chat"]
  SOSELFIE -.->|mesmo fluxo, texto ajustado| LOCALIZACAO
  LOCALIZACAO -->|negada| AVISOPERMISSAO["<b>Aviso de permissão</b><br/>segue mesmo sem localização"]:::state
  LOCALIZACAO --> BIODISPONIVEL{"biometria disponível?"}
  AVISOPERMISSAO -.->|segue| BIODISPONIVEL
  BIODISPONIVEL -->|não| SEMBIO["<b>Segue sem biometria</b><br/>pula direto pro fim"]:::state
  BIODISPONIVEL -->|sim| FACEID["<b>Ativar Face ID/biometria</b><br/>ativar / agora não"]
  FACEID -->|falhou| ERROBIO["<b>Erro de biometria</b><br/>mensagem no chat e segue"]:::err
  FACEID --> FINALIZADO["<b>Cadastro finalizado</b><br/>mensagem final no chat"]
  SEMBIO -.->|pula pro fim| FINALIZADO
  ERROBIO -.->|segue| FINALIZADO
  FINALIZADO -->|2s| HOMELOADING(["→ home loading"]):::fim

  subgraph BANCARIA["VARIANTE · CONTA BANCÁRIA (/onboarding/bank-account-kyc · rota sem caller hoje)"]
    KYCBANCO["<b>Chat KYC bancário</b><br/>precisa de mais infos da conta"]:::state
    KYCBANCO -->|fotos ok| AGUARDE["<b>Aguarde a aprovação</b><br/>tudo certo + conta em análise"]
    AGUARDE -->|voltar| HOMEBANCO(["→ home"]):::fim
  end

  subgraph SAIDAKYC["SAÍDA"]
    XTOPO["<b>X no topo</b><br/>sai a qualquer momento"]:::opt
    XTOPO --> HOMEPAGE(["→ /home-page"]):::fim
  end
''';

// ═══════════════════════════════════════════════════════════════════════════
// 4 · NEW ONBOARDING — '/new-onboarding/register', '/new-onboarding/terms-of-use'
// ═══════════════════════════════════════════════════════════════════════════

const _newOnboardingDef = '''
flowchart TD
  START(( )) -->|flag newOnboarding ativa| CHATNOVO["<b>Chat · /new-onboarding/register</b><br/>boas-vindas + card dos níveis 1·2·3"]
  CHATNOVO -->|Começar cadastro| CPF["<b>CPF</b><br/>stepper 1/10 no topo do chat"]
  CPF -->|elegibilidade| ELEGIVEL{"CPF pode cadastrar?"}
  ELEGIVEL -->|já existe| CPFJA["<b>CPF já cadastrado</b><br/>bolha + botão 'Entrar'"]:::err
  CPFJA --> LOGINCPF(["→ /login"]):::fim
  ELEGIVEL -->|continua| NOME["<b>Nome</b><br/>valida no input · erro inline"]
  NOME --> NASCIMENTO["<b>Nascimento</b><br/>marca se é maior de 18"]
  NASCIMENTO --> TERMOS["<b>Termos de uso</b><br/>webview · aceite só no fim do scroll"]
  TERMOS -->|sem internet| CONEXAOINSTAVEL["<b>Sheet conexão instável</b><br/>timer 30s + tentar de novo"]:::err
  CONEXAOINSTAVEL -.->|retry reabre os termos| TERMOS
  TERMOS -->|li e aceito| TELEFONE["<b>Telefone</b><br/>checa se já existe na base"]
  TELEFONE -->|já existe| ERROINLINE["<b>Erro inline no input</b><br/>some ao digitar de novo"]:::err
  TELEFONE -->|envia OTP| SMS["<b>Código SMS</b><br/>OTP + reenviar com timer"]
  SMS -->|inválido| TENTATIVA["<b>Tentativa n de 3</b><br/>erro inline · 3x bloqueia"]:::err
  SMS -->|válido| SENHA["<b>Senha</b><br/>card com regras da senha"]
  SENHA --> CONFIRMARSENHA["<b>Confirmar senha</b><br/>precisa conferir com a anterior"]
  CONFIRMARSENHA -->|2 erros| RECOMECAR["<b>Recomeçar senha</b><br/>botão limpa e volta ao passo 7"]:::err
  RECOMECAR -.->|volta ao passo 7| SENHA
  CONFIRMARSENHA -->|confere| SALVANDON1["<b>Salvando nível 1</b><br/>loading no chat"]:::state
  SALVANDON1 --> CARDN1["<b>Card 'Nível 1 salvo'</b><br/>features do nível + próximos"]
  CARDN1 --> NIVEL2{"seguir pro nível 2?"}
  NIVEL2 -->|deixar pra depois| LOGINDEPOIS(["→ /login"]):::fim
  NIVEL2 -->|continuar| SELFIEN2["<b>Nível 2 · selfie</b><br/>ainda não implementado no app"]:::state
  SELFIEN2 --> FIM((fim)):::fim

  subgraph ERROSSHEET["ERROS EM SHEET (qualquer passo)"]
    BLOQUEIO["<b>Bloqueio por tempo</b><br/>3 OTP/senha errados ou rate limit"]:::err
    INSTAVEL["<b>Conexão instável</b><br/>timer 30s + tentar de novo"]:::err
    ERROVALIDACAO["<b>Erro de validação</b><br/>sheet com 'tentar de novo'"]:::err
    ERRODESCONHECIDO["<b>Erro desconhecido</b><br/>sheet fixo · fechar → /login"]:::err
  end

  subgraph SAIDAEDICAO["SAÍDA E EDIÇÃO"]
    SAIRCADASTRO["<b>Sair do cadastro</b><br/>X/voltar no nível 1 → sheet confirma"]:::opt
    SAIRCADASTRO -->|sair| LOGINSAIR(["→ /login"]):::fim
    EDITARRESPOSTA["<b>Editar resposta</b><br/>sheet de edição + toast de atualizado"]:::opt
  end
''';
