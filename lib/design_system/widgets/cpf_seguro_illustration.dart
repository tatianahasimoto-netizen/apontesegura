import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'cpf_seguro_assets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Illustration token.
///
/// Cada ilustração é um **token semântico** (um NOME) com variantes de tema —
/// `Theme=Light`, `Theme=Dark` (e um futuro `Theme3`). O consumidor referencia
/// PELO NOME e o tema ativo escolhe a variante do asset. Isso facilita a troca
/// dark/light: o arquivo nunca é trocado na mão, o token resolve sozinho.
///
/// Convenção da pasta `assets/illustrations/`:
/// - com tema: `{base}_light.svg` + `{base}_dark.svg`
/// - sem tema: `{base}.svg`
///
/// Pra POPULAR: solte os SVGs seguindo a convenção e adicione UMA linha no
/// registry. O catálogo ainda tem poucas — a estrutura já suporta os pares.
class CpfSeguroIllustration {
  const CpfSeguroIllustration._(this.base, {this.themed = true});

  final String base;
  final bool themed;

  // ── Registry ──────────────────────────────────────────────────────────
  // Sem par de tema (asset único):
  static const fingerprint =
      CpfSeguroIllustration._('fingerprint', themed: false);
  static const phoneApproach =
      CpfSeguroIllustration._('phone-approach', themed: false);
  static const saveQuickOnboarding =
      CpfSeguroIllustration._('save_quick_on_boarding', themed: false);
  static const sadFaceFlatline =
      CpfSeguroIllustration._('sad_face_flatline', themed: false);
  static const securityPhoneFlat =
      CpfSeguroIllustration._('security_phone_flat', themed: false);

  // Pares light/dark (trazidos do app real — assets/illustrations/{base}_{light|dark}.svg).
  static const authentication = CpfSeguroIllustration._('authentication');
  static const config = CpfSeguroIllustration._('config');
  static const dataAnalysis = CpfSeguroIllustration._('data_analysis');
  static const fileNotFound = CpfSeguroIllustration._('file_not_found');
  static const graphics = CpfSeguroIllustration._('graphics');
  static const internetOff = CpfSeguroIllustration._('internet_off');
  static const keyWord = CpfSeguroIllustration._('key_word');
  static const moneyJar = CpfSeguroIllustration._('money_jar');
  static const noData = CpfSeguroIllustration._('no_data');
  static const noFile = CpfSeguroIllustration._('no_file');
  static const noFileFlatline = CpfSeguroIllustration._('no_file_flatline');
  static const noFileFound = CpfSeguroIllustration._('no_file_found');
  static const onlinePayment = CpfSeguroIllustration._('online_payment');
  static const pageNotFound = CpfSeguroIllustration._('page_not_found');
  static const pageNotFoundFlat = CpfSeguroIllustration._('page_not_found_flat');
  static const pix = CpfSeguroIllustration._('pix');
  static const sadFace = CpfSeguroIllustration._('sad_face');
  static const search = CpfSeguroIllustration._('search');
  static const searchEngine = CpfSeguroIllustration._('search_engine');
  static const securityPhone = CpfSeguroIllustration._('security_phone');
  static const success = CpfSeguroIllustration._('success');
  static const successFlatline = CpfSeguroIllustration._('success_flatline');
  static const timerWoman = CpfSeguroIllustration._('timer_woman');
  static const unavailableFile = CpfSeguroIllustration._('unavailable_file');
  static const unavailableFileFlatline =
      CpfSeguroIllustration._('unavailable_file_flatline');
  static const unavailableState = CpfSeguroIllustration._('unavailable_state');
  static const withFiles = CpfSeguroIllustration._('with_files');

  static const List<CpfSeguroIllustration> all = [
    fingerprint,
    phoneApproach,
    saveQuickOnboarding,
    sadFaceFlatline,
    securityPhoneFlat,
    authentication,
    config,
    dataAnalysis,
    fileNotFound,
    graphics,
    internetOff,
    keyWord,
    moneyJar,
    noData,
    noFile,
    noFileFlatline,
    noFileFound,
    onlinePayment,
    pageNotFound,
    pageNotFoundFlat,
    pix,
    sadFace,
    search,
    searchEngine,
    securityPhone,
    success,
    successFlatline,
    timerWoman,
    unavailableFile,
    unavailableFileFlatline,
    unavailableState,
    withFiles,
  ];

  String assetPath({required bool isDark}) => themed
      ? 'assets/illustrations/${base}_${isDark ? 'dark' : 'light'}.svg'
      : 'assets/illustrations/$base.svg';
}

/// CPF SEGURO — recolor brand token-driven das ilustrações.
///
/// As artes foram desenhadas na família de azul **brand** do flavor CPF. Este
/// mapa liga cada hex baked ao step `primary` correspondente (snap ao mais
/// próximo, pois a arte tem 10 azuis e o scale primary ~5). Trocar o flavor =
/// apontar estes `primaryNN` pra paleta do flavor ativo — a arte recolore sem
/// tocar no asset. Cinzas/brancos (neutros) e salmão/amarelo (semânticos) NÃO
/// entram: cor de marca troca, erro/aviso e neutro são invariantes.
class CpfSeguroIllustrationBrand {
  const CpfSeguroIllustrationBrand._();

  static String _hx(Color c) {
    int ch(double v) => (v * 255).round().clamp(0, 255);
    String h(int v) => v.toRadixString(16).padLeft(2, '0');
    return '#${h(ch(c.r))}${h(ch(c.g))}${h(ch(c.b))}';
  }

