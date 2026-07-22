import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_icon_button.dart';
import 'cpf_seguro_input_chip.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

// ═══════════════════════════════════════════════════════════════════════════
// NavigationLeftAccessory (molécula) — 3 variantes: back / close / home
// ═══════════════════════════════════════════════════════════════════════════

/// Slot esquerdo do [CpfSeguroNavigationTopBar].
///
/// Variantes:
/// - `.back(onPressed:)`  → IconButton com angle-left (rotate 180 do right)
/// - `.close(onPressed:)` → IconButton com xmark
/// - `.home(firstName:)`  → Avatar (solid ring primary) + "Olá, {name}"
sealed class CpfSeguroNavigationLeftAccessory extends StatelessWidget {
  const CpfSeguroNavigationLeftAccessory({super.key});

  const factory CpfSeguroNavigationLeftAccessory.back({
    Key? key,
    VoidCallback? onPressed,
  }) = _NavLeftBack;

  const factory CpfSeguroNavigationLeftAccessory.close({
    Key? key,
    VoidCallback? onPressed,
  }) = _NavLeftClose;

  const factory CpfSeguroNavigationLeftAccessory.home({
    Key? key,
    required String firstName,
    VoidCallback? onOpenProfile,
  }) = _NavLeftHome;
}

class _NavLeftBack extends CpfSeguroNavigationLeftAccessory {
  const _NavLeftBack({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroIconButton(
      icon: CpfSeguroIcons.angleRightLight,
      semanticLabel: 'Voltar',
      type: CpfSeguroIconButtonType.tertiary,
      rotate: 180,
      flush: CpfSeguroIconFlush.left,
      onPressed: onPressed,
    );
  }
}

class _NavLeftClose extends CpfSeguroNavigationLeftAccessory {
  const _NavLeftClose({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroIconButton(
      icon: CpfSeguroIcons.xmarkLight,
      semanticLabel: 'Fechar',
      type: CpfSeguroIconButtonType.tertiary,
      size: CpfSeguroIconButtonSize.sm,
      iconSize: 18,
      flush: CpfSeguroIconFlush.left,
      onPressed: onPressed,
    );
  }
}

class _NavLeftHome extends CpfSeguroNavigationLeftAccessory {
  const _NavLeftHome({super.key, required this.firstName, this.onOpenProfile});
  final String firstName;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'Abrir perfil de $firstName',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onOpenProfile,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: s.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: s.primary, width: 1),
                ),
                child: CpfSeguroIconAccessory(icon: CpfSeguroIcons.userLight, padding: 0, size: 18, color: s.primary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text('Olá, $firstName!', style: CpfSeguroType.heading.copyWith(color: s.fg)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NavigationRightAccessory (molécula) — 4 variantes
// ═══════════════════════════════════════════════════════════════════════════

/// Descriptor de um IconButton no [CpfSeguroNavigationRightAccessory].
class CpfSeguroNavRightIcon {
  const CpfSeguroNavRightIcon({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.badge = false,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool badge;
}

/// Slot direito do [CpfSeguroNavigationTopBar].
///
/// Variantes:
/// - `.icons(icons:)` → 1, 2 ou 3 IconButtons secondary lado a lado (gap 8)
/// - `.buttonTertiarySmall(label:, onPressed:)` → Button size sm tertiary
/// - `.inputChip(label:)` → chip dropdown de contexto ("Meu CPF ▾")
sealed class CpfSeguroNavigationRightAccessory extends StatelessWidget {
  const CpfSeguroNavigationRightAccessory({super.key});

  const factory CpfSeguroNavigationRightAccessory.icons({
    Key? key,
    required List<CpfSeguroNavRightIcon> icons,
  }) = _NavRightIcons;

  const factory CpfSeguroNavigationRightAccessory.buttonTertiarySmall({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) = _NavRightButtonTertiarySmall;

  const factory CpfSeguroNavigationRightAccessory.inputChip({
    Key? key,
    required String label,
    String trailIcon,
    VoidCallback? onPressed,
  }) = _NavRightInputChip;
}

class _NavRightIcons extends CpfSeguroNavigationRightAccessory {
  const _NavRightIcons({super.key, required this.icons})
      : assert(icons.length >= 1 && icons.length <= 3, 'Right icons: 1, 2 ou 3.');

  final List<CpfSeguroNavRightIcon> icons;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < icons.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          CpfSeguroIconButton(
            icon: icons[i].icon,
            semanticLabel: icons[i].semanticLabel,
            type: CpfSeguroIconButtonType.secondary,
            onPressed: icons[i].onPressed,
            badge: icons[i].badge,
          ),
        ],
      ],
    );
  }
}

class _NavRightButtonTertiarySmall extends CpfSeguroNavigationRightAccessory {
  const _NavRightButtonTertiarySmall({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroButton(
      label: label,
      type: CpfSeguroButtonType.tertiary,
      size: CpfSeguroButtonSize.sm,
      onPressed: onPressed,
    );
  }
}

class _NavRightInputChip extends CpfSeguroNavigationRightAccessory {
  const _NavRightInputChip({
    super.key,
    required this.label,
    this.trailIcon = 'chevron-down-light',
    this.onPressed,
  });

  final String label;
  final String trailIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CpfSeguroInputChip(label: label, trailIcon: trailIcon, onTap: onPressed);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NavigationTopBar (molécula) — left + title + right, altura 52
// ═══════════════════════════════════════════════════════════════════════════

/// Molécula da barra de navegação: `left + title + right`. Altura 52.
///
/// Sem glass, sem StatusBar — esses são característica do
/// [CpfSeguroTopAppBar] (organismo). Aqui é só a linha de conteúdo.
///
/// - [left]: default null (se `showLeft` = true e não passar, usa `.back()`).
/// - [right]: opcional.
/// - [title]: renderizado centralizado por default. Passe `centerAlign =
///   TextAlign.start` pra alinhar à esquerda (uso: Home com "Olá, nome").
/// - [titleWidget]: escape hatch — sobrepõe [title] quando o center precisa
///   ser widget custom (ex: logo).
class CpfSeguroNavigationTopBar extends StatelessWidget {
  const CpfSeguroNavigationTopBar({
    super.key,
    this.left,
    this.right,
    this.title,
    this.titleWidget,
    this.centerAlign = TextAlign.center,
  });

  final CpfSeguroNavigationLeftAccessory? left;
  final CpfSeguroNavigationRightAccessory? right;
  final String? title;
  final Widget? titleWidget;
  final TextAlign centerAlign;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final centerContent = titleWidget ??
        (title != null
            ? Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CpfSeguroType.heading.copyWith(color: s.textSecondary),
              )
            : null);

    // Sem padding vertical: os IconButton (40×40) precisam de 40px de altura
    // livre pro clip do borderRadius pill funcionar. Se comprimir verticalmente,
    // o container do IconButton fica retangular e o pill vira oval.
    return CpfSeguroDevInfo(
      component: 'CpfSeguroNavigationTopBar',
      props: {if (title != null) 'title': "'$title'", if (left != null) 'left': 'accessory', if (right != null) 'right': 'accessory'},
      tokens: const ['h52 · title heading centralizado · left/right accessories'],
      child: Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: CpfSeguroSpacing.s6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (left != null) left! else const SizedBox(width: 40),
          if (centerAlign == TextAlign.center)
            Expanded(child: Center(child: centerContent ?? const SizedBox()))
          else
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: centerContent,
              ),
            ),
          if (right != null) right! else const SizedBox(width: 40),
        ],
      ),
    ),
    );
  }
}
