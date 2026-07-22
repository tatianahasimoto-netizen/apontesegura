import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_action.dart';
import 'cpf_seguro_amount.dart';
import 'cpf_seguro_avatar.dart';
import 'cpf_seguro_checkbox.dart';
import 'cpf_seguro_icon_accessory.dart';
import 'cpf_seguro_spot_icon.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_icon_button.dart';
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_status_tag.dart';
import 'cpf_seguro_toggle_switch.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// # AppList
///
/// Row canônica do DS, sempre composta por 3 slots:
///
/// ```
/// [ Left ] [ Middle (expanded) ] [ Right ]
/// ```
///
/// Cada slot é uma sealed class com **named constructors** — cada variante
/// suportada vira uma factory `const`. A rule é: qualquer conteúdo dentro
/// dos slots é UMA das variantes fornecidas, ou `.custom(child: ...)` como
/// escape hatch.
///
/// - [CpfSeguroLeftAccessory]  — spotIcon · avatar · iconAccessory · illustration
/// - [CpfSeguroMiddleAccessory] — title · titleSubtitle · labelTitleSubtitle · titleSubtitleSubtitle
/// - [CpfSeguroRightAccessory] — action · chevron · statusTag · time · timeStatus · toggle · checkbox
///
/// Composição típica:
///
/// ```dart
/// CpfSeguroAppList(
///   left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
///   middle: CpfSeguroMiddleAccessory.titleSubtitle(
///     title: 'Dados pessoais',
///     subtitle: 'Nome, CPF, nascimento',
///   ),
///   right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
///   onTap: openDadosPessoais,
/// )
/// ```
///
/// Os widgets `CpfSeguroSpotIcon`, `CpfSeguroAvatar` e `CpfSeguroIconAccessory`
/// também vivem standalone (fora do AppList) — os named constructors do
/// LeftAccessory os embrulham com padding vertical 72h.

// ═══════════════════════════════════════════════════════════════════════════
// LEFT ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Slot esquerdo do [CpfSeguroAppList].
///
/// Variantes (todas os named constructors são `const`):
/// - [CpfSeguroLeftAccessory.spotIcon]      — círculo colorido com ícone
/// - [CpfSeguroLeftAccessory.avatar]        — iniciais em círculo 40
/// - [CpfSeguroLeftAccessory.iconAccessory] — ícone puro + badge opt
///
/// Sempre `height: 72` (encaixe do row). Centraliza vertical.
sealed class CpfSeguroLeftAccessory extends StatelessWidget {
  const CpfSeguroLeftAccessory({super.key});

  const factory CpfSeguroLeftAccessory.spotIcon({
    Key? key,
    required String icon,
    CpfSeguroSpotType type,
    CpfSeguroSpotState state,
    CpfSeguroBadge badge,
    double size,
  }) = _LeftSpotIcon;

  const factory CpfSeguroLeftAccessory.avatar({
    Key? key,
    required String initials,
    CpfSeguroAvatarVariant variant,
    Color borderColor,
    double size,
  }) = _LeftAvatar;

  const factory CpfSeguroLeftAccessory.iconAccessory({
    Key? key,
    required String icon,
    double size,
    Color? color,
    CpfSeguroBadge badge,
    bool danger,
  }) = _LeftIconAccessory;

  /// Renderiza o conteúdo específico da variante. Override nas subclasses.
  Widget _renderChild();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 72, child: Center(child: _renderChild()));
  }
}

class _LeftSpotIcon extends CpfSeguroLeftAccessory {
  const _LeftSpotIcon({
    super.key,
    required this.icon,
    this.type = CpfSeguroSpotType.fill,
    this.state = CpfSeguroSpotState.normal,
    this.badge = CpfSeguroBadge.none,
    this.size = 34,
  });

  final String icon;
  final CpfSeguroSpotType type;
  final CpfSeguroSpotState state;
  final CpfSeguroBadge badge;
  final double size;

  @override
  Widget _renderChild() =>
      CpfSeguroSpotIcon(icon: icon, type: type, state: state, badge: badge, size: size);
}

class _LeftAvatar extends CpfSeguroLeftAccessory {
  const _LeftAvatar({
    super.key,
    required this.initials,
    this.variant = CpfSeguroAvatarVariant.outlined,
    this.borderColor = CpfSeguroColors.neutral09,
    this.size = 40,
  });

  final String initials;
  final CpfSeguroAvatarVariant variant;
  final Color borderColor;
  final double size;

  @override
  Widget _renderChild() =>
      CpfSeguroAvatar(initials: initials, variant: variant, borderColor: borderColor, size: size);
}

class _LeftIconAccessory extends CpfSeguroLeftAccessory {
  const _LeftIconAccessory({
    super.key,
    required this.icon,
    this.size = 20,
    this.color,
    this.badge = CpfSeguroBadge.none,
    this.danger = false,
  });

  final String icon;
  final double size;
  final Color? color;
  final CpfSeguroBadge badge;

  /// Tinge o ícone com o role `danger` (`scheme.error`) — ação destrutiva.
  /// Precede [color].
  final bool danger;

  @override
  Widget _renderChild() =>
      CpfSeguroIconAccessory(icon: icon, size: size, color: color, badge: badge);