  /// baked (flavor CPF) → step primary do flavor ativo. Chaves em lowercase.
  static final Map<String, String> ramp = {
    '#002999': _hx(CpfSeguroColors.primary03),
    '#003be0': _hx(CpfSeguroColors.primary04),
    '#003de6': _hx(CpfSeguroColors.primary04),
    '#255df9': _hx(CpfSeguroColors.primary05),
    '#3369ff': _hx(CpfSeguroColors.primary05),
    '#2861ff': _hx(CpfSeguroColors.primary05),
    '#668fff': _hx(CpfSeguroColors.primary06),
    '#99b4ff': _hx(CpfSeguroColors.primary06),
    '#b8caff': _hx(CpfSeguroColors.primary07),
    '#ccdaff': _hx(CpfSeguroColors.primary07),
  };

  static final RegExp _colorRe = RegExp(r'(fill|stroke)="(#[0-9a-fA-F]{6})"');

  /// Aplica o recolor de marca sobre o SVG cru. Idempotente e barato
  /// (microssegundos): só troca hexes de marca conhecidos, resto passa direto.
  static String apply(String svg) => svg.replaceAllMapped(_colorRe, (m) {
        final rep = ramp[m[2]!.toLowerCase()];
        return rep == null ? m[0]! : '${m[1]}="$rep"';
      });
}

/// CPF SEGURO — tamanhos canônicos da ilustração (px).
///
/// O accessory **só dimensiona** — e só nestes degraus. Sem `double` livre: a
/// escala é fixa (consistência > flexibilidade), igual em espírito à escala do
/// [CpfSeguroIconAccessory]. `sm` empty-state compacto, `xl` hero de tela cheia.
enum CpfSeguroIllustrationSize {
  sm(100),
  md(200),
  lg(300),
  xl(400);

  const CpfSeguroIllustrationSize(this.px);

  /// Lado do quadrado em px.
  final double px;
}

/// CPF SEGURO — IllustrationAccessory (átomo STANDALONE).
///
/// Análogo do [CpfSeguroIconAccessory]: a **ilustração pura é o token**
/// ([CpfSeguroIllustration] — um NOME, resolve tema sozinho) e este átomo
/// apenas a **dimensiona**. Por encapsular, tem acesso a TODAS as ilustrações
/// do registry — não existe escape hatch de asset cru; se falta uma arte,
/// adiciona-se o token, não se passa um caminho solto.
///
/// Internamente carrega o SVG multi-cor e **recolore a família de marca por
/// token** ([CpfSeguroIllustrationBrand]) — trocar o flavor recolore a arte sem
/// trocar asset; neutros/semânticos ficam intactos. Load cacheado
/// (`CpfSeguroAssets`) + `SvgPicture.string`.
///
/// ```dart
/// CpfSeguroIllustrationAccessory(illustration: CpfSeguroIllustration.fingerprint),          // lg (300)
/// CpfSeguroIllustrationAccessory(illustration: CpfSeguroIllustration.pix, size: CpfSeguroIllustrationSize.sm),
/// ```
class CpfSeguroIllustrationAccessory extends StatefulWidget {
  const CpfSeguroIllustrationAccessory({
    super.key,
    required this.illustration,
    this.size = CpfSeguroIllustrationSize.lg,
  });

  /// Token da ilustração (obrigatório — o átomo consome, não cria).
  final CpfSeguroIllustration illustration;

  /// Único knob: qual degrau canônico dimensionar.
  final CpfSeguroIllustrationSize size;

  @override
  State<CpfSeguroIllustrationAccessory> createState() =>
      _CpsIllustrationState();
}

class _CpsIllustrationState extends State<CpfSeguroIllustrationAccessory> {
  String? _asset;
  String? _svg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = CpfSeguroTheme.schemeOf(context).isDark;
    final asset = widget.illustration.assetPath(isDark: isDark);
    if (asset == _asset) return;
    _asset = asset;

    // Recolor de marca é sync/barato; o load (via resolver com fallback
    // packages/) é a única parte async e é cacheado em CpfSeguroAssets.
    final cachedRaw = CpfSeguroAssets.cachedSvg(asset);
    if (cachedRaw != null) {
      _svg = CpfSeguroIllustrationBrand.apply(cachedRaw);
      return;
    }
    _svg = null;
    CpfSeguroAssets.loadSvg(DefaultAssetBundle.of(context), asset).then((raw) {
      if (!mounted || _asset != asset) return;
      setState(() => _svg = CpfSeguroIllustrationBrand.apply(raw));
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.illustration.base;
    final px = widget.size.px;
    return CpfSeguroDevInfo(
      component: 'CpfSeguroIllustrationAccessory',
      props: {'name': label, 'size': widget.size.name},
      tokens: [
        widget.illustration.themed
            ? 'asset: ${label}_{light|dark}.svg (tema resolve)'
            : 'asset: $label.svg',
        'brand recolor: primary token-driven',
      ],
      child: _svg == null
          ? _Placeholder(size: px)
          : SvgPicture.string(
              _svg!,
              width: px,
              height: px,
              placeholderBuilder: (_) => _Placeholder(size: px),
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: CpfSeguroColors.neutral10,
        borderRadius: CpfSeguroRadius.all8,
      ),
      child: Text('?',
          style: CpfSeguroType.caption.copyWith(color: CpfSeguroColors.neutral04)),
    );
  }
}
