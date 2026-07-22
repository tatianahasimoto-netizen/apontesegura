import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';

/// Aba INTEGRAÇÃO — acompanha a adoção do DS no app real (cpf-seguro-real).
///
/// Cinco baldes (tabs). Os 3 primeiros são o eixo de INTEGRAÇÃO (transitório);
/// os 2 últimos são DEFINITIONS (por design, fora do cálculo):
/// 1. **Integrado** — o DS é a fonte da verdade no app (usado / token port).
/// 2. **Playbook only** — GAP: no DS, o app ainda não adotou (divergente = app
///    tem bespoke; só-no-DS = gap suave, app usa primitivo cru).
/// 3. **App only** — GAP: nativo do app, CANDIDATO a absorver pro DS.
/// 4. **DS definitions** — só no DS POR DESIGN (SDK/parceiro/cobrand/device/
///    handoff). O app CPF nunca usa. NÃO é gap.
/// 5. **App definitions** — nativo do app POR DESIGN (plataforma/lógica/dev/
///    composição de domínio) que NUNCA vira DS. NÃO é gap.
///
/// Integração % = integrado / (integrado + playbook + app) — exclui definitions.
///
/// SSOT: a lista `_items` abaixo. **A cada alteração no DS ou na integração,
/// mova o item de status aqui** — é o que mantém o tracker vivo.
///
/// Dimensão ortogonal: cada item também carrega a CAMADA da linguagem
/// (token/átomo/molécula/organismo — ver [_Layer]). A tally do topo mostra
/// quanto de cada camada já foi unificado.
///
/// Evolução (2026-07): o app começou como fork manual do DS em
/// `cpf-seguro-real/lib/design_system/`; no Track A essa pasta foi DELETADA e o
/// app passou a consumir o package direto (tokens + átomos + Input/IconButton/
/// AppList). O tracker reflete esse estado.
class ParityScreen extends StatefulWidget {
  const ParityScreen({super.key});

  @override
  State<ParityScreen> createState() => _ParityScreenState();
}

class _ParityScreenState extends State<ParityScreen> {
  _Bucket _bucket = _Bucket.integrated;