  @override
  Widget build(BuildContext context) {
    if (!danger) return super.build(context);
    final c = CpfSeguroTheme.schemeOf(context).error;
    return SizedBox(
      height: 72,
      child: Center(
        child: CpfSeguroIconAccessory(
          icon: icon,
          size: size,
          color: c,
          badge: badge,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MIDDLE ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Tamanho do slot middle.
///
/// - **md** — 72h (usa `titleSm 14/20` / `bodySm 12/16`)
/// - **sm** — 36h (usa `labelMd 12/16` / `labelSm 11/16`)
enum CpfSeguroMiddleSize { sm, md }

/// Slot do meio do [CpfSeguroAppList] — sempre `Expanded`.
///
/// Mirror do Figma "Middle accessory list" (2517:38361). 9 variantes de
/// layout + custom (escape hatch):
///
/// - [CpfSeguroMiddleAccessory.title]                        — só título (+ favorite md)
/// - [CpfSeguroMiddleAccessory.subtitle]                     — só body/subtitle
/// - [CpfSeguroMiddleAccessory.titleSubtitle]                — título + subtitle (+ favorite md)
/// - [CpfSeguroMiddleAccessory.titleSubtitleSubtitle]        — título + `subtitle • accessorySubtitle` inline
/// - [CpfSeguroMiddleAccessory.titleSubtitleTag]             — título + subtitle esq + statusTag dir
/// - [CpfSeguroMiddleAccessory.titleSubtitleAtitleTag]       — título/subtitle esq + accessoryTitle/statusTag dir (md)
/// - [CpfSeguroMiddleAccessory.titleSubtitleAtitleAsubtitle] — 2 colunas: (title/sub) · (aTitle/aSub) — md
/// - [CpfSeguroMiddleAccessory.labelTitleSubtitle]           — eyebrow label + título + subtitle (+ favorite md)
/// - [CpfSeguroMiddleAccessory.titleBodyLabel]               — título + body + label (sm)
/// - [CpfSeguroMiddleAccessory.custom]                       — widget livre
///
/// `disabled: true` dim todos os textos (neutral-05 no título, neutral-06 no sub).
sealed class CpfSeguroMiddleAccessory extends StatelessWidget {
  const CpfSeguroMiddleAccessory({super.key});

  // ─── Textos simples ─────────────────────────────────────────────────────

  const factory CpfSeguroMiddleAccessory.title({
    Key? key,
    required String title,
    CpfSeguroMiddleSize size,
    bool favorite,
    bool disabled,
    bool danger,
  }) = _MiddleTitle;

  const factory CpfSeguroMiddleAccessory.subtitle({
    Key? key,
    required String subtitle,
    CpfSeguroMiddleSize size,
    bool disabled,
  }) = _MiddleSubtitle;

  const factory CpfSeguroMiddleAccessory.titleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    CpfSeguroMiddleSize size,
    bool favorite,
    bool disabled,
    bool danger,
  }) = _MiddleTitleSubtitle;

  const factory CpfSeguroMiddleAccessory.titleSubtitleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    String? accessorySubtitle,
    CpfSeguroMiddleSize size,
    bool disabled,
  }) = _MiddleTitleSubtitleSubtitle;

  const factory CpfSeguroMiddleAccessory.labelTitleSubtitle({
    Key? key,
    String? label,
    required String title,
    String? subtitle,
    CpfSeguroMiddleSize size,
    bool favorite,
    bool disabled,
  }) = _MiddleLabelTitleSubtitle;

  const factory CpfSeguroMiddleAccessory.titleBodyLabel({
    Key? key,
    required String title,
    String? body,
    String? label,
    bool disabled,
  }) = _MiddleTitleBodyLabel;

  // ─── Combinados com tag/accessory ──────────────────────────────────────

  const factory CpfSeguroMiddleAccessory.titleSubtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String tagLabel,
    required CpfSeguroStatusTone tagTone,
    String? tagIcon,
    CpfSeguroMiddleSize size,
    bool disabled,
  }) = _MiddleTitleSubtitleTag;

  const factory CpfSeguroMiddleAccessory.titleSubtitleAtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    required String tagLabel,
    required CpfSeguroStatusTone tagTone,
    String? tagIcon,
    bool disabled,
  }) = _MiddleTitleSubtitleAtitleTag;

  const factory CpfSeguroMiddleAccessory.titleSubtitleAtitleAsubtitle({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    String? accessorySubtitle,
    bool disabled,
  }) = _MiddleTitleSubtitleAtitleAsubtitle;

  Widget _renderChildren(CpfSeguroScheme s);

  /// Altura do slot: 72 em md, 36 em sm.
  double get _height => CpfSeguroMiddleSize.md == _sizeHint() ? 72 : 36;

  /// Sobrescrever nas subclasses que aceitam [size].
  CpfSeguroMiddleSize _sizeHint() => CpfSeguroMiddleSize.md;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Expanded(
      child: SizedBox(
        height: _height,
        child: _renderChildren(s),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Middle · style tokens por size
// ═══════════════════════════════════════════════════════════════════════════

TextStyle _mTitleStyle(CpfSeguroMiddleSize size, bool disabled, CpfSeguroScheme s,
    {bool danger = false}) {
  final base = size == CpfSeguroMiddleSize.md ? CpfSeguroType.subheading : CpfSeguroType.label;
  return base.copyWith(
    color: disabled
        ? CpfSeguroColors.neutral05
        : danger
            ? s.error
            : s.fg,
  );
}

TextStyle _mSubStyle(CpfSeguroMiddleSize size, bool disabled, CpfSeguroScheme s) {
  final base = size == CpfSeguroMiddleSize.md ? CpfSeguroType.caption : CpfSeguroType.labelSm;
  return base.copyWith(
    color: disabled ? CpfSeguroColors.neutral06 : s.textTertiary,
  );
}

/// Label como eyebrow do labelTitleSubtitle · sempre bodySm neutral-03.
TextStyle _mEyebrowStyle(bool disabled, CpfSeguroScheme s) => CpfSeguroType.caption.copyWith(
      color: disabled ? CpfSeguroColors.neutral06 : s.textTertiary,
    );

/// Label do titleBodyLabel (footer sm) · labelSm 11 neutral-05.
TextStyle _mFooterLabelStyle(bool disabled, CpfSeguroScheme s) => CpfSeguroType.labelSm.copyWith(
      color: disabled ? CpfSeguroColors.neutral06 : s.textPlaceholder,
    );

/// Ícone estrela 16px na direita (favorite=true em variants md).
Widget _favoriteIcon(bool disabled) => Padding(
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s4),
      child: CpfSeguroIconAccessory(
        icon: CpfSeguroIcons.starSolid,
        size: 16,
        padding: 0,
        color: disabled ? CpfSeguroColors.neutral07 : CpfSeguroColors.warning04,
      ),
    );

// ═══════════════════════════════════════════════════════════════════════════
// Middle · variantes
// ═══════════════════════════════════════════════════════════════════════════

class _MiddleTitle extends CpfSeguroMiddleAccessory {
  const _MiddleTitle({
    super.key,
    required this.title,
    this.size = CpfSeguroMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
    this.danger = false,
  });
  final String title;
  final CpfSeguroMiddleSize size;
  final bool favorite;
  final bool disabled;

  /// Título no role `danger` (`scheme.error`) — ação destrutiva.
  final bool danger;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(title,
                maxLines: 1,
                style: _mTitleStyle(size, disabled, s, danger: danger)),
          ),
          if (favorite && size == CpfSeguroMiddleSize.md) _favoriteIcon(disabled),
        ],
      );
}

