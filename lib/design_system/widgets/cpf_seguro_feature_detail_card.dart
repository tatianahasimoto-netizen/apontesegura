import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_status_tag.dart';
import 'cpf_seguro_icon_accessory.dart' show CpfSeguroIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Capacidade específica dentro de uma section do FeatureDetailCard.
class CpfSeguroFeatureCapability {
  const CpfSeguroFeatureCapability({required this.icon, required this.label});
  final String icon;
  final String label;
}

/// Section do FeatureDetailCard. [header]=null significa "capacidade do
/// nível atual" — renderiza pills primary; senão pills neutral.
class CpfSeguroFeatureDetailSection {
  const CpfSeguroFeatureDetailSection({this.header, required this.capabilities});
  final String? header;
  final List<CpfSeguroFeatureCapability> capabilities;
}

/// CPF SEGURO — FeatureDetailCard.
///
/// Card grande de detalhe de feature: header (ícone + nome + status) +
/// heading + description + N sections com pills de capacidades separadas
/// por divider tracejado.
///
/// REGRA DAS CAPACIDADES: sempre UMA EMBAIXO DA OUTRA (nunca lado a lado).
/// AZUL (primary) pro que o usuário JÁ TEM; CINZA pro que ainda não tem.
///
/// - Sem [CpfSeguroFeatureDetailSection.header] = capacidades do nível atual
///   (pills azuis primary-04 — já tem).
/// - Com [CpfSeguroFeatureDetailSection.header] = capacidades futuras
///   (pills cinzas neutral-05 — ainda não tem).
class CpfSeguroFeatureDetailCard extends StatelessWidget {
  const CpfSeguroFeatureDetailCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.name,
    required this.nameColor,
    required this.status,
    required this.heading,
    required this.description,
    required this.sections,
    this.iconColor = CpfSeguroColors.white,
  });

  final String icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final Color nameColor;
  final CpfSeguroStatusTagData status;
  final String heading;
  final String description;
  final List<CpfSeguroFeatureDetailSection> sections;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return CpfSeguroDevInfo(
      component: 'CpfSeguroFeatureDetailCard',
      props: {'name': "'$name'", 'icon': icon, 'status': "'${status.label}'", 'sections': '${sections.length}'},
      tokens: ['gradient branco→primary-09 · border primary-08 · radius 16', 'name: ${cpfSeguroColorToken(nameColor)} · pills: azul(já tem)/cinza(não tem)'],
      child: Container(
      padding: const EdgeInsets.all(CpfSeguroSpacing.s4),
      decoration: BoxDecoration(
        // Light = gradient sutil branco→primary-09; dark = surface sólida
        // (primary-09 não tem papel no scheme, então não vai pro dark).
        gradient: s.isDark
            ? null
            : const LinearGradient(
                begin: Alignment(-0.87, -0.5),
                end: Alignment(0.87, 0.5),
                colors: [CpfSeguroColors.white, CpfSeguroColors.primary09],
              ),
        color: s.isDark ? s.surface : null,
        border: Border.all(color: s.primarySubtle, width: 1),
        borderRadius: CpfSeguroRadius.all16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Header ─────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: CpfSeguroRadius.all8,
                ),
                child: CpfSeguroIconAccessory(icon: icon, padding: 0, size: 18, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CpfSeguroType.subheading.copyWith(color: nameColor),
                ),
              ),
              CpfSeguroStatusTag(label: status.label, tone: status.tone),
            ],
          ),
          const SizedBox(height: 16),
          // ─── Heading + description ──────────────────────────────────────
          Text(heading, style: CpfSeguroType.subheading.copyWith(color: s.fg)),
          const SizedBox(height: 4),
          Text(description, style: CpfSeguroType.caption.copyWith(color: s.textPlaceholder)),
          // ─── Sections ──────────────────────────────────────────────────
          for (final section in sections) ...[
            const SizedBox(height: 16),
            const _DashedDivider(),
            const SizedBox(height: 16),
            if (section.header != null) ...[
              _SectionHeaderRow(label: section.header!),
              const SizedBox(height: 16),
            ],
            // SEMPRE uma embaixo da outra — nunca lado a lado.
            for (var i = 0; i < section.capabilities.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              Row(mainAxisSize: MainAxisSize.min, children: [
                _CapabilityPill(
                  cap: section.capabilities[i],
                  variant: section.header == null ? _PillVariant.current : _PillVariant.future,
                ),
              ]),
            ],
          ],
        ],
      ),
    ),
    );
  }
}

enum _PillVariant { current, future }

class _CapabilityPill extends StatelessWidget {
  const _CapabilityPill({required this.cap, required this.variant});
  final CpfSeguroFeatureCapability cap;
  final _PillVariant variant;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    // Azul = já tem · cinza = ainda não tem.
    final accent = variant == _PillVariant.current ? s.primary : s.textPlaceholder;
    return Container(
      height: 24,
      padding: const EdgeInsets.only(left: CpfSeguroSpacing.s2, right: CpfSeguroSpacing.s3),
      decoration: BoxDecoration(
        border: Border.all(color: accent, width: 1),
        borderRadius: CpfSeguroRadius.all200,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CpfSeguroIconAccessory(icon: cap.icon, padding: 0, size: 12, color: accent),
          const SizedBox(width: 4),
          Text(cap.label, style: CpfSeguroType.labelSm.copyWith(color: accent)),
        ],
      ),
    );
  }
}

class _SectionHeaderRow extends StatelessWidget {
  const _SectionHeaderRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    // Separa " · Nível X" pra colorir em primary
    final match = RegExp(r'^(.+?)( · .+)$').firstMatch(label);
    final main = match?.group(1) ?? label;
    final suffix = match?.group(2) ?? '';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CpfSeguroIconAccessory(icon: CpfSeguroIcons.angleDownLight, padding: 0, size: 16, color: s.fg),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            style: CpfSeguroType.label.copyWith(color: s.fg),
            children: [
              TextSpan(text: main),
              if (suffix.isNotEmpty)
                TextSpan(text: suffix, style: TextStyle(color: s.primary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dash = 4.0;
          const gap = 3.0;
          final n = ((constraints.maxWidth + gap) / (dash + gap)).floor();
          return Row(
            children: [
              for (var i = 0; i < n; i++) ...[
                Container(width: dash, height: 1, color: s.divider),
                if (i < n - 1) const SizedBox(width: gap),
              ],
            ],
          );
        },
      ),
    );
  }
}