  @override
  Widget build(BuildContext context) {
    final items = _items.where((i) => i.status.bucket == _bucket).toList();
    return ColoredBox(
      color: CpfSeguroColors.neutral10,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 32, 40, 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Cabeçalho ──
                Text('Integração · DS × App real',
                    style: CpfSeguroType.title.copyWith(color: CpfSeguroColors.neutral01)),
                const SizedBox(height: 6),
                Text(
                  'Onde cada componente vive hoje e o quanto o app real já adotou o DS. '
                  'O % conta só o que é integrável (exclui definitions).',
                  style: CpfSeguroType.bodyMd.copyWith(color: CpfSeguroColors.neutral04),
                ),
                const SizedBox(height: 24),

                // ── ZONA 1 · RESUMO (painel) — % geral + camadas ──
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CpfSeguroColors.white,
                    borderRadius: CpfSeguroRadius.all16,
                    border: Border.all(color: CpfSeguroColors.neutral09),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusBars(items: _items),
                      const SizedBox(height: 20),
                      Container(height: 1, color: CpfSeguroColors.neutral09),
                      const SizedBox(height: 20),
                      Text('POR CAMADA DA LINGUAGEM',
                          style: CpfSeguroType.labelSm.copyWith(
                              color: CpfSeguroColors.neutral05,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final l in _Layer.values)
                          _LayerTally(
                            layer: l,
                            integrated: _items
                                .where((i) =>
                                    i.layer == l &&
                                    i.status.bucket == _Bucket.integrated)
                                .length,
                            total: _items.where((i) => i.layer == l).length,
                          ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── ZONA 1.5 · ADOÇÃO DE TOKENS (a ponte F1) ──
                const _TokenBridgePanel(),
                const SizedBox(height: 32),

                // ── ZONA 2 · FILTRO — tabs controlam a lista abaixo ──
                Text('FILTRAR POR STATUS',
                    style: CpfSeguroType.labelSm.copyWith(
                        color: CpfSeguroColors.neutral05,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final b in _Bucket.values)
                    _BucketTab(
                      label: b.label,
                      count: _items.where((i) => i.status.bucket == b).length,
                      selected: b == _bucket,
                      onTap: () => setState(() => _bucket = b),
                    ),
                ]),
                const SizedBox(height: 16),

                Text(_bucket.blurb,
                    style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral05, height: 1.4)),
                const SizedBox(height: 24),

                // Cards agrupados por sub-status
                for (final st in _bucket.statuses) ...[
                  if (items.any((i) => i.status == st)) ...[
                    _SubHeader(st, items.where((i) => i.status == st).length),
                    const SizedBox(height: 12),
                    Wrap(spacing: 16, runSpacing: 16, children: [
                      for (final i in items.where((i) => i.status == st)) _ItemCard(i),
                    ]),
                    const SizedBox(height: 28),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Modelo
// ═══════════════════════════════════════════════════════════════════════════

enum _Bucket {
  integrated('Integrado'),
  playbook('Playbook only'),
  app('App only'),
  dsDef('DS definitions'),
  appDef('App definitions');

  const _Bucket(this.label);
  final String label;

  List<_Status> get statuses => switch (this) {
        _Bucket.integrated => const [_Status.used, _Status.tokenPort, _Status.portedIdle],
        _Bucket.playbook => const [_Status.diverging, _Status.playbookOnly],
        _Bucket.app => const [_Status.appOnly],
        _Bucket.dsDef => const [_Status.dsDefinition],
        _Bucket.appDef => const [_Status.appDefinition],
      };

  String get blurb => switch (this) {
        _Bucket.integrated =>
          'DS como fonte da verdade no app. Tokens + átomos + widgets consumidos direto do package; a lib/design_system/ forkada do app foi deletada (Track A).',
        _Bucket.playbook =>
          'GAP de adoção (transitório). "Divergente" = o app tem bespoke fazendo o mesmo. "Só no DS" = gap suave (app usa primitivo cru em vez do componente nomeado).',
        _Bucket.app =>
          'GAP de adoção (transitório). Nativo do app, CANDIDATO a absorver pro DS (ex.: Dropdown, DatePicker que viram palavra nova).',
        _Bucket.dsDef =>
          'DS definitions — vocabulário que existe SÓ no DS POR DESIGN (SDK/parceiro/cobrand/device chrome/handoff). O app CPF nunca usa. NÃO é gap; fora do cálculo de integração.',
        _Bucket.appDef =>
          'App definitions — nativo do app POR DESIGN (plataforma/lógica/dev/composição de domínio) que NUNCA vira DS (não carrega estética compartilhável). NÃO é gap.',
      };
}

enum _Status {
  used,
  tokenPort,
  portedIdle,
  diverging,
  playbookOnly,
  appOnly,
  dsDefinition,
  appDefinition;

  _Bucket get bucket => switch (this) {
        _Status.used || _Status.tokenPort || _Status.portedIdle => _Bucket.integrated,
        _Status.diverging || _Status.playbookOnly => _Bucket.playbook,
        _Status.appOnly => _Bucket.app,
        _Status.dsDefinition => _Bucket.dsDef,
        _Status.appDefinition => _Bucket.appDef,
      };

  String get label => switch (this) {
        _Status.used => 'usado',
        _Status.tokenPort => 'token port',
        _Status.portedIdle => 'portado · sem uso',
        _Status.diverging => 'divergente',
        _Status.playbookOnly => 'só no DS',
        _Status.appOnly => 'só no app',
        _Status.dsDefinition => 'DS definition',
        _Status.appDefinition => 'App definition',
      };

  String get section => switch (this) {
        _Status.used => 'Usado nos módulos',
        _Status.tokenPort => 'Tokens (port renomeado)',
        _Status.portedIdle => 'Portado no fork · sem uso em telas',
        _Status.diverging => 'Divergente · app tem bespoke equivalente',
        _Status.playbookOnly => 'Só no DS · gap suave (app usa primitivo cru)',
        _Status.appOnly => 'Só no app · candidato a absorver pro DS',
        _Status.dsDefinition => 'DS definition · nunca vai pro app (por design)',
        _Status.appDefinition => 'App definition · nunca vai pro DS (por design)',
      };

  (Color, Color) get style => switch (this) {
        _Status.used => (CpfSeguroColors.success07, CpfSeguroColors.success04),
        _Status.tokenPort => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
        _Status.portedIdle => (CpfSeguroColors.warning07, CpfSeguroColors.warning04),
        _Status.diverging => (CpfSeguroColors.warning07, CpfSeguroColors.warning04),
        _Status.playbookOnly => (CpfSeguroColors.secure08, CpfSeguroColors.secure03),
        _Status.appOnly => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
        _Status.dsDefinition => (CpfSeguroColors.neutral09, CpfSeguroColors.neutral03),
        _Status.appDefinition => (CpfSeguroColors.neutral09, CpfSeguroColors.neutral03),
      };
}

/// Camada da linguagem (atomic design). Dimensão ortogonal ao status de
/// integração: token=fonema, átomo=palavra, molécula=frase (gramática de slots,
/// ex. AppList left/middle/right), organismo=oração (appbar, sheet, seção).
enum _Layer {
  token('token'),
  atom('átomo'),
  molecule('molécula'),
  organism('organismo');

  const _Layer(this.label);
  final String label;

  (Color, Color) get style => switch (this) {
        _Layer.token => (CpfSeguroColors.neutral09, CpfSeguroColors.neutral04),
        _Layer.atom => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
        _Layer.molecule => (CpfSeguroColors.secure08, CpfSeguroColors.secure03),
        _Layer.organism => (CpfSeguroColors.success07, CpfSeguroColors.success04),
      };
}

class _Item {
  const _Item(this.name, this.status, {required this.layer, this.ds, this.app, this.note});
  final String name;
  final _Status status;
  final _Layer layer;
  final String? ds; // classe no DS
  final String? app; // classe/nativo no app real
  final String? note;
}

// ═══════════════════════════════════════════════════════════════════════════
// SSOT — mover itens de status aqui a cada iteração
// ═══════════════════════════════════════════════════════════════════════════

const _items = <_Item>[
  // ─── INTEGRATED · usado nos módulos ──────────────────────────────────────
  // Track A (2026-07): lib/design_system/ do app deletada; forks viraram consumo
  // direto do package. Track B: IconButton. P4: Input. Depois: ícones (fonte→SVG,
  // .ttf deletado), ilustração (token↔accessory), AppList (row + coleção v0.19.1).
  _Item('Button', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroButton', app: 'ds.Button', note: 'Track A · fork deletado · consome package · domina o app'),
  _Item('StatusTag', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroStatusTag', app: 'ds.StatusTag', note: 'Track A · fork deletado · consome package'),
  _Item('Checkbox', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroCheckbox', app: 'ds.Checkbox', note: 'Track A · fork deletado · consome package'),
  _Item('Avatar', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroAvatar', app: 'ds.Avatar', note: 'Track A · fork deletado · consome package'),
  _Item('SpotIcon', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroSpotIcon', app: 'ds.SpotIcon', note: 'Track A · fork deletado · consome package'),
  _Item('Field', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroField', app: 'ds.Field (transitivo)', note: 'v0.33 · ÁTOMO-FUNDAÇÃO de input: TextField da plataforma despido de Material (border/fill/padding zero), vestido só de token. Robustez (seleção/IME/autofill/a11y/hint nativo) resolvida UMA vez. Consumido por Input/SearchInput/ChatInput — mata o EditableText+overlay ad-hoc dos três'),
  _Item('Input', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroInput', app: 'ds.Input', note: 'P4 · 54 telas · TextfieldComponent deletado · v0.33 recomposto sobre o átomo Field'),
  _Item('IconButton', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroIconButton', app: 'ds.IconButton', note: 'Track B · ~24 usos · CustomIconButton deletado'),
  _Item('AppListRow', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroAppListRow', app: 'ds.AppListRow', note: 'v0.19.1 · row PURA (sem position) · ~90 usos'),
  _Item('AppList (coleção)', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroAppList', app: 'ds.AppList.carded/.plain/.menu', note: 'v0.19.1 · dona única do separador · ~34 usos · substitui AppListGroup'),
  _Item('InfoCard', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroInfoCard', app: 'ds.InfoCard', note: 'nova palavra (v0.13.0) · InformationCard migrado (14 usos) · consome StatusTag'),
  _Item('IllustrationAccessory', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroIllustrationAccessory', app: 'ds.IllustrationAccessory', note: '52 telas migraram de SvgPicture.asset cru pra ds.IllustrationAccessory (recolor/tema pelo DS). v0.31 add 3 tokens flat (sadFaceFlatline/securityPhoneFlat/saveQuickOnboarding). Fora: 1 banner decorativo (fitHeight) + indireções por String-path'),
  _Item('IconAccessory', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroIconAccessory', app: 'ds.IconAccessory', note: 'átomo base de ícone · transitivo (IconButton/StatusTag/AppList)'),
  _Item('Icon (.vec)', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroIcon', app: 'ds.Icon', note: 'VectorGraphic · resolve via assetPackage no app'),

  // ─── INTEGRATED · tokens (port renomeado) ────────────────────────────────
  _Item('Icons', _Status.used, layer: _Layer.token, ds: 'CpfSeguroIcons', app: 'ds.Icons', note: 'fonte-ícone própria do app DELETADA (.ttf + codepoints) · 100% em ds.Icon SVG · ~202 nomes ds.Icons + 226 renders ds.Icon'),
  _Item('Palette', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroPalette', app: 'ColorsPalette', note: 'valores do DS · 1786 usos'),
  _Item('Colors / Scheme', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroColors · Scheme', app: 'ColorsScheme', note: 'semântico · 11 usos'),
  _Item('Radius', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroRadius', app: 'Radii', note: '299 usos'),
  _Item('Spacing', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroSpacing', app: 'Spacing', note: '2456 usos'),
  _Item('Elevation', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroElevation', app: 'Shadows', note: '29 usos'),
  _Item('Gradients', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroGradients', app: 'Gradients', note: '7 usos'),
  _Item('Typography', _Status.tokenPort, layer: _Layer.token, ds: 'CpfSeguroType', app: 'Display/Body/Label…', note: '07-21 · ponte fechada: text.dart deriva do CpfSeguroType (base M3 alias + copyWith nos deltas). ~44 usos'),
  _Item('Illustrations (token)', _Status.tokenPort, layer: _Layer.token, ds: 'assets', app: 'Illustrations', note: '69 usos'),
  _Item('Motion', _Status.used, layer: _Layer.token, ds: 'CpfSeguroMotion', app: 'ds.Motion', note: 'v0.20 · tokens duração+easing+contexto · app adotou (37 arquivos; Duration/Curves cru de transição -> ds.Motion)'),

  // ─── INTEGRATED · portado no fork, sem uso em telas ──────────────────────
  // VAZIO desde Track A (2026-07): a lib/design_system/ do app foi deletada, então
  // não existe mais "fork portado sem uso". Cada item foi pra 'usado' (integrado
  // de fato) ou pra 'divergente/só no DS' (app usa nativo ou não adotou).

  // ─── PLAYBOOK · divergente (app tem nativo equivalente) ──────────────────
  _Item('Dropdown', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroDropdown', app: 'ds.Dropdown (via DropdownComponent)', note: 'v0.27 · PALAVRA NOVA (campo Input readOnly + chevron → bottomsheet single-select). DropdownComponent delega ds.Dropdown (title vira sheetTitle); call-site insert_pix_key_page intacto'),
  _Item('DatePicker', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroCalendar · CpfSeguroDateField', app: 'ds.Calendar (via CustomDatePickerWidget)', note: 'v0.27 · PALAVRAS NOVAS: Calendar (grid mensal Flutter puro) + DateField. CustomDatePickerWidget delega ds.Calendar (isReversed mapeia limites); saiu do table_calendar (2 pix scheduling sheets)'),
  _Item('Toast', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroToast', app: 'ds.Toast (via ToastComponent)', note: 'Onda A · ToastComponent delega ds.Toast · helper showToast intacto (~101 callers)'),
  _Item('TopAppBar', _Status.used, layer: _Layer.organism, ds: 'CpfSeguroTopAppBar', app: 'ds.TopAppBar.app (via HomeAppBar)', note: 'CHROME (07-21, glass): nova variante .app (glass + inset REAL da status bar, sem o mock StatusBar). Home adota (HomeAppBar → left.home + right.icons; HomeBodyPage extendBodyBehindAppBar). Demais appbars (TitleAppbar etc.) pendentes, caso a caso'),
  _Item('NavigationTopBar', _Status.used, layer: _Layer.organism, ds: 'CpfSeguroNavigationTopBar', app: 'ds.NavigationTopBar (via TopAppBar.app)', note: 'CHROME (07-21): consumido pela TopAppBar.app na home (left.home "Olá, nome" + right.icons olho/sino)'),
  _Item('Nav / BottomApp', _Status.used, layer: _Layer.organism, ds: 'CpfSeguroNav · BottomApp', app: 'ds.Nav.items (via home_page)', note: 'CHROME (07-21, glass): Nav ganhou construtor .items (tabs configuráveis) + CpfSeguroNavItem, mantendo o enum do catálogo. home_page adota (glass + extendBody); CustomBottomNavigationBar DELETADO (e conserta bug latente Icon(String))'),
  _Item('Sheet / Modal', _Status.diverging, layer: _Layer.organism, ds: 'CpfSeguroSheetOverlay', app: 'CustomBottomsheet · Modal', note: 'close-button interno já é ds.CpfSeguroIconButton (Track B)'),
  _Item('Logo', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroLogo', app: 'ds.Logo (via LogoComponent)', note: 'Onda A · LogoComponent delega ds.Logo'),
  _Item('StatusBanner', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroStatusBanner', app: 'ds.StatusBanner (via CpfProtectionStatusCardComponent)', note: 'decisão 07-21 (ds): app adota o DS; status-dot e info-pills SAÍRAM. Mapeia status→eyebrow, verificado/pausado (+instituições)→footnote, pausar/reativar→StatusBannerButton'),
  _Item('PromoBanner', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroPromoBanner', app: 'ds.PromoBanner (via BannerComponent)', note: 'BannerComponent delega ds.PromoBanner (light/solid); illustrations:String -> illustration:enum, lightMode->variant. 2 call-sites'),
  _Item('NoticeBanner', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroNoticeBanner', app: 'ds.NoticeBanner (via HomeBannerComponent)', note: 'v0.30 · PALAVRA NOVA (card claro de estado da conta + botao-icone). HomeBannerComponent delega; image:String -> illustration:enum (3 call-sites)'),
  _Item('PasswordBottomSheet', _Status.playbookOnly, layer: _Layer.organism, ds: 'CpfSeguroPasswordBottomSheet', note: 'F3 (07-21): PasswordComponent (bespoke divergente) era CÓDIGO MORTO (sem call-site) — DELETADO. O DS usa numpad+pin dots; a confirmação de senha do app hoje passa pelos fluxos de PIN (ds.OtpInput). Gap suave: adotar o sheet do DS onde fizer sentido'),
  _Item('SdkScreen / TemplatePage', _Status.diverging, layer: _Layer.organism, ds: 'CpfSeguroSdkScreen', app: 'TemplatePage'),
  _Item('EmptyState', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroEmptyState', app: 'ds.EmptyState (via GenericError/ConnectionError)', note: 'Onda A · GenericErrorComponent + UserConnectionErrorComponent delegam ds.EmptyState'),
  _Item('OtpInput', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroOtpInput', app: 'ds.OtpInput (via AutoFocusPinCodeTextField)', note: 'v0.24 interativo · wrapper delega (13 telas de PIN; validator via FormField)'),
  _Item('ToggleSwitch', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroToggleSwitch', app: 'ds.ToggleSwitch', note: 'Onda A · ToggleSwitchButtonComponent delega. F2 (07-21): último Switch Material cru (biometric_page) trocado por ds.ToggleSwitch direto (cores do DS). 0 Switch cru restante'),
  _Item('LoadingSpinner', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroLoadingSpinner', app: 'ds.LoadingSpinner', note: 'Onda A · spinner delegado. F2 (07-21): 3 CircularProgressIndicator crus (history 2fa + 2 edit_message) trocados por ds.LoadingSpinner. 0 spinner circular cru restante'),
  _Item('Skeleton + Shimmer', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroSkeleton · CpfSeguroShimmer', app: 'ds via ShimmerLoading/Box', note: 'palavra NOVA (v0.22) · Skeleton (forma) + Shimmer (efeito, loop Motion.shimmer). Absorve o MenuItem-zumbi (que só era skeleton)'),
  _Item('InputChip', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroInputChip', app: 'ds.InputChip (via FilterChipComponent)', note: 'decisão 07-21: raio+cor do DS (pill primary, filled=selecionado), ÍCONE do app. DS ganhou iconSize. FilterChipComponent delega'),
  _Item('InfoChip', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroInfoChip', app: 'ds.InfoChip (via ChipInfoWidget)', note: 'palavra NOVA (v0.25) · pill decorativo light/onColor. Absorve o ChipInfoWidget (badge sobre superfície colorida) — distinto de StatusTag (semântico) e InputChip (filtro)'),

  // ─── PLAYBOOK · só no DS ─────────────────────────────────────────────────
  _Item('MenuButton', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroMenuButton', app: 'ds.MenuButton.tile (via PixMenuComponent)', note: 'decisão 07-21: um word, variantes. DS ganhou variante tile (card sólido 97×97) além do nav-item. PixMenuComponent delega'),
  _Item('Action', _Status.playbookOnly, layer: _Layer.atom, ds: 'CpfSeguroAction', note: 'fork deletado no Track A'),
  _Item('GlassSurface', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroGlassSurface', app: 'ds (via Nav/TopAppBar glass)', note: 'CHROME (07-21): consumido pelas barras glass adotadas no app (bottom nav + top bar da home). Branco alpha 80% + BackdropFilter blur 10'),
  _Item('Illustration (widget)', _Status.playbookOnly, layer: _Layer.atom, ds: 'CpfSeguroIllustration', note: 'token já integrado; widget recolor no DS, app renderiza SVG próprio'),
  _Item('AmountDisplay', _Status.playbookOnly, layer: _Layer.molecule, ds: 'CpfSeguroAmountDisplay', note: 'decisão 07-21 (app): DS redesenhado com hero + onTap/chevron. Mas BalanceComponent (alvo) está SEM call-site ativo → sem adoção por ora. Obscure/format/loading ficam no consumidor quando adotar'),
  _Item('Amount', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroAmount', app: 'ds.Amount', note: 'cashIn chip verde / cashOut − / cashBack tachado / obscured · usado nas linhas de pagamento (BasicPaymentItem) via right.amount'),
  _Item('ChatBubble', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroChatBubble', app: 'ds via onboarding', note: 'bolha-visual dos 2 onboardings delega (from + tone); ganhou tone alert v0.26'),
  _Item('ChatCompletionCard', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroChatCompletionCard', app: 'ds.ChatCompletionCard (via AccessLevelCardWidget)', note: 'v0.32 · DS ganhou primary opcional + slot nextLevel; AccessLevelCardWidget (new_onboarding) delega (expansível no nextLevel, CTAs condicionais)'),
  _Item('ChatCriteriaBubble', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroChatCriteriaBubble', app: 'ds.ChatCriteriaBubble', note: 'os 2 onboardings delegam a bolha de criterios de senha (PasswordEditComponent); validacao/gating do botao intactos'),
  _Item('CriteriaList', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroCriteriaList', app: 'ds.CriteriaRow (via PasswordRequirement)', note: 'EXTRAÍDO do ChatCriteriaBubble (v0.23) · marker ok/fail/pending · consumido pelo bubble, PasswordBottomSheet e PasswordRequirement do app'),
  _Item('ChatInput', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroChatInput', app: 'ds.ChatInput (via InputTextLive + NewOnboardingLiveInputWidget)', note: 'v0.33 · recomposto sobre o átomo Field (TextField despido de Material). Os 2 campos de cadastro (onboarding antigo + novo) delegam; orquestração auth (validação, dança de teclado, obscure, merge de erro server, gate de send) fica no wrapper. Validação visual pendente'),
  _Item('ChatTypingIndicator', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroChatTypingIndicator', app: 'ds via onboarding (typing bubble)', note: 'adotado nos 2 chats de onboarding (antigo + new)'),
  _Item('CheckoutSheet', _Status.dsDefinition, layer: _Layer.organism, ds: 'CpfSeguroCheckoutSheet'),
  _Item('CobrandEyebrow', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroCobrandEyebrow'),
  _Item('CobrandMark', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroCobrandMark'),
  _Item('CobrandedBadge', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroCobrandedBadge'),
  _Item('DetailRow', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroDetailRow', app: 'ds.DetailRow (via ReceiptInfoRow)', note: 'decisão 07-21 (app): DS virou HORIZONTAL (label esq / valor dir). ReceiptInfoRow (comprovante pix) delega'),
  _Item('FaceIdCard', _Status.dsDefinition, layer: _Layer.molecule, ds: 'CpfSeguroFaceIdCard'),
  _Item('FeatureCard', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroFeatureCard', app: 'ds.FeatureCard (via QuickAccessCardWithStatusComponent)', note: 'decisão 07-21 (app): DS redesenhado no look do app (surface branca + tile 34 state-color + status em OVERLAY via slot statusOverlay). QuickAccess delega; máquina de estado fica no wrapper (alimenta brandColor + overlay)'),
  _Item('FeatureDetailCard', _Status.dsDefinition, layer: _Layer.molecule, ds: 'CpfSeguroFeatureDetailCard', note: 'app não tem bespoke maior · feature-detail já usa ds.InfoCard (cpf_seguro_info_page)'),
  _Item('JourneyStep', _Status.playbookOnly, layer: _Layer.molecule, ds: 'CpfSeguroJourneyStep'),
  _Item('Keyboard', _Status.dsDefinition, layer: _Layer.organism, ds: 'CpfSeguroKeyboard'),
  _Item('NavigationButton', _Status.playbookOnly, layer: _Layer.atom, ds: 'CpfSeguroNavigationButton', note: 'DIVERGENTE + colisão de nome: DS é pilha de CTAs full-width (footer de bottom-app); PixConfigMenuComponent é linha settings (título/subtítulo + chevron + divider) e está SEM call-site (código morto). Não é o mesmo word'),
  _Item('OfflinePill', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroOfflinePill', note: 'app não tem pill · perda de conexão vira página/sheet (ds.EmptyState wifi-light)'),
  _Item('PageTitle', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroPageTitle', app: 'ds.PageTitle (~20 telas)', note: 'decisão 07-21 (ds): sweep aplicado — ~19 blocos título(+subtítulo) abaixo-do-appbar (info pages, security, change-password, notifications, delete-profile, profile, charge) delegam ds.PageTitle. Excluídos heroes/appbar/bottom-sheets/empty-states'),
  _Item('PartnerButton', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroPartnerButton'),
  _Item('PaymentSheet', _Status.dsDefinition, layer: _Layer.organism, ds: 'CpfSeguroPaymentSheet'),
  _Item('ProgressBar', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroProgressBar', app: 'ds.ProgressBar.activity · .value', note: 'InstitutionProgressComponent (2fa) delega .activity. F2 (07-21): DS ganhou variante .value (progresso CONTÍNUO 0..1) — o LinearProgressIndicator cru do pix loading (spring no controller) agora delega .value. 0 LinearProgressIndicator cru restante. Stepper segmentado do onboarding segue bespoke'),
  _Item('ProgressRing', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroProgressRing', app: 'ds via left.progressRing', note: 'anel de progresso circular + label · consumido por left.progressRing (sou_eu serviço)'),
  _Item('QuickAccessCard', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroQuickAccessCard', app: 'ds.QuickAccessCard (via QuickAccessCardComponent)', note: 'QuickAccessCardComponent delega ds.QuickAccessCard (look do DS: chip branco/borda + pílula); grid da home virou Wrap de chips 75×84'),
  _Item('RadioList', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroRadioList', app: 'ds.RadioList (via _listOfReasons)', note: 'F3 (07-21): a lista de motivos de pausa do CPF (cpf_seguro_page) delega ds.RadioList (IncidentType↔String pelo .value; campo custom condicional preservado). As listas de ocupação (onboarding) seguem bespoke — lista longa buscável em ListView.builder, não é o caso de uso do RadioList (Column sem virtualização)'),
  _Item('Receipt', _Status.playbookOnly, layer: _Layer.organism, ds: 'CpfSeguroReceipt'),
  _Item('SearchInput', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroSearchInput', app: 'ds.SearchInput', note: 'v0.29 · SearchInput robusto (controller opcional + placeholder). 6 campos de busca migraram; 3 com rightAccessory/keyboardType seguem CpfSeguroInput. v0.33 recomposto sobre o átomo Field'),
  _Item('SectionHeader', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroSectionHeader', app: 'ds.SectionHeader (7 headings)', note: 'decisão 07-21 (ds): sweep aplicado — 7 headings acima-de-lista (contatos pix, pix home menu/others, manage_service, shared_contact_details, activities_list) delegam ds.SectionHeader (label caps). Empty-states/appbar/card-internal excluídos'),
  _Item('SeeAllLink', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroSeeAllLink', app: 'ds.SeeAllLink (via _seeAllButton)', note: 'decisão 07-21 (ds): app adota o text-link do DS. _seeAllButton (contatos pix) era botão-ícone circular 48px, virou ds.SeeAllLink'),
  _Item('StatusBar', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroStatusBar'),
  _Item('Stepper', _Status.dsDefinition, layer: _Layer.molecule, ds: 'CpfSeguroStepper', note: 'app não tem +/- numérico · o "stepper" do onboarding é barra de progresso segmentada (vira ProgressBar)'),
  _Item('Tooltip', _Status.used, layer: _Layer.atom, ds: 'CpfSeguroTooltip', app: 'ds.Tooltip', note: 'F2 (07-21): DS tem modo INTERATIVO (param child) — embrulha o child no engine do Tooltip da plataforma vestido com a estética do chip. sharing_sou_eu delegou; 0 Tooltip cru restante'),
  _Item('WalletButton', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroWalletButton', note: 'app não tem botão wallet · ações usam ds.Button'),
  _Item('WalletCard', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroWalletCard', app: 'ds.WalletCard.pixSplash (via PixNfcCardComponent)', note: 'v0.33 · DS ganhou variante .pixSplash (fundo primary + mark 68 branco + mark Pix, responsivo AspectRatio 2). PixNfcCardComponent delega (2 call-sites: wallet_page + pix_nfc_reading_page)'),
  _Item('WalletCardStack', _Status.dsDefinition, layer: _Layer.organism, ds: 'CpfSeguroWalletCardStack', note: 'app não tem pilha de cartões'),
  _Item('BiometriaOverlay', _Status.diverging, layer: _Layer.organism, ds: 'CpfSeguroBiometriaOverlay', app: 'fluxo biometria (bespoke)'),
  _Item('ExitConfirmSheet', _Status.playbookOnly, layer: _Layer.organism, ds: 'CpfSeguroExitConfirmSheet'),
  _Item('BottomHomeIndicator', _Status.dsDefinition, layer: _Layer.atom, ds: 'CpfSeguroBottomHomeIndicator'),

  // ─── APP ONLY ────────────────────────────────────────────────────────────
  // Triagem 2026-07 (critério: estética -> DS). Dois grupos:
  //  (a) NATIVO PERMANENTE — lógica/plataforma/dev, sem estética própria.
  //  (b) ALVO DE ENRIQUECIMENTO — carrega estética, vira DS (nota "-> DS").
  _Item('WebView', _Status.appDefinition, layer: _Layer.organism, app: 'WebViewComponent', note: 'NATIVO — wrapper de plataforma (inappwebview). chrome consome DS'),
  _Item('QR code', _Status.appDefinition, layer: _Layer.molecule, app: 'QrCodePage', note: 'NATIVO — câmera/scanner de plataforma'),
  _Item('Development flag', _Status.appDefinition, layer: _Layer.atom, app: 'DevelopmentFlagComponent', note: 'NATIVO — tooling de dev, não vai pro shipping'),
  _Item('Period filter', _Status.appDefinition, layer: _Layer.molecule, app: 'PeriodFilterButtonComponent', note: 'common/widgets/filter/'),
  _Item('App blocked', _Status.appDefinition, layer: _Layer.organism, app: 'AppBlockedComponent', note: 'common/widgets/app_blocked/'),
  _Item('Connection error', _Status.used, layer: _Layer.molecule, ds: 'CpfSeguroEmptyState', app: 'ds.EmptyState (via UserConnectionError)', note: 'Onda A · delega EmptyState'),
  _Item('Locale wrapper', _Status.appDefinition, layer: _Layer.atom, app: 'LocaleWrapperRestart', note: 'NATIVO — mecanismo de i18n (restart), sem estética própria'),
];

// ═══════════════════════════════════════════════════════════════════════════
// ADOÇÃO DE TOKENS — a ponte (F1)
// ═══════════════════════════════════════════════════════════════════════════
//
// Dimensão de token vista de perto: cada camada de token do app (ColorsPalette,
// Spacing…) é um ALIAS FINO que lê o valor do DS, ou ainda um FORK (valor
// literal próprio, sem importar o DS)? Diagnóstico 2026-07-21 (F1). Enquanto os
// _items acima rastreiam "que palavras o app adotou", isto rastreia "a fonte da
// verdade do valor do token" — nome legado preservado, valor vindo do package.

enum _BridgeState {
  bridged('ponte', 'lê o valor do DS (alias fino)'),
  partial('ponte parcial', 'ligado ao DS + poucos literais app-only sem par'),
  fork('fork', 'valor literal próprio · não importa o DS');

  const _BridgeState(this.label, this.blurb);
  final String label;
  final String blurb;

  (Color, Color) get style => switch (this) {
        _BridgeState.bridged => (CpfSeguroColors.success07, CpfSeguroColors.success04),
        _BridgeState.partial => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
        _BridgeState.fork => (CpfSeguroColors.warning07, CpfSeguroColors.warning04),
      };
}

class _TokenBridge {
  const _TokenBridge(
    this.name, {
    required this.app,
    required this.ds,
    required this.state,
    required this.match,
    required this.sites,
    this.note,
  });
  final String name;
  final String app; // camada de token no app
  final String ds; // fonte no package
  final _BridgeState state;
  final String match; // paridade de valor ("1:1" · "—")
  final String sites; // call-sites aproximados
  final String? note;
}

// SSOT da ponte de token. Mover state/valores aqui a cada mudança no bridge.
const _tokenBridge = <_TokenBridge>[
  _TokenBridge('Cor (paleta)',
      app: 'ColorsPalette', ds: 'CpfSeguroColors', state: _BridgeState.bridged, match: '1:1', sites: '~1407',
      note: 'doc da classe diz literalmente "Bridge de tokens de cor → DS". Aliases const 1:1 (colorsPaletteBlack = CpfSeguroColors.black)'),
  _TokenBridge('Roles (scheme)',
      app: 'ColorsScheme', ds: 'CpfSeguroScheme', state: _BridgeState.bridged, match: 'projetado', sites: '~11',
      note: 'ColorsScheme.light/dark projetados do CpfSeguroScheme via _fromDs (light/dark sem fork)'),
  _TokenBridge('Spacing',
      app: 'Spacing', ds: 'CpfSeguroSpacing', state: _BridgeState.partial, match: '1:1', sites: '~2213',
      note: 'escala aliasada (x16 = CpfSeguroSpacing.s4). Resíduo app-only sem par no DS: x56/x120/x200 — normalizar no DS depois'),
  _TokenBridge('Radius',
      app: 'Radii', ds: 'CpfSeguroRadius', state: _BridgeState.partial, match: '1:1', sites: '~233',
      note: 'aliasado ao DS. Resíduo app-only sem par: x10/x12/x20/x36 — normalizar depois'),
  _TokenBridge('Elevation',
      app: 'Shadows', ds: 'CpfSeguroElevation', state: _BridgeState.bridged, match: '1:1', sites: '~16',
      note: 'soft = CpfSeguroElevation.subtle (re-export das receitas de sombra)'),
  _TokenBridge('Gradients',
      app: 'Gradients', ds: 'CpfSeguroGradients', state: _BridgeState.bridged, match: '1:1', sites: '~7',
      note: 'brandLift = CpfSeguroGradients.brandLift'),
  _TokenBridge('Tipografia',
      app: 'Display/Body/Label…', ds: 'CpfSeguroType', state: _BridgeState.partial, match: '1:1', sites: '~44',
      note: '07-21 · ponte fechada: text.dart deriva do CpfSeguroType (base M3 alias direto; variantes Prominent + letter-spacing semântico via copyWith). Overline segue app-local (diverge do DS: 10/w400 vs 11/w700). Família SFProRounded preservada pelo tema'),
];

// ═══════════════════════════════════════════════════════════════════════════
// UI
// ═══════════════════════════════════════════════════════════════════════════

/// Barras de progresso da integração: uma stacked "Geral" (une os 3 baldes) +
/// uma por balde (fração do total).
class _StatusBars extends StatelessWidget {
  const _StatusBars({required this.items});
  final List<_Item> items;

  int _count(_Bucket b) => items.where((i) => i.status.bucket == b).length;

  static Color _color(_Bucket b) => switch (b) {
        _Bucket.integrated => CpfSeguroColors.success04,
        _Bucket.playbook => CpfSeguroColors.warning04,
        _Bucket.app => CpfSeguroColors.primary04,
        _Bucket.dsDef => CpfSeguroColors.neutral05,
        _Bucket.appDef => CpfSeguroColors.neutral07,
      };

  @override
  Widget build(BuildContext context) {
    final total = items.length;
    final integ = _count(_Bucket.integrated);
    final play = _count(_Bucket.playbook);
    final app = _count(_Bucket.app);
    // "Integrável" exclui as definitions (por design, fora do escopo).
    final inScope = integ + play + app;
    final pct = inScope == 0 ? 0 : (integ * 100 / inScope).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero: % integrado do que é INTEGRÁVEL (exclui definitions).
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('$pct%',
                style: CpfSeguroType.title.copyWith(
                    color: CpfSeguroColors.success04, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Text('integrado',
                style: CpfSeguroType.bodyMd.copyWith(color: CpfSeguroColors.neutral03)),
            const Spacer(),
            Text('$integ de $inScope integráveis · $total no total',
                style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ],
        ),
        const SizedBox(height: 12),
        // Barra empilhada dos 3 baldes integráveis.
        ClipRRect(
          borderRadius: CpfSeguroRadius.all200,
          child: SizedBox(
            height: 12,
            child: Row(children: [
              if (integ > 0)
                Expanded(flex: integ, child: ColoredBox(color: _color(_Bucket.integrated))),
              if (play > 0)
                Expanded(flex: play, child: ColoredBox(color: _color(_Bucket.playbook))),
              if (app > 0)
                Expanded(flex: app, child: ColoredBox(color: _color(_Bucket.app))),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        // Legenda compacta (só os 3 integráveis; definitions ficam nas tabs).
        Wrap(spacing: 20, runSpacing: 6, children: [
          _legend(_Bucket.integrated, integ),
          _legend(_Bucket.playbook, play),
          _legend(_Bucket.app, app),
        ]),
      ],
    );
  }

  Widget _legend(_Bucket b, int n) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: _color(b), borderRadius: CpfSeguroRadius.all200),
        ),
        const SizedBox(width: 7),
        Text('${b.label} · $n',
            style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral03)),
      ]);
}

class _BucketTab extends StatelessWidget {
  const _BucketTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.white,
            borderRadius: CpfSeguroRadius.pillAll,
            border: Border.all(
              color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.neutral08,
            ),
          ),
          child: Row(children: [
            Text(label,
                style: CpfSeguroType.labelMd.copyWith(
                  color: selected ? CpfSeguroColors.white : CpfSeguroColors.neutral03,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: selected ? CpfSeguroColors.white : CpfSeguroColors.neutral09,
                borderRadius: CpfSeguroRadius.pillAll,
              ),
              child: Text('$count',
                  style: CpfSeguroType.labelSm.copyWith(
                    color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.neutral04,
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader(this.status, this.count);
  final _Status status;
  final int count;
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = status.style;
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
        child: Text(status.label, style: CpfSeguroType.labelSm.copyWith(color: fg)),
      ),
      const SizedBox(width: 10),
      Text(status.section.toUpperCase(),
          style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral03)),
      const SizedBox(width: 8),
      Text('$count',
          style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral05)),
    ]);
  }
}

class _LayerTally extends StatelessWidget {
  const _LayerTally({required this.layer, required this.integrated, required this.total});
  final _Layer layer;
  final int integrated;
  final int total;
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = layer.style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.pillAll,
        border: Border.all(color: CpfSeguroColors.neutral08),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(layer.label,
            style: CpfSeguroType.labelMd.copyWith(color: CpfSeguroColors.neutral03, fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Text('$integrated/$total integrados',
            style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
      ]),
    );
  }
}

class _LayerPill extends StatelessWidget {
  const _LayerPill(this.layer);
  final _Layer layer;
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = layer.style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
      child: Text(layer.label,
          style: CpfSeguroType.labelSm.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard(this.item);
  final _Item item;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = item.status.style;
    return Container(
      width: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _LayerPill(item.layer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(item.name,
                style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral01)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
            child: Text(item.status.label,
                style: CpfSeguroType.labelSm.copyWith(color: fg)),
          ),
        ]),
        if (item.note != null) ...[
          const SizedBox(height: 4),
          Text(item.note!,
              style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.45)),
        ],
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: CpfSeguroColors.neutral10,
            borderRadius: CpfSeguroRadius.all8,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (item.ds != null)
              Text('DS  ·  ${item.ds}',
                  style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.primary04)),
            if (item.app != null)
              Padding(
                padding: EdgeInsets.only(top: item.ds != null ? 2 : 0),
                child: Text('APP  ·  ${item.app}',
                    style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
              ),
          ]),
        ),
      ]),
    );
  }
}

/// Painel da ADOÇÃO DE TOKENS (F1): quantas camadas de token do app já leem o
/// valor do DS (ponte) vs ainda são fork. Hero = "ligados/total".
class _TokenBridgePanel extends StatelessWidget {
  const _TokenBridgePanel();

  @override
  Widget build(BuildContext context) {
    final total = _tokenBridge.length;
    final linked = _tokenBridge.where((t) => t.state != _BridgeState.fork).length;
    final pct = total == 0 ? 0 : (linked * 100 / total).round();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('ADOÇÃO DE TOKENS · A PONTE',
                  style: CpfSeguroType.labelSm.copyWith(
                      color: CpfSeguroColors.neutral05,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
              const Spacer(),
              Text('$linked/$total',
                  style: CpfSeguroType.title.copyWith(
                      color: CpfSeguroColors.success04, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text('ligados ($pct%)',
                  style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Cada camada de token do app é um alias fino que lê o valor do DS (ponte), '
            'ou ainda um fork (valor literal próprio). Nome legado preservado — o valor '
            'passa a vir do package sem tocar nos call-sites.',
            style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.45),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 16, children: [
            for (final t in _tokenBridge) _TokenBridgeCard(t),
          ]),
        ],
      ),
    );
  }
}

class _TokenBridgeCard extends StatelessWidget {
  const _TokenBridgeCard(this.item);
  final _TokenBridge item;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = item.state.style;
    return Container(
      width: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CpfSeguroColors.neutral10,
        borderRadius: CpfSeguroRadius.all16,
        border: Border.all(color: CpfSeguroColors.neutral09),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(item.name,
                style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral01)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
            child: Text(item.state.label,
                style: CpfSeguroType.labelSm.copyWith(color: fg)),
          ),
        ]),
        const SizedBox(height: 8),
        // app → ds (a direção da ponte)
        Row(children: [
          Flexible(
            child: Text('APP  ${item.app}',
                style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05),
                overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text('→', style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral06)),
          ),
          Flexible(
            child: Text('DS  ${item.ds}',
                style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.primary04),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          _MiniStat('valor', item.match),
          const SizedBox(width: 16),
          _MiniStat('call-sites', item.sites),
        ]),
        if (item.note != null) ...[
          const SizedBox(height: 10),
          Text(item.note!,
              style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04, height: 1.45)),
        ],
      ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label ',
          style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral06)),
      Text(value,
          style: CpfSeguroType.labelSm.copyWith(
              color: CpfSeguroColors.neutral02, fontWeight: FontWeight.w700)),
    ]);
  }
}