class _MiddleSubtitle extends CpfSeguroMiddleAccessory {
  const _MiddleSubtitle({
    super.key,
    required this.subtitle,
    this.size = CpfSeguroMiddleSize.md,
    this.disabled = false,
  });
  final String subtitle;
  final CpfSeguroMiddleSize size;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          subtitle,
          maxLines: 1,
          style: CpfSeguroType.caption.copyWith(
            color: disabled ? CpfSeguroColors.neutral06 : CpfSeguroColors.neutral01,
          ),
        ),
      );
}

class _MiddleTitleSubtitle extends CpfSeguroMiddleAccessory {
  const _MiddleTitleSubtitle({
    super.key,
    required this.title,
    this.subtitle,
    this.size = CpfSeguroMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
    this.danger = false,
  });
  final String title;
  final String? subtitle;
  final CpfSeguroMiddleSize size;
  final bool favorite;
  final bool disabled;

  /// Título no role `danger` (`scheme.error`) — ação destrutiva.
  final bool danger;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s, danger: danger)),
                if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
              ],
            ),
          ),
          if (favorite && size == CpfSeguroMiddleSize.md) _favoriteIcon(disabled),
        ],
      );
}

class _MiddleTitleSubtitleSubtitle extends CpfSeguroMiddleAccessory {
  const _MiddleTitleSubtitleSubtitle({
    super.key,
    required this.title,
    this.subtitle,
    this.accessorySubtitle,
    this.size = CpfSeguroMiddleSize.md,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String? accessorySubtitle;
  final CpfSeguroMiddleSize size;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) {
    final subStyle = _mSubStyle(size, disabled, s);
    final bulletParts = <String>[
      if (subtitle != null) subtitle!,
      if (accessorySubtitle != null) accessorySubtitle!,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
        if (bulletParts.isNotEmpty)
          Text(bulletParts.join(' • '), maxLines: 1, style: subStyle),
      ],
    );
  }
}

class _MiddleLabelTitleSubtitle extends CpfSeguroMiddleAccessory {
  const _MiddleLabelTitleSubtitle({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.size = CpfSeguroMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
  });
  final String? label;
  final String title;
  final String? subtitle;
  final CpfSeguroMiddleSize size;
  final bool favorite;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null) Text(label!, maxLines: 1, style: _mEyebrowStyle(disabled, s)),
                Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
                if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
              ],
            ),
          ),
          if (favorite && size == CpfSeguroMiddleSize.md) _favoriteIcon(disabled),
        ],
      );
}

class _MiddleTitleBodyLabel extends CpfSeguroMiddleAccessory {
  const _MiddleTitleBodyLabel({
    super.key,
    required this.title,
    this.body,
    this.label,
    this.disabled = false,
  });
  final String title;
  final String? body;
  final String? label;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => CpfSeguroMiddleSize.sm;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, maxLines: 1, style: _mTitleStyle(CpfSeguroMiddleSize.md, disabled, s)),
          if (body != null)
            Text(
              body!,
              maxLines: 1,
              style: CpfSeguroType.caption.copyWith(
                color: disabled ? CpfSeguroColors.neutral06 : CpfSeguroColors.neutral03,
              ),
            ),
          if (label != null) Text(label!, maxLines: 1, style: _mFooterLabelStyle(disabled, s)),
        ],
      );
}

class _MiddleTitleSubtitleTag extends CpfSeguroMiddleAccessory {
  const _MiddleTitleSubtitleTag({
    super.key,
    required this.title,
    this.subtitle,
    required this.tagLabel,
    required this.tagTone,
    this.tagIcon,
    this.size = CpfSeguroMiddleSize.md,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String tagLabel;
  final CpfSeguroStatusTone tagTone;
  final String? tagIcon;
  final CpfSeguroMiddleSize size;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(CpfSeguroScheme s) {
    final left = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
          if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
        ],
      ),
    );
    final tag = CpfSeguroStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon);
    if (size == CpfSeguroMiddleSize.sm) {
      // sm: tag empilha à direita do bloco (fim do row)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [left, const SizedBox(width: 16), tag],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [left, const SizedBox(width: 16), tag],
    );
  }
}

class _MiddleTitleSubtitleAtitleTag extends CpfSeguroMiddleAccessory {
  const _MiddleTitleSubtitleAtitleTag({
    super.key,
    required this.title,
    this.subtitle,
    required this.accessoryTitle,
    required this.tagLabel,
    required this.tagTone,
    this.tagIcon,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String accessoryTitle;
  final String tagLabel;
  final CpfSeguroStatusTone tagTone;
  final String? tagIcon;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => CpfSeguroMiddleSize.md;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(CpfSeguroMiddleSize.md, disabled, s)),
                if (subtitle != null)
                  Text(subtitle!, maxLines: 1, style: _mSubStyle(CpfSeguroMiddleSize.md, disabled, s)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(accessoryTitle, maxLines: 1, style: _mTitleStyle(CpfSeguroMiddleSize.md, disabled, s)),
              CpfSeguroStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon),
            ],
          ),
        ],
      );
}

class _MiddleTitleSubtitleAtitleAsubtitle extends CpfSeguroMiddleAccessory {
  const _MiddleTitleSubtitleAtitleAsubtitle({
    super.key,
    required this.title,
    this.subtitle,
    required this.accessoryTitle,
    this.accessorySubtitle,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String accessoryTitle;
  final String? accessorySubtitle;
  final bool disabled;

  @override
  CpfSeguroMiddleSize _sizeHint() => CpfSeguroMiddleSize.md;

  @override
  Widget _renderChildren(CpfSeguroScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(CpfSeguroMiddleSize.md, disabled, s)),
                if (subtitle != null)
                  Text(subtitle!, maxLines: 1, style: _mSubStyle(CpfSeguroMiddleSize.md, disabled, s)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(accessoryTitle, maxLines: 1, style: _mTitleStyle(CpfSeguroMiddleSize.md, disabled, s)),
              if (accessorySubtitle != null)
                Text(accessorySubtitle!, maxLines: 1, style: _mSubStyle(CpfSeguroMiddleSize.md, disabled, s)),
            ],
          ),
        ],
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// RIGHT ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Slot direito do [CpfSeguroAppList].
///
/// Mirror do Figma "Right accessory" (2456:35494) — 7 variantes canônicas +
/// escape hatch:
///
/// - [CpfSeguroRightAccessory.action]     — [CpfSeguroAction] (chevron, more, check, etc)
/// - [CpfSeguroRightAccessory.icon]       — IconButton 36×36 (ícone secundário)
/// - [CpfSeguroRightAccessory.status]     — pill de [CpfSeguroStatusTag]
/// - [CpfSeguroRightAccessory.amountChip] — pill com plus + valor (R$ 560,00)
/// - [CpfSeguroRightAccessory.toggle]     — [CpfSeguroToggleSwitch]
/// - [CpfSeguroRightAccessory.checkbox]   — [CpfSeguroCheckbox]
/// - [CpfSeguroRightAccessory.radio]      — radio dot 20×20
/// - [CpfSeguroRightAccessory.custom]     — widget livre (escape hatch)
///
/// Sempre `height: 72`. Alinha vertical center, horizontal end.
sealed class CpfSeguroRightAccessory extends StatelessWidget {
  const CpfSeguroRightAccessory({super.key});

  const factory CpfSeguroRightAccessory.action({
    Key? key,
    required CpfSeguroActionDirection direction,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) = _RightAction;

  const factory CpfSeguroRightAccessory.icon({
    Key? key,
    required String icon,
    required String semanticLabel,
    VoidCallback? onPressed,
    CpfSeguroIconButtonType type,
    CpfSeguroIconButtonState state,
    bool disabled,
  }) = _RightIcon;

  const factory CpfSeguroRightAccessory.status({
    Key? key,
    required String label,
    required CpfSeguroStatusTone tone,
    String? icon,
  }) = _RightStatus;

  /// Ícone BARE tonalizado por role (sem label, sem chrome de botão). Espelha
  /// [CpfSeguroLeftAccessory.iconAccessory] no lado direito. Serve indicador de
  /// status (check verde/relógio neutro/x vermelho) E marcador simples (lápis
  /// neutro = editar). NÃO é StatusTag (tem label) nem `.icon` (botão).
  /// Substitui o antigo `.custom(CpfSeguroIcon(...))`.
  const factory CpfSeguroRightAccessory.iconAccessory({
    Key? key,
    required String icon,
    CpfSeguroStatusTone tone,
    double size,
  }) = _RightIconAccessory;

  const factory CpfSeguroRightAccessory.amountChip({
    Key? key,
    required String amount,
    String icon,
  }) = _RightAmountChip;

  /// Consome um [CpfSeguroAmount] (o acessório não desenha — só posiciona).
  /// Ex.: `right.amount(CpfSeguroAmount.cashIn(value: 'R\$ 560,00'))`.
  const factory CpfSeguroRightAccessory.amount(CpfSeguroAmount amount, {Key? key}) = _RightAmount;

  const factory CpfSeguroRightAccessory.toggle({
    Key? key,
    required bool value,
    required ValueChanged<bool> onChanged,
    CpfSeguroToggleSize size,
    bool disabled,
    String? semanticLabel,
  }) = _RightToggle;

  const factory CpfSeguroRightAccessory.checkbox({
    Key? key,
    required bool checked,
    required ValueChanged<bool> onChanged,
    bool indeterminate,
    bool disabled,
    CpfSeguroCheckboxVariant variant,
    CpfSeguroCheckboxSize size,
  }) = _RightCheckbox;

  const factory CpfSeguroRightAccessory.radio({
    Key? key,
    required bool selected,
    required VoidCallback onPressed,
    bool disabled,
  }) = _RightRadio;

  // ─── Sugar helpers (não Figma) ────────────────────────────────────────────
  // Retornam .custom(...) internamente — usados no ActivityRecent do app.

  /// Texto de tempo à direita (ex: "14min"). Sugar sobre `.custom`.
  static CpfSeguroRightAccessory time({
    required String time,
    bool disabled = false,
    Key? key,
  }) {
    return _RightCustom(
      key: key,
      child: Text(
        time,
        maxLines: 1,
        style: CpfSeguroType.caption.copyWith(
          color: disabled ? CpfSeguroColors.neutral06 : CpfSeguroColors.neutral03,
        ),
      ),
    );
  }

  /// Time em cima, [CpfSeguroStatusTag] embaixo. Sugar sobre `.custom`.
  static CpfSeguroRightAccessory timeStatus({
    required String time,
    required CpfSeguroStatusTagData status,
    bool disabled = false,
    Key? key,
  }) {
    return _RightCustom(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            maxLines: 1,
            style: CpfSeguroType.caption.copyWith(
              color: disabled ? CpfSeguroColors.neutral06 : CpfSeguroColors.neutral03,
            ),
          ),
          const SizedBox(height: 4),
          CpfSeguroStatusTag(label: status.label, tone: status.tone, icon: status.icon),
        ],
      ),
    );
  }

  /// Filhos do slot (podem ser 1 ou N empilhados vertical com gap 4).
  List<Widget> _renderChildren();

  @override
  Widget build(BuildContext context) {
    final children = _renderChildren();
    return SizedBox(
      height: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 4),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _RightAction extends CpfSeguroRightAccessory {
  const _RightAction({
    super.key,
    required this.direction,
    this.onPressed,
    this.semanticLabel,
  });

  final CpfSeguroActionDirection direction;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroAction(direction: direction, onPressed: onPressed, semanticLabel: semanticLabel),
      ];
}

class _RightIcon extends CpfSeguroRightAccessory {
  const _RightIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.type = CpfSeguroIconButtonType.tertiary,
    this.state = CpfSeguroIconButtonState.normal,
    this.disabled = false,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final CpfSeguroIconButtonType type;
  final CpfSeguroIconButtonState state;
  final bool disabled;

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroIconButton(
          icon: icon,
          semanticLabel: semanticLabel,
          onPressed: onPressed,
          type: type,
          state: state,
          disabled: disabled,
          size: CpfSeguroIconButtonSize.md,
        ),
      ];
}

class _RightStatus extends CpfSeguroRightAccessory {
  const _RightStatus({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  final String label;
  final CpfSeguroStatusTone tone;
  final String? icon;

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroStatusTag(label: label, tone: tone, icon: icon),
      ];
}

class _RightIconAccessory extends CpfSeguroRightAccessory {
  const _RightIconAccessory({
    super.key,
    required this.icon,
    this.tone = CpfSeguroStatusTone.neutral,
    this.size = 18,
  });

  final String icon;
  final CpfSeguroStatusTone tone;
  final double size;

  Color _toneColor() => switch (tone) {
        CpfSeguroStatusTone.danger => CpfSeguroColors.error04,
        CpfSeguroStatusTone.success => CpfSeguroColors.success04,
        CpfSeguroStatusTone.warning => CpfSeguroColors.warning04,
        CpfSeguroStatusTone.primary => CpfSeguroColors.primary04,
        CpfSeguroStatusTone.neutral => CpfSeguroColors.neutral03,
      };

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroIconAccessory(icon: icon, padding: 0, size: size, color: _toneColor()),
      ];
}

class _RightAmountChip extends CpfSeguroRightAccessory {
  const _RightAmountChip({
    super.key,
    required this.amount,
    this.icon = 'plus-solid',
  });

  final String amount;
  final String icon;

  @override
  List<Widget> _renderChildren() => [
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s2, vertical: CpfSeguroSpacing.s1),
          decoration: BoxDecoration(
            color: CpfSeguroColors.neutral09,
            borderRadius: CpfSeguroRadius.all8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CpfSeguroIconAccessory(icon: icon, size: 12, padding: 0, color: CpfSeguroColors.neutral02),
              const SizedBox(width: 4),
              Text(amount, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral02)),
            ],
          ),
        ),
      ];
}

/// Valor de transação alinhado à direita ("—  R$ 560,00"). O travessão
/// prefixa valores negativos (débito), padrão do extrato da Carteira.
class _RightAmount extends CpfSeguroRightAccessory {
  const _RightAmount(this.amount, {super.key});

  final CpfSeguroAmount amount;

  @override
  List<Widget> _renderChildren() => [amount];
}

class _RightToggle extends CpfSeguroRightAccessory {
  const _RightToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = CpfSeguroToggleSize.md,
    this.disabled = false,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final CpfSeguroToggleSize size;
  final bool disabled;
  final String? semanticLabel;

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroToggleSwitch(
          value: value,
          onChanged: onChanged,
          size: size,
          disabled: disabled,
          semanticLabel: semanticLabel,
        ),
      ];
}

class _RightCheckbox extends CpfSeguroRightAccessory {
  const _RightCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
    this.indeterminate = false,
    this.disabled = false,
    this.variant = CpfSeguroCheckboxVariant.primary,
    this.size = CpfSeguroCheckboxSize.md,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool indeterminate;
  final bool disabled;
  final CpfSeguroCheckboxVariant variant;
  final CpfSeguroCheckboxSize size;

  @override
  List<Widget> _renderChildren() => [
        CpfSeguroCheckbox(
          checked: checked,
          onChanged: onChanged,
          indeterminate: indeterminate,
          disabled: disabled,
          variant: variant,
          size: size,
        ),
      ];
}

class _RightRadio extends CpfSeguroRightAccessory {
  const _RightRadio({
    super.key,
    required this.selected,
    required this.onPressed,
    this.disabled = false,
  });

  final bool selected;
  final VoidCallback onPressed;
  final bool disabled;

  @override
  List<Widget> _renderChildren() => [
        Semantics(
          inMutuallyExclusiveGroup: true,
          checked: selected,
          enabled: !disabled,
          button: true,
          child: MouseRegion(
            cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: disabled ? null : onPressed,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CpfSeguroColors.white,
                  border: Border.all(
                    color: disabled
                        ? CpfSeguroColors.neutral07
                        : (selected ? CpfSeguroColors.neutral01 : CpfSeguroColors.neutral07),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: disabled ? CpfSeguroColors.neutral07 : CpfSeguroColors.neutral01,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ];
}

class _RightCustom extends CpfSeguroRightAccessory {
  const _RightCustom({super.key, required this.child});
  final Widget child;

  @override
  List<Widget> _renderChildren() => [child];
}

// ═══════════════════════════════════════════════════════════════════════════
// APP LIST · row composta pelos 3 slots
// ═══════════════════════════════════════════════════════════════════════════

/// Row canônica: [left] + [middle] + [right] + [footer] opcional.
/// Figma: "App list" (141:15428).
///
/// ```dart
/// CpfSeguroAppList(
///   left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
///   middle: CpfSeguroMiddleAccessory.titleSubtitle(
///     title: 'Dados pessoais',
///     subtitle: 'Nome, CPF, nascimento',
///   ),
///   right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
///   onTap: () => openDadosPessoais(),
/// )
/// ```
/// CPF SEGURO — AppListRow (a ROW pura).
///
/// Uma linha de lista: `left` · `middle` (expande) · `right` (+ `footer` opt).
/// **Não sabe nada dos vizinhos** — sem `position`, sem separator próprio. O
/// separador é responsabilidade da COLEÇÃO ([CpfSeguroAppList] com
/// `.carded`/`.plain`/`.menu`), que é quem conhece a ordem. Uma row solta na
/// tela é só isto, sem linha.
///
/// Renderizável standalone (banner de perfil, resumo de uma linha) ou como
/// filho de uma coleção.
class CpfSeguroAppListRow extends StatelessWidget {
  const CpfSeguroAppListRow({
    super.key,
    this.left,
    this.middle,
    this.right,
    this.footer,
    this.background,
    this.radius,
    this.onTap,
  });

  /// Row estilo **menu** — spot outline primary + title/subtitle + chevron.
  /// Uso mais comum dentro de `CpfSeguroAppListGroup(title:)`.
  ///
  /// ```dart
  /// CpfSeguroAppList.menuItem(icon: CpfSeguroIcons.userLight, title: 'Dados', subtitle: '...', onTap: () {})
  /// ```
  factory CpfSeguroAppListRow.menuItem({
    Key? key,
    required String icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    return CpfSeguroAppListRow(
      key: key,
      onTap: disabled ? null : onTap,
      left: CpfSeguroLeftAccessory.spotIcon(
        icon: icon,
        type: CpfSeguroSpotType.outline,
        state: disabled ? CpfSeguroSpotState.disabled : CpfSeguroSpotState.primary,
      ),
      middle: CpfSeguroMiddleAccessory.titleSubtitle(
        title: title,
        subtitle: subtitle,
        disabled: disabled,
      ),
      right: const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
    );
  }

  /// Row estilo **histórico de atividade** — spot fill colorido por [state] +
  /// title/subtitle + acessório direito (time, status ou os dois).
  ///
  /// Passe `time` sozinho, `status` sozinho, ou os dois pra timeStatus.
  ///
  /// ```dart
  /// CpfSeguroAppList.activityItem(
  ///   icon: CpfSeguroIcons.shieldUserSolidFull,
  ///   iconState: CpfSeguroSpotState.success,
  ///   title: 'Login em Banco Aurora',
  ///   subtitle: 'Por mim · Biometria',
  ///   time: '14min',
  /// )
  /// ```
  factory CpfSeguroAppListRow.activityItem({
    Key? key,
    required String icon,
    required CpfSeguroSpotState iconState,
    CpfSeguroSpotType iconType = CpfSeguroSpotType.fill,
    required String title,
    String? subtitle,
    String? time,
    CpfSeguroStatusTagData? status,
    CpfSeguroBadge iconBadge = CpfSeguroBadge.none,
    Widget? footer,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    final effectiveIconState = disabled ? CpfSeguroSpotState.disabled : iconState;
    CpfSeguroRightAccessory? rightSlot;
    if (time != null && status != null) {
      rightSlot = CpfSeguroRightAccessory.timeStatus(time: time, status: status, disabled: disabled);
    } else if (time != null) {
      rightSlot = CpfSeguroRightAccessory.time(time: time, disabled: disabled);
    } else if (status != null) {
      rightSlot = CpfSeguroRightAccessory.status(label: status.label, tone: status.tone, icon: status.icon);
    }
    return CpfSeguroAppListRow(
      key: key,
      onTap: disabled ? null : onTap,
      left: CpfSeguroLeftAccessory.spotIcon(
        icon: icon,
        type: iconType,
        state: effectiveIconState,
        badge: iconBadge,
      ),
      middle: CpfSeguroMiddleAccessory.titleSubtitle(
        title: title,
        subtitle: subtitle,
        disabled: disabled,
      ),
      right: rightSlot,
      footer: footer,
    );
  }

  /// Row estilo **extrato da Carteira** — spot com logo do merchant +
  /// título/fonte/hora + valor à direita ("—  R$ 560,00").
  ///
  /// ```dart
  /// CpfSeguroAppList.transactionItem(
  ///   title: 'Pague menos',
  ///   source: 'CPF Seguro',
  ///   time: '12:04',
  ///   amount: 'R$ 560,00',
  /// )
  /// ```
  factory CpfSeguroAppListRow.transactionItem({
    Key? key,
    required String title,
    required String source,
    required String time,
    required String amount,
    bool negative = true,
    String icon = 'pix-light',
    VoidCallback? onTap,
  }) {
    return CpfSeguroAppListRow(
      key: key,
      onTap: onTap,
      left: CpfSeguroLeftAccessory.spotIcon(icon: icon, state: CpfSeguroSpotState.normal),
      middle: CpfSeguroMiddleAccessory.titleSubtitleSubtitle(
        title: title,
        subtitle: source,
        accessorySubtitle: time,
      ),
      right: CpfSeguroRightAccessory.amount(
        negative
            ? CpfSeguroAmount.cashOut(value: amount)
            : CpfSeguroAmount.cashIn(value: amount),
      ),
    );
  }

  /// Row estilo **profile banner** — avatar solid ring primary + name/cpf +
  /// bg primary-08 + radius 24. Sem chevron. Standalone (não vai dentro de
  /// [CpfSeguroAppListGroup]).
  ///
  /// ```dart
  /// CpfSeguroAppList.profileBanner(initials: 'AM', name: 'Ana Maria', subtitle: 'CPF 086.***.***-49')
  /// ```
  factory CpfSeguroAppListRow.profileBanner({
    Key? key,
    required String initials,
    required String name,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return CpfSeguroAppListRow(
      key: key,
      onTap: onTap,
      background: CpfSeguroColors.primary08,
      radius: 24,
      left: CpfSeguroLeftAccessory.avatar(initials: initials, variant: CpfSeguroAvatarVariant.solid),
      middle: CpfSeguroMiddleAccessory.titleSubtitle(title: name, subtitle: subtitle),
    );
  }

  final CpfSeguroLeftAccessory? left;
  final CpfSeguroMiddleAccessory? middle;
  final CpfSeguroRightAccessory? right;

  /// Conteúdo opcional abaixo da row principal (ex: barra de progresso de
  /// pausa no histórico).
  final Widget? footer;

  /// Bg da row. **Default null** = transparente (herda do container pai). Não
  /// use white/branco solto quando a row for dentro de [CpfSeguroAppListGroup]
  /// — o fill acaba cobrindo o stroke do group nos cantos.
  ///
  /// Passe explícito só quando a row for **standalone** (banner de perfil,
  /// card destacado com cor de fundo diferente).
  final Color? background;

  /// Radius da row. **Default null** = 0 (sem radius). Quando dentro de
  /// [CpfSeguroAppListGroup] o clip do group já dá o cantinho — não precisa
  /// duplicar. Standalone com bg custom pode passar (ex: profile banner = 24).
  final double? radius;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = (background != null || radius != null)
        ? BoxDecoration(
            color: background,
            borderRadius:
                radius != null ? BorderRadius.circular(radius!) : null,
          )
        : null;
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s2),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (left != null) ...[left!, const SizedBox(width: 12)],
              if (middle != null) middle!,
              if (right != null) right!,
            ],
          ),
          if (footer != null)
            Padding(padding: const EdgeInsets.only(bottom: CpfSeguroSpacing.s2), child: footer!),
        ],
      ),
    );

    if (onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: content,
        ),
      );
    }
    return CpfSeguroDevInfo(
      component: 'CpfSeguroAppListRow',
      props: {
        if (left != null) 'left': 'accessory',
        if (middle != null) 'middle': 'accessory',
        if (right != null) 'right': 'accessory',
        if (footer != null) 'footer': 'widget',
        if (onTap != null) 'onTap': 'true',
      },
      tokens: [
        'row Left · Middle(expanded) · Right · px 8',
        if (background != null) 'bg: ${cpfSeguroColorToken(background)}',
        if (radius != null) 'radius: ${radius!.toInt()}',
      ],
      child: content,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppList · a COLEÇÃO (dona ÚNICA do separador)
// ═══════════════════════════════════════════════════════════════════════════

enum _ListVariant { carded, plain, menu }

/// CPF SEGURO — AppList (a COLEÇÃO de [CpfSeguroAppListRow]).
///
/// Dona ÚNICA do separador: a row não conhece a vizinhança, a coleção sim —
/// então nunca há linha dupla nem "último errado", e o consumidor jamais
/// calcula índice. Três idiomas, por construtor nomeado:
///
/// - [CpfSeguroAppList.carded] — card branco com **stroke externo** + radius +
///   padding; separador entre rows, nenhum no último (a borda fecha).
/// - [CpfSeguroAppList.plain]  — **sem stroke externo**; só as rows com
///   separador entre elas, nenhum no último. Pro grupo que não é card.
/// - [CpfSeguroAppList.menu]   — sem stroke; divisor full-width embaixo de
///   CADA row (inclusive quando é uma só). Idioma menu/settings.
///
/// [title] opcional — eyebrow uppercase acima da coleção (antigo MenuSection).
///
/// ```dart
/// CpfSeguroAppList.carded(children: [row1, row2])
/// CpfSeguroAppList.plain(title: 'Meus dados', children: [row1, row2])
/// CpfSeguroAppList.menu(children: [row1])   // item único fecha com hairline
/// ```
class CpfSeguroAppList extends StatelessWidget {
  const CpfSeguroAppList.carded({super.key, required this.children, this.title})
      : _variant = _ListVariant.carded;
  const CpfSeguroAppList.plain({super.key, required this.children, this.title})
      : _variant = _ListVariant.plain;
  const CpfSeguroAppList.menu({super.key, required this.children, this.title})
      : _variant = _ListVariant.menu;

  /// Rows da coleção. Idealmente [CpfSeguroAppListRow], mas aceita `Widget` pra
  /// suportar RECIPES que embrulham uma row (ex.: um recipe de domínio com
  /// ShimmerLoading por cima). O contrato é soft: cada child deve SER ou
  /// EMBRULHAR uma row — a coleção só orquestra o separador entre elas.
  final List<Widget> children;

  /// Eyebrow uppercase acima da coleção. Null = sem seção.
  final String? title;

  final _ListVariant _variant;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final carded = _variant == _ListVariant.carded;
    final underEach = _variant == _ListVariant.menu;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: (underEach || i < children.length - 1)
                  ? Border(bottom: BorderSide(color: s.divider, width: 1))
                  : null,
            ),
            child: children[i],
          ),
      ],
    );

    final Widget body = carded
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: s.surface,
              border: Border.all(color: s.divider, width: 1),
              borderRadius: CpfSeguroRadius.all24,
            ),
            padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s2),
            child: column,
          )
        : column;

    final devInfo = CpfSeguroDevInfo(
      component: 'CpfSeguroAppList',
      props: {
        'variant': _variant.name,
        'rows': '${children.length}',
        if (title != null) 'title': "'$title'",
      },
      tokens: [
        carded
            ? 'card: bg surface · stroke neutral-09 · radius 24'
            : 'sem stroke externo',
        underEach
            ? 'divisor sob cada row'
            : 'divisor entre rows (nenhum no último)',
      ],
      child: body,
    );

    if (title == null) return devInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: CpfSeguroSpacing.s4, bottom: CpfSeguroSpacing.s2),
          child: Text(title!.toUpperCase(),
              style: CpfSeguroType.overline.copyWith(color: s.textMuted)),
        ),
        devInfo,
      ],
    );
  }
}

// NOTA — CpfSeguroAppListSimple foi removido (@Deprecated).
// Composição explícita: CpfSeguroAppList(left:, middle:, right:) + variantes
// dos accessories (LeftAccessory.spotIcon, MiddleAccessory.titleSubtitle,
// RightAccessory.action/status/time/timeStatus/etc).

// ═══════════════════════════════════════════════════════════════════════════
// AppListDayGroup · grupo FLAT por dia (label + rows com separator inset)
// ═══════════════════════════════════════════════════════════════════════════

/// Grupo de rows por dia ("Hoje", "14/05") — lista FLAT, sem stroke externo,
/// com separator 1px neutral-09 na largura total do elemento.
///
/// Regra do divider: entre as rows (toda row que NÃO é a última) e também
/// abaixo da row quando ela é a ÚNICA do dia — um dia de item único fecha
/// com hairline.
///
/// É o padrão do Histórico e do Extrato do cartão (Figma Frame 1407 ·
/// 510:19493). Contraste com [CpfSeguroAppListGroup], que embrulha as rows
/// num container com border — usado na Home ("Atividade Recente").
///
/// ```dart
/// CpfSeguroAppListDayGroup(label: 'Hoje', children: [row1, row2])
/// ```
class CpfSeguroAppListDayGroup extends StatelessWidget {
  const CpfSeguroAppListDayGroup({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Divider ocupa a largura TOTAL do elemento (sem inset do ícone).
    const divider = SizedBox(
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: CpfSeguroColors.neutral09),
      ),
    );
    // stretch obrigatório: o divider é um SizedBox(height:1) sem width —
    // com crossAxisAlignment.start ele colapsa pra 0 de largura e some.
    return CpfSeguroDevInfo(
      component: 'CpfSeguroAppListDayGroup',
      props: {'label': "'$label'", 'rows': '${children.length}'},
      tokens: const ['lista FLAT sem stroke · label labelSm neutral-05', 'divider full-width entre rows (e no item único)'],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: CpfSeguroSpacing.s2),
          child: Text(label, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral05)),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1 || children.length == 1) divider,
        ],
      ],
      ),
    );
  }
}
