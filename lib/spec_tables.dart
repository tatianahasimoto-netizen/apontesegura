import 'package:flutter/widgets.dart';
import 'design_system/cpf_seguro_design_system.dart';
import 'spec_table.dart';

/// Screen com todas as spec tables, no estilo Figma "Instance Table".
/// Cada tabela mostra 100% da matriz de variantes SUPORTADA pelo widget.
/// Nada foi inventado — se uma variante não existe no widget, não aparece aqui.
enum _SpecLayer { tokens, atoms, molecules, organisms }

class SpecTablesScreen extends StatefulWidget {
  const SpecTablesScreen({super.key});
  @override
  State<SpecTablesScreen> createState() => _SpecTablesScreenState();
}

class _SpecTablesScreenState extends State<SpecTablesScreen> {
  _SpecLayer _layer = _SpecLayer.tokens;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Intro(),
          const SizedBox(height: 24),
          _SpecLayerTabs(active: _layer, onTap: (l) => setState(() => _layer = l)),
          ..._specsFor(_layer),
        ],
      ),
    );
  }

  List<Widget> _specsFor(_SpecLayer l) {
    switch (l) {
      case _SpecLayer.tokens:
        return const [
          SpecTierHeader(tier: 'TOKENS', description: 'Fundação — cor, forma, texto. Sem widgets.'),
          _RolesSpec(),
          _GradientTokensSpec(),
          _RadiusTokensSpec(),
          _ShadowTokensSpec(),
          _MotionTokensSpec(),
        ];
      case _SpecLayer.atoms:
        return const [
          SpecTierHeader(tier: 'ATOMS', description: 'Primitivos indivisíveis — cada átomo consome só tokens.'),
          _LogoSpec(),
          _IconAccessorySpec(),
          _GlassSurfaceSpec(),
          _BottomHomeIndicatorSpec(),
          _ActionSpec(),
          _StatusTagSpec(),
          _AmountSpec(),
          _AvatarSpec(),
          _CheckboxSpec(),
          _ToggleSwitchSpec(),
          _LoadingSpinnerSpec(),
          _CriteriaMarkerSpec(),
          _SeeAllLinkSpec(),
          _StatusBarSpec(),
          _IllustrationSpec(),
        ];
      case _SpecLayer.molecules:
        return const [
          SpecTierHeader(tier: 'MOLECULES', description: 'Combinações simples de átomos numa unidade funcional.'),
          _SpotIconSpec(),
          _ButtonSpec(),
          _IconButtonSpec(),
          _OtpInputSpec(),
          _DropdownSpec(),
          _DateFieldSpec(),
          _CalendarSpec(),
          _MenuButtonSpec(),
          _LeftAccessorySpec(),
          _MiddleAccessorySpec(),
          _RightAccessorySpec(),
          _AppListSpec(),
          _ToastSpec(),
          _ChatBubbleSpec(),
          _SectionHeaderSpec(),
          _FeatureCardSpec(),
          _InfoCardSpec(),
          _QuickAccessCardSpec(),
          _EmptyStateSpec(),
          _OfflinePillSpec(),
          _InputChipSpec(),
          _DayGroupSpec(),
          _ReceiptSpec(),
          _AmountDisplaySpec(),
          _DetailRowSpec(),
          _FaceIdCardSpec(),
          _SearchInputSpec(),
          _TooltipSpec(),
          _InputSpec(),
          _RadioListSpec(),
          _PageTitleSpec(),
          _StepperSpec(),
          _NavSpec(),
          _NavigationButtonSpec(),
          _NavigationTopBarSpec(),
          _ChatInputSpec(),
          _ChatTypingIndicatorSpec(),
          _KeyboardSpec(),
        ];
      case _SpecLayer.organisms:
        return const [
          SpecTierHeader(tier: 'ORGANISMS', description: 'Composições em superfície — consomem moléculas.'),
          _TopAppBarSpec(),
          _BottomAppSpec(),
          _PasswordBottomSheetSpec(),
          _ExitConfirmSheetSpec(),
          _BiometriaOverlaySpec(),
        ];
    }
  }
}

/// Sub-abas de camada do Specs (mesmo padrão do Preview).
class _SpecLayerTabs extends StatelessWidget {
  const _SpecLayerTabs({required this.active, required this.onTap});
  final _SpecLayer active;
  final ValueChanged<_SpecLayer> onTap;

  static const _items = [
    (_SpecLayer.tokens, 'Tokens'),
    (_SpecLayer.atoms, 'Atoms'),
    (_SpecLayer.molecules, 'Molecules'),
    (_SpecLayer.organisms, 'Organisms'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final it in _items)
          _SpecLayerPill(label: it.$2, selected: it.$1 == active, onTap: () => onTap(it.$1)),
      ],
    );
  }
}

class _SpecLayerPill extends StatelessWidget {
  const _SpecLayerPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.white,
            borderRadius: CpfSeguroRadius.pillAll,
            border: Border.all(
              color: selected ? CpfSeguroColors.primary04 : CpfSeguroColors.neutral08,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: CpfSeguroType.labelMd.copyWith(
              color: selected ? CpfSeguroColors.white : CpfSeguroColors.neutral03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Spec Tables',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: CpfSeguroColors.neutral01,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Cada tabela mostra 100% da matriz de variantes suportada pelo widget. '
          'Brackets agrupam os eixos (linhas × colunas). Se uma célula não '
          'aparecer, é porque a combinação não é suportada — não invente.',
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: CpfSeguroColors.neutral03,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Button — 5 types × 2 states × 3 sizes (× disabled)
// ═══════════════════════════════════════════════════════════════════════════

class _ButtonSpec extends StatelessWidget {
  const _ButtonSpec();

  // Types de fundo claro (aparecem na matriz principal, sobre a célula branca).
  static const _types = [
    ('primary', CpfSeguroButtonType.primary),
    ('secondary', CpfSeguroButtonType.secondary),
    ('tertiary', CpfSeguroButtonType.tertiary),
  ];

  static const _sizes = [
    ('sm', CpfSeguroButtonSize.sm),
    ('md', CpfSeguroButtonSize.md),
    ('lg', CpfSeguroButtonSize.lg),
  ];

  static const _rowSubs = ['primary', 'secondary', 'tertiary'];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Button',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius', 'Shadow'],
      subtitle: '3 types × 2 states (normal · error) × 3 sizes + status disabled. '
          'Radius sempre pill.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CpfSeguroSpecTable(
            cellWidth: 160,
            cellHeight: 78,
            columnGroups: const [
              SpecAxisGroup(title: 'Default', subs: ['normal', 'error']),
              SpecAxisGroup(title: 'Disabled', subs: ['normal', 'error']),
            ],
            rowGroups: const [
              SpecAxisGroup(title: 'sm', subs: _rowSubs),
              SpecAxisGroup(title: 'md', subs: _rowSubs),
              SpecAxisGroup(title: 'lg', subs: _rowSubs),
            ],
            cellBuilder: (r, c) {
              final sizeIdx = r ~/ 3;
              final typeIdx = r % 3;
              final disabled = c >= 2;
              final state = (c % 2 == 0) ? CpfSeguroButtonState.normal : CpfSeguroButtonState.error;
              return CpfSeguroButton(
                label: 'Button',
                type: _types[typeIdx].$2,
                size: _sizes[sizeIdx].$2,
                state: state,
                disabled: disabled,
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// IconButton — mesmo shape do Button (5 types × 2 states × 3 sizes × disabled)
// ═══════════════════════════════════════════════════════════════════════════

class _IconButtonSpec extends StatelessWidget {
  const _IconButtonSpec();

  static const _types = [
    CpfSeguroIconButtonType.primary,
    CpfSeguroIconButtonType.secondary,
    CpfSeguroIconButtonType.secondaryPrimary,
    CpfSeguroIconButtonType.tertiary,
    CpfSeguroIconButtonType.tertiaryPrimary,
  ];

  static const _typeLabels = ['primary', 'secondary', 'sec-primary', 'tertiary', 'tert-primary'];

  static const _sizes = [CpfSeguroIconButtonSize.sm, CpfSeguroIconButtonSize.md, CpfSeguroIconButtonSize.lg];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'IconButton',
      composedOf: const ['IconAccessory', 'Color', 'Radius'],
      figmaNode: '2281:30785',
      subtitle: '5 types × 2 states × 3 sizes + disabled. Radius pill (100) — '
          'stroke fica redondo no border. Icon size default 14/18/22. Suporta '
          'badge, rotate e flush no widget (não é combinatória do spec — passe direto).',
      child: CpfSeguroSpecTable(
        cellWidth: 100,
        cellHeight: 88,
        columnGroups: const [
          SpecAxisGroup(title: 'Default', subs: ['normal', 'error']),
          SpecAxisGroup(title: 'Disabled', subs: ['normal', 'error']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'sm · 32', subs: _typeLabels),
          SpecAxisGroup(title: 'md · 40', subs: _typeLabels),
          SpecAxisGroup(title: 'lg · 56', subs: _typeLabels),
        ],
        cellBuilder: (r, c) {
          final sizeIdx = r ~/ 5;
          final typeIdx = r % 5;
          final disabled = c >= 2;
          final state = (c % 2 == 0) ? CpfSeguroIconButtonState.normal : CpfSeguroIconButtonState.error;
          return CpfSeguroIconButton(
            icon: CpfSeguroIcons.bellLight,
            semanticLabel: 'demo',
            type: _types[typeIdx],
            size: _sizes[sizeIdx],
            state: state,
            disabled: disabled,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Checkbox — 2 sizes × 2 variants × 3 states × 2 (default/disabled)
// ═══════════════════════════════════════════════════════════════════════════

class _CheckboxSpec extends StatelessWidget {
  const _CheckboxSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Checkbox',
      composedOf: const ['Color', 'Radius'],
      subtitle: '2 sizes (sm 16 / md 20) × 2 variants (primary · neutral) × '
          '3 states (unchecked · checked · indeterminate) × default/disabled. '
          'Label+description são opts do widget — mostrados no catálogo, não aqui.',
      child: CpfSeguroSpecTable(
        cellWidth: 110,
        cellHeight: 60,
        columnGroups: const [
          SpecAxisGroup(title: 'unchecked', subs: ['default', 'disabled']),
          SpecAxisGroup(title: 'checked', subs: ['default', 'disabled']),
          SpecAxisGroup(title: 'indeterminate', subs: ['default', 'disabled']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'sm', subs: ['primary', 'neutral']),
          SpecAxisGroup(title: 'md', subs: ['primary', 'neutral']),
        ],
        cellBuilder: (r, c) {
          final size = r < 2 ? CpfSeguroCheckboxSize.sm : CpfSeguroCheckboxSize.md;
          final variant = (r % 2 == 0) ? CpfSeguroCheckboxVariant.primary : CpfSeguroCheckboxVariant.neutral;
          final stateIdx = c ~/ 2;
          final disabled = c % 2 == 1;
          return CpfSeguroCheckbox(
            size: size,
            variant: variant,
            checked: stateIdx == 1,
            indeterminate: stateIdx == 2,
            disabled: disabled,
            onChanged: (_) {},
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ToggleSwitch — 2 sizes × on/off × 4 statuses
// ═══════════════════════════════════════════════════════════════════════════

class _ToggleSwitchSpec extends StatelessWidget {
  const _ToggleSwitchSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'ToggleSwitch',
      composedOf: const ['Color', 'Radius'],
      figmaNode: '2365:32193',
      subtitle: '2 sizes (sm 36×20 / md 44×24) × on/off × default/disabled. '
          'Status hover/focus são state interno (mouse) — não formam célula '
          'estática. Focus ring é #F1F2F6 4px quando o widget está focado.',
      child: CpfSeguroSpecTable(
        cellWidth: 130,
        cellHeight: 60,
        columnGroups: const [
          SpecAxisGroup(title: 'off', subs: ['default', 'disabled']),
          SpecAxisGroup(title: 'on', subs: ['default', 'disabled']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'size', subs: ['sm · 36×20', 'md · 44×24']),
        ],
        cellBuilder: (r, c) {
          final size = r == 0 ? CpfSeguroToggleSize.sm : CpfSeguroToggleSize.md;
          final value = c >= 2;
          final disabled = c % 2 == 1;
          return CpfSeguroToggleSwitch(
            value: value,
            onChanged: (_) {},
            size: size,
            disabled: disabled,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SpotIcon — 2 types × 8 states
// ═══════════════════════════════════════════════════════════════════════════

class _SpotIconSpec extends StatelessWidget {
  const _SpotIconSpec();

  static const _states = [
    ('normal', CpfSeguroSpotState.normal),
    ('disabled', CpfSeguroSpotState.disabled),
    ('primary', CpfSeguroSpotState.primary),
    ('error', CpfSeguroSpotState.error),
    ('warning', CpfSeguroSpotState.warning),
    ('success', CpfSeguroSpotState.success),
    ('loading', CpfSeguroSpotState.loading),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'SpotIcon',
      composedOf: const ['IconAccessory', 'Color'],
      subtitle: '2 types (fill · outline) × 7 states. Size default 34 (mobile), '
          'icon escala pra ~58% do container. Badge é orthogonal — passe direto.',
      child: CpfSeguroSpecTable(
        cellWidth: 90,
        cellHeight: 76,
        columnGroups: const [
          SpecAxisGroup(title: 'State', subs: ['normal', 'disabled', 'primary', 'error', 'warning', 'success', 'loading']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Type', subs: ['fill', 'outline']),
        ],
        cellBuilder: (r, c) {
          final type = r == 0 ? CpfSeguroSpotType.fill : CpfSeguroSpotType.outline;
          return CpfSeguroSpotIcon(icon: CpfSeguroIcons.userLight, type: type, state: _states[c].$2);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Action — 7 directions
// ═══════════════════════════════════════════════════════════════════════════

class _ActionSpec extends StatelessWidget {
  const _ActionSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Action',
      composedOf: const ['IconAccessory', 'Color'],
      subtitle: '7 directions. Size + color já vêm por direction — não são '
          'combinatórias. onPressed é opt.',
      child: CpfSeguroSpecTable(
        cellWidth: 90,
        cellHeight: 60,
        columnGroups: const [
          SpecAxisGroup(title: 'Direction', subs: [
            'right', 'up', 'down', 'more', 'check', 'clock', 'error',
          ]),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroAction(direction: CpfSeguroActionDirection.values[c]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// StatusTag — 6 tones × 2 (com/sem ícone)
// ═══════════════════════════════════════════════════════════════════════════

class _IconAccessorySpec extends StatelessWidget {
  const _IconAccessorySpec();
  @override
  Widget build(BuildContext context) => SpecSection(
        title: 'IconAccessory',
        composedOf: const ['Icon', 'Color'],
        subtitle: 'Icone puro (bare) + badge opcional. Atomo base consumido por '
            'SpotIcon, IconButton e slots do AppList.',
        child: Wrap(spacing: 20, children: const [
          CpfSeguroIconAccessory(icon: CpfSeguroIcons.bellLight, size: 24),
          CpfSeguroIconAccessory(icon: CpfSeguroIcons.userLight, size: 24),
          CpfSeguroIconAccessory(
              icon: CpfSeguroIcons.bellLight, size: 24, badge: CpfSeguroBadge.primary),
        ]),
      );
}

class _GlassSurfaceSpec extends StatelessWidget {
  const _GlassSurfaceSpec();
  @override
  Widget build(BuildContext context) => SpecSection(
        title: 'GlassSurface',
        composedOf: const ['Scheme', 'Color'],
        subtitle: 'Superficie translucida (blur) — fundo de top/bottom bar sobre conteudo.',
        child: Container(
          padding: const EdgeInsets.all(16),
          color: CpfSeguroColors.primary04,
          child: CpfSeguroGlassSurface(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: const Text('conteudo sobre glass'),
            ),
          ),
        ),
      );
}

class _BottomHomeIndicatorSpec extends StatelessWidget {
  const _BottomHomeIndicatorSpec();
  @override
  Widget build(BuildContext context) => SpecSection(
        title: 'BottomHomeIndicator',
        composedOf: const ['Color'],
        subtitle: 'Barra home do iOS (gesture bar) na base das superficies.',
        child: const SizedBox(width: 200, child: CpfSeguroBottomHomeIndicator()),
      );
}

class _AmountSpec extends StatelessWidget {
  const _AmountSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Amount',
      figmaNode: '2415:36885',
      composedOf: const ['Color', 'Typography', 'Radius'],
      subtitle: 'Valor compacto de linha. labelSm neutral-02. cashIn = chip '
          'success-07 + "+"; cashOut = "−"; cashBack = tachado. Consumido por '
          'right.amount (o acessório não desenha — só posiciona).',
      child: Wrap(spacing: 24, runSpacing: 12, children: const [
        CpfSeguroAmount.cashIn(value: 'R\$ 560,00'),
        CpfSeguroAmount.cashOut(value: 'R\$ 560,00'),
        CpfSeguroAmount.cashBack(value: 'R\$ 560,00'),
      ]),
    );
  }
}

class _StatusTagSpec extends StatelessWidget {
  const _StatusTagSpec();

  static const _tones = [
    ('warning', CpfSeguroStatusTone.warning),
    ('neutral', CpfSeguroStatusTone.neutral),
    ('primary', CpfSeguroStatusTone.primary),
    ('success', CpfSeguroStatusTone.success),
    ('danger', CpfSeguroStatusTone.danger),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'StatusTag',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: '5 tones × 2 (com/sem ícone à esquerda). Height fixo 20, '
          'border 0.5.',
      child: CpfSeguroSpecTable(
        cellWidth: 140,
        cellHeight: 52,
        columnGroups: const [
          SpecAxisGroup(title: 'Icon', subs: ['sem', 'com']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Tone', subs: ['warning', 'neutral', 'primary', 'success', 'danger']),
        ],
        cellBuilder: (r, c) {
          final tone = _tones[r].$2;
          return CpfSeguroStatusTag(
            label: _tones[r].$1,
            tone: tone,
            icon: c == 1 ? 'shield-user-solid-full' : null,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Avatar — 2 variants
// ═══════════════════════════════════════════════════════════════════════════

class _AvatarSpec extends StatelessWidget {
  const _AvatarSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Avatar',
      composedOf: const ['Color', 'Typography'],
      subtitle: '2 variants (outlined · solid). Size fixo 40, iniciais 16/500.',
      child: CpfSeguroSpecTable(
        cellWidth: 100,
        cellHeight: 72,
        columnGroups: const [
          SpecAxisGroup(title: 'Variant', subs: ['outlined', 'solid']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroAvatar(
          initials: 'AM',
          variant: c == 0 ? CpfSeguroAvatarVariant.outlined : CpfSeguroAvatarVariant.solid,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LoadingSpinner — 3 sizes
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingSpinnerSpec extends StatelessWidget {
  const _LoadingSpinnerSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'LoadingSpinner',
      composedOf: const ['Color'],
      figmaNode: '1539:3239',
      subtitle: '3 sizes (sm 22 / md 40 / lg 60). Track neutral-07 + arco 75% '
          'primary-04, rotação 900ms linear infinite.',
      child: CpfSeguroSpecTable(
        cellWidth: 100,
        cellHeight: 80,
        columnGroups: const [
          SpecAxisGroup(title: 'Size', subs: ['sm · 22', 'md · 40', 'lg · 60']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroLoadingSpinner(size: CpfSeguroSpinnerSize.values[c]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OtpInput — 4 states
// ═══════════════════════════════════════════════════════════════════════════

class _OtpInputSpec extends StatelessWidget {
  const _OtpInputSpec();

  static const _cases = [
    ('empty (focus na 1ª)', '', null),
    ('parcial (3 dígitos)', '123', null),
    ('completo', '123456', null),
    ('erro', '1234', 'Código incorreto'),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'OtpInput',
      composedOf: const ['Color', 'Typography', 'Radius', 'Motion'],
      subtitle: 'INTERATIVO (v0.24): TextField transparente sobre os boxes '
          'captura teclado numérico + onChanged/onCompleted + obscure. Estado por '
          'box: default (neutral-07) · filled (neutral-01) · focused (primary-04) '
          '· error (error-04 em todos). Células abaixo = snapshots de valor.',
      child: CpfSeguroSpecTable(
        cellWidth: 320,
        cellHeight: 90,
        columnGroups: const [
          SpecAxisGroup(title: 'Estado', subs: ['empty', 'parcial', 'completo', 'erro']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroOtpInput(value: _cases[c].$2, error: _cases[c].$3),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Dropdown — 4 states (campo fechado; abre bottomsheet no toque)
// ═══════════════════════════════════════════════════════════════════════════

class _DropdownSpec extends StatelessWidget {
  const _DropdownSpec();

  // (label, value, error, disabled)
  static const _cases = [
    ('vazio', null, null, false),
    ('selecionado', 'CPF', null, false),
    ('erro', null, 'Escolha um tipo', false),
    ('disabled', 'CPF', null, true),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Dropdown',
      composedOf: const ['Input', 'Icon', 'Radius', 'Typography'],
      subtitle: 'Palavra própria (não é Input com truque): escolher de uma lista '
          'FECHADA. Gatilho = Input readOnly + chevron-down; toque abre um '
          'bottomsheet de seleção (single-select, check no ativo). Células = o '
          'campo fechado em 4 estados.',
      child: CpfSeguroSpecTable(
        cellWidth: 260,
        cellHeight: 110,
        columnGroups: const [
          SpecAxisGroup(title: 'Estado', subs: ['vazio', 'selecionado', 'erro', 'disabled']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroDropdown(
          placeholder: 'Selecione',
          items: const ['CPF', 'Celular', 'E-mail'],
          value: _cases[c].$2,
          error: _cases[c].$3,
          disabled: _cases[c].$4,
          onChanged: (_) {},
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DateField — 4 states (campo; abre Calendar no toque)
// ═══════════════════════════════════════════════════════════════════════════

class _DateFieldSpec extends StatelessWidget {
  const _DateFieldSpec();

  static final _cases = <(String, DateTime?, String?, bool)>[
    ('vazio', null, null, false),
    ('preenchido', DateTime(1990, 5, 12), null, false),
    ('erro', null, 'Data obrigatória', false),
    ('disabled', DateTime(1990, 5, 12), null, true),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'DateField',
      composedOf: const ['Input', 'Calendar', 'Icon', 'Radius'],
      subtitle: 'Campo de data = Input readOnly + ícone de calendário que abre o '
          'Calendar num bottomsheet. Formata dd/MM/aaaa. Células = campo em 4 '
          'estados.',
      child: CpfSeguroSpecTable(
        cellWidth: 260,
        cellHeight: 110,
        columnGroups: const [
          SpecAxisGroup(title: 'Estado', subs: ['vazio', 'preenchido', 'erro', 'disabled']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => CpfSeguroDateField(
          value: _cases[c].$2,
          error: _cases[c].$3,
          disabled: _cases[c].$4,
          onChanged: (_) {},
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Calendar — superfície (grid mensal)
// ═══════════════════════════════════════════════════════════════════════════

class _CalendarSpec extends StatelessWidget {
  const _CalendarSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Calendar',
      composedOf: const ['Icon', 'Motion', 'Typography', 'Spacing'],
      subtitle: 'Superfície de seleção de data — grid mensal em Flutter puro (sem '
          'pacote). Semana começa no domingo. Dia selecionado = círculo primary; '
          'fora de firstDay/lastDay = desabilitado; setas usam Motion.medium.',
      child: CpfSeguroSpecTable(
        cellWidth: 320,
        cellHeight: 340,
        columnGroups: const [
          SpecAxisGroup(title: '', subs: ['mês com dia selecionado']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.all(12),
          child: CpfSeguroCalendar(
            initialMonth: DateTime(1990, 5),
            selectedDate: DateTime(1990, 5, 12),
            onDateSelected: (_) {},
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MenuButton — 2 variants × 3 states
// ═══════════════════════════════════════════════════════════════════════════

class _MenuButtonSpec extends StatelessWidget {
  const _MenuButtonSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'MenuButton',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: '2 variants (vertical rail / horizontal contextual) × 3 states '
          '(default · hover · selected). Hover é state interno (mouse) — não '
          'renderiza estático; mostramos default e selected estáticos.',
      child: CpfSeguroSpecTable(
        cellWidth: 130,
        cellHeight: 100,
        columnGroups: const [
          SpecAxisGroup(title: 'State', subs: ['default', 'selected']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variant', subs: ['vertical', 'horizontal']),
        ],
        cellBuilder: (r, c) => CpfSeguroMenuButton(
          icon: CpfSeguroIcons.chartLineSolid,
          label: 'Dashboard',
          variant: r == 0 ? CpfSeguroMenuButtonVariant.vertical : CpfSeguroMenuButtonVariant.horizontal,
          active: c == 1,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Logo — 2 variants × 3 sizes
// ═══════════════════════════════════════════════════════════════════════════

class _LogoSpec extends StatelessWidget {
  const _LogoSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Logo',
      composedOf: const ['Color'],
      subtitle: '2 variants (mark · full). Cor via ColorFilter — mostramos '
          'primary-04 (default) e white (sobre bg escuro). Size é livre.',
      child: CpfSeguroSpecTable(
        cellWidth: 140,
        cellHeight: 76,
        columnGroups: const [
          SpecAxisGroup(title: 'Size', subs: ['24', '40', '64']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variant', subs: ['mark', 'full']),
        ],
        cellBuilder: (r, c) {
          final variant = r == 0 ? CpfSeguroLogoVariant.mark : CpfSeguroLogoVariant.full;
          final size = [24.0, 40.0, 64.0][c];
          return CpfSeguroLogo(variant: variant, size: size);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Toast — 4 states × 2 (com/sem subtitle)
// ═══════════════════════════════════════════════════════════════════════════

class _ToastSpec extends StatelessWidget {
  const _ToastSpec();

  static const _states = [
    ('normal', CpfSeguroToastState.normal),
    ('success', CpfSeguroToastState.success),
    ('error', CpfSeguroToastState.error),
    ('warning', CpfSeguroToastState.warning),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Toast',
      composedOf: const ['SpotIcon', 'GlassSurface', 'Color', 'Typography', 'Radius', 'Shadow'],
      figmaNode: '2881:42481',
      subtitle: '4 states × 2 (só title · title+subtitle). SpotIcon default do '
          'state pode ser sobrescrito via prop icon. Bg tint 70% + border tint '
          '(spec Figma).',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 88,
        columnGroups: const [
          SpecAxisGroup(title: 'Conteúdo', subs: ['title', 'title + subtitle']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'State', subs: ['normal', 'success', 'error', 'warning']),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.all(8),
          child: CpfSeguroToast(
            state: _states[r].$2,
            title: 'Toast ${_states[r].$1}',
            subtitle: c == 1 ? 'Mensagem secundária com contexto.' : null,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ChatBubble — 2 from × 2 (default/wide) × 2 (com/sem editable)
// ═══════════════════════════════════════════════════════════════════════════

class _ChatBubbleSpec extends StatelessWidget {
  const _ChatBubbleSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'ChatBubble',
      composedOf: const ['Color', 'Typography', 'Radius'],
      subtitle: '2 from (bot bottom-left · user bottom-right). Hug-content, '
          'wmax 250 (bot E user), padding 16 v+h. Editable+onEdit renderiza '
          '"Alterar" abaixo — só faz sentido em user. Wide solta o teto de 250 '
          '(CriteriaBubble multi-item). Loading = bolha própria fixa 80×54 '
          '(ver ChatTypingIndicator).',
      child: CpfSeguroSpecTable(
        cellWidth: 220,
        cellHeight: 132,
        columnGroups: const [
          SpecAxisGroup(title: 'Editable', subs: ['—', 'true']),
          SpecAxisGroup(title: 'Wide', subs: ['—', 'true']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'From', subs: ['bot', 'user']),
        ],
        cellBuilder: (r, c) {
          final from = r == 0 ? CpfSeguroChatFrom.bot : CpfSeguroChatFrom.user;
          final editable = c == 1;
          final wide = c == 3;
          // Editable só faz sentido em user (widget ignora em bot).
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CpfSeguroChatBubble(
              from: from,
              editable: editable,
              wide: wide,
              onEdit: () {},
              child: const Text('Fala do chat.'),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CriteriaItem — 3 status
// ═══════════════════════════════════════════════════════════════════════════

class _CriteriaMarkerSpec extends StatelessWidget {
  const _CriteriaMarkerSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Criteria (marker)',
      subtitle: '3 status do CpfSeguroCriteriaItem dentro do ChatCriteriaBubble. '
          'Pending vira ring cinza, ok vira check verde, fail vira x vermelho.',
      child: CpfSeguroSpecTable(
        cellWidth: 240,
        cellHeight: 76,
        columnGroups: const [
          SpecAxisGroup(title: 'Status', subs: ['pending', 'ok', 'fail']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '', subs: ['·']),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.all(8),
          child: CpfSeguroChatCriteriaBubble(
            items: [
              CpfSeguroCriteriaItem(
                label: ['pending', 'ok', 'fail'][c],
                status: CpfSeguroCriteriaStatus.values[c],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppList — row completa (composições comuns)
// ═══════════════════════════════════════════════════════════════════════════

class _AppListSpec extends StatelessWidget {
  const _AppListSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'AppListRow (row completa)',
      figmaNode: '141:15428',
      subtitle: 'AppListRow = Left + Middle (expanded) + Right. Row PURA, não '
          'sabe da vizinhança e não desenha separador. Cada slot é sealed class '
          'com named constructors. O separador é da COLEÇÃO AppList '
          '(.carded/.plain/.menu). Cada linha abaixo é uma composição válida.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 180,
        columnGroups: const [
          SpecAxisGroup(title: 'Padrão', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Composição', subs: [
            'spotIcon + titleSubtitle + chevron',
            'spotIcon + titleSubtitle + time',
            'spotIcon + titleSubtitle + timeStatus',
            'avatar + labelTitleSubtitle + chevron',
            'iconAccessory + title + statusTag',
            'spotIcon + titleSubtitle + toggle',
          ]),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: [
            const CpfSeguroAppListRow(
              left: CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
              middle: CpfSeguroMiddleAccessory.titleSubtitle(title: 'Dados pessoais', subtitle: 'Nome, CPF, nascimento'),
              right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
            ),
            CpfSeguroAppListRow(
              left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.shieldUserSolidFull, state: CpfSeguroSpotState.success),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Login em Aurora', subtitle: 'Por mim · Biometria'),
              right: CpfSeguroRightAccessory.time(time: '14min'),
            ),
            CpfSeguroAppListRow(
              left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.xmarkSolid, state: CpfSeguroSpotState.error),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Login negado', subtitle: 'Bloqueado por Pausa CPF'),
              right: CpfSeguroRightAccessory.timeStatus(
                time: '2h',
                status: const CpfSeguroStatusTagData(label: 'Negado', tone: CpfSeguroStatusTone.danger),
              ),
            ),
            const CpfSeguroAppListRow(
              left: CpfSeguroLeftAccessory.avatar(initials: 'AM'),
              middle: CpfSeguroMiddleAccessory.labelTitleSubtitle(
                label: 'ÚLTIMO ACESSO',
                title: 'Ana Maria',
                subtitle: 'Faz 3 min',
              ),
              right: CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.right),
            ),
            const CpfSeguroAppListRow(
              left: CpfSeguroLeftAccessory.iconAccessory(icon: CpfSeguroIcons.bellLight, size: 28),
              middle: CpfSeguroMiddleAccessory.title(title: 'Notificações'),
              right: CpfSeguroRightAccessory.status(label: '3 novas', tone: CpfSeguroStatusTone.primary),
            ),
            CpfSeguroAppListRow(
              left: const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.fingerprintLight, state: CpfSeguroSpotState.primary),
              middle: const CpfSeguroMiddleAccessory.titleSubtitle(title: 'Biometria', subtitle: 'Face ID · Touch ID'),
              right: CpfSeguroRightAccessory.toggle(value: true, onChanged: (_) {}),
            ),
          ][r],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LeftAccessory — 5 variantes
// ═══════════════════════════════════════════════════════════════════════════

class _LeftAccessorySpec extends StatelessWidget {
  const _LeftAccessorySpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'LeftAccessory',
      subtitle: 'Sealed class com 3 named constructors (spotIcon/avatar/'
          'iconAccessory). Sempre height 72, centraliza vertical. '
          'Sem escape hatch custom — vocabulário fechado.',
      child: CpfSeguroSpecTable(
        cellWidth: 120,
        cellHeight: 88,
        columnGroups: const [
          SpecAxisGroup(title: 'Preview', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Constructor', subs: [
            'spotIcon()',
            'avatar()',
            'iconAccessory()',
          ]),
        ],
        cellBuilder: (r, c) => [
          const CpfSeguroLeftAccessory.spotIcon(icon: CpfSeguroIcons.userLight),
          const CpfSeguroLeftAccessory.avatar(initials: 'AM'),
          const CpfSeguroLeftAccessory.iconAccessory(icon: CpfSeguroIcons.bellLight, size: 28),
        ][r],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MiddleAccessory — 4 variantes × 2 states
// ═══════════════════════════════════════════════════════════════════════════

class _MiddleAccessorySpec extends StatelessWidget {
  const _MiddleAccessorySpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'MiddleAccessory',
      figmaNode: '2517:38361',
      subtitle: '9 variants de layout de texto (Figma), vocabulário fechado. '
          'Sempre Expanded (ocupa espaço entre Left e Right). Prop `size` alterna '
          '(md 72h / sm 36h) e muda a tipografia. `favorite: true` mostra '
          'estrela 16px nas variants que suportam (só em md).',
      child: CpfSeguroSpecTable(
        cellWidth: 320,
        cellHeight: 82,
        columnGroups: const [
          SpecAxisGroup(title: 'Size', subs: ['md · 72h', 'sm · 36h']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variants Figma (9)', subs: [
            'title()',
            'subtitle()',
            'titleSubtitle()',
            'titleSubtitleSubtitle()',
            'titleSubtitleTag()',
            'titleSubtitleAtitleTag() · md',
            'titleSubtitleAtitleAsubtitle() · md',
            'labelTitleSubtitle()',
            'titleBodyLabel() · sm',
          ]),
        ],
        cellBuilder: (r, c) {
          final size = c == 0 ? CpfSeguroMiddleSize.md : CpfSeguroMiddleSize.sm;
          final middle = [
            CpfSeguroMiddleAccessory.title(title: 'Só título', size: size, favorite: true),
            CpfSeguroMiddleAccessory.subtitle(subtitle: 'Só subtitle', size: size),
            CpfSeguroMiddleAccessory.titleSubtitle(title: 'Título', subtitle: 'Subtitle · sublinha', size: size, favorite: true),
            CpfSeguroMiddleAccessory.titleSubtitleSubtitle(title: 'Título', subtitle: 'Sub', accessorySubtitle: 'aSub', size: size),
            const CpfSeguroMiddleAccessory.titleSubtitleTag(
              title: 'Título',
              subtitle: 'Subtitle',
              tagLabel: 'Novo',
              tagTone: CpfSeguroStatusTone.primary,
            ),
            // Apenas md — sm cai em fallback visual
            const CpfSeguroMiddleAccessory.titleSubtitleAtitleTag(
              title: 'Título',
              subtitle: 'Subtitle',
              accessoryTitle: 'R\$ 100',
              tagLabel: 'Pago',
              tagTone: CpfSeguroStatusTone.success,
            ),
            const CpfSeguroMiddleAccessory.titleSubtitleAtitleAsubtitle(
              title: 'Título',
              subtitle: 'Subtitle',
              accessoryTitle: 'R\$ 100',
              accessorySubtitle: '5 min',
            ),
            CpfSeguroMiddleAccessory.labelTitleSubtitle(label: 'EYEBROW', title: 'Título', subtitle: 'Subtitle', size: size, favorite: true),
            const CpfSeguroMiddleAccessory.titleBodyLabel(title: 'Título', body: 'Body text', label: 'FOOTER LABEL'),
          ][r];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: size == CpfSeguroMiddleSize.md ? 72 : 36,
              child: Row(children: [middle]),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RightAccessory — 8 variantes
// ═══════════════════════════════════════════════════════════════════════════

class _RightAccessorySpec extends StatelessWidget {
  const _RightAccessorySpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'RightAccessory',
      figmaNode: '2456:35494',
      subtitle: '7 variantes canônicas do Figma + iconAccessory (ícone tonalizado '
          'bare). Sempre height 72, alinha end. Helpers estáticos `time()`/'
          '`timeStatus()` são sugar nomeado (sem custom público — a porta dos '
          'fundos foi removida).',
      child: CpfSeguroSpecTable(
        cellWidth: 170,
        cellHeight: 88,
        columnGroups: const [
          SpecAxisGroup(title: 'Preview', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Figma variants (7)', subs: [
            'action()',
            'icon()',
            'status()',
            'amountChip()',
            'toggle()',
            'checkbox()',
            'radio()',
          ]),
          SpecAxisGroup(title: 'DS extras (3)', subs: [
            'iconAccessory()',
            'time() · sugar',
            'timeStatus() · sugar',
          ]),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: [
            // Figma canônicos
            const CpfSeguroRightAccessory.action(direction: CpfSeguroActionDirection.more),
            const CpfSeguroRightAccessory.icon(icon: CpfSeguroIcons.bellLight, semanticLabel: 'Notificações'),
            const CpfSeguroRightAccessory.status(label: 'Novo', tone: CpfSeguroStatusTone.primary),
            const CpfSeguroRightAccessory.amountChip(amount: 'R\$ 560,00'),
            CpfSeguroRightAccessory.toggle(value: true, onChanged: (_) {}),
            CpfSeguroRightAccessory.checkbox(checked: true, onChanged: (_) {}),
            CpfSeguroRightAccessory.radio(selected: true, onPressed: () {}),
            // DS extras
            const CpfSeguroRightAccessory.iconAccessory(
                icon: CpfSeguroIcons.circleCheckSolid, tone: CpfSeguroStatusTone.success),
            CpfSeguroRightAccessory.time(time: '14min'),
            CpfSeguroRightAccessory.timeStatus(
              time: '2h',
              status: const CpfSeguroStatusTagData(label: 'Negado', tone: CpfSeguroStatusTone.danger),
            ),
          ][r],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Radius tokens
// ═══════════════════════════════════════════════════════════════════════════

class _MotionTokensSpec extends StatelessWidget {
  const _MotionTokensSpec();

  static const _durations = <(String, String)>[
    ('micro', '120 — hover, cor'),
    ('short', '150 — toggle, focus, fade'),
    ('medium', '250 — sheet, toast (default)'),
    ('slow', '400 — página/push'),
    ('deliberate', '600 — hero/ênfase'),
    ('spinner', '700 — loop do spinner (não é transição)'),
  ];
  static const _easings = <(String, String)>[
    ('enter', 'easeOut — chegando (desacelera)'),
    ('exit', 'easeIn — saindo (acelera)'),
    ('standard', 'easeInOut — move on-screen'),
    ('emphasized', 'easeOutCubic — hero'),
  ];
  static const _contexts = <(String, String)>[
    ('fade', 'short + enter — scrim/overlay'),
    ('sheet', 'medium + enter — bottomsheet'),
    ('toast', 'medium + enter — notificação do topo'),
    ('page', 'slow + standard — transição de página'),
    ('control', 'short + enter — toggle/checkbox/focus'),
    ('emphasis', 'deliberate + emphasized — hero'),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Motion tokens (duração · easing · contexto)',
      subtitle: 'Fonte única do movimento — padrão DTCG (duration + cubicBezier). '
          'O componente consome um CONTEXTO (par duração+curva), nunca valor '
          'solto. Extraído do uso real: easeOut domina a entrada, easeIn a saída.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _group('Duração (ms)', _durations),
          _group('Easing (curva)', _easings),
          _group('Contexto (duração + curva)', _contexts),
        ],
      ),
    );
  }

  Widget _group(String title, List<(String, String)> rows) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: CpfSeguroType.labelSm
                    .copyWith(color: CpfSeguroColors.neutral02)),
            const SizedBox(height: 6),
            for (final (name, use) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 130,
                        child: Text(name,
                            style: CpfSeguroType.labelSm.copyWith(
                                color: CpfSeguroColors.primary04))),
                    Expanded(
                        child: Text(use,
                            style: CpfSeguroType.caption.copyWith(
                                color: CpfSeguroColors.neutral04))),
                  ],
                ),
              ),
          ],
        ),
      );
}

class _RadiusTokensSpec extends StatelessWidget {
  const _RadiusTokensSpec();

  static const _tokens = <(String, String, BorderRadius)>[
    ('all2', '2 · battery, dashed dividers', CpfSeguroRadius.all2),
    ('all8', '8 · checkbox, numpad, amountChip', CpfSeguroRadius.all8),
    ('all16 · card', '16 · cards, MenuButton', CpfSeguroRadius.all16),
    ('all24 · sheet · chatButton', '24 · bottomsheets, AppListGroup, ChatBtn, Nav', CpfSeguroRadius.all24),
    ('all200 · pill', '200 · StatusTag, Button, chips, IconBtn', CpfSeguroRadius.all200),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Radius tokens (5 padronizados)',
      subtitle: 'Escala fechada — 2 · 8 · 16 · 24 · 200. Se um contexto pedir '
          '12, arredonda pro mais próximo (16). Aliases semânticos: '
          'chatBubble=24 · chatAnchor=0 · chatButton=24 · card=16 · sheet=24 '
          '· pill=200. Zero BorderRadius.circular(N) solto na base.',
      child: CpfSeguroSpecTable(
        cellWidth: 300,
        cellHeight: 80,
        columnGroups: const [
          SpecAxisGroup(title: 'Preview', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Token', subs: [
            'all2', 'all8', 'all16', 'all24', 'all200',
          ]),
        ],
        cellBuilder: (r, c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: CpfSeguroColors.primary08,
                  border: Border.all(color: CpfSeguroColors.primary04, width: 1),
                  borderRadius: _tokens[r].$3,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _tokens[r].$2,
                  style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Shadow tokens
// ═══════════════════════════════════════════════════════════════════════════

class _ShadowTokensSpec extends StatelessWidget {
  const _ShadowTokensSpec();

  static const _tokens = <(String, Color, Offset, double, String)>[
    ('blackAlpha20', CpfSeguroColors.blackAlpha20, Offset(0, 4), 10, 'tooltip, gap marker (dev mode)'),
    ('blackAlpha40', CpfSeguroColors.blackAlpha40, Offset(0, 4), 12, 'sheet scrim, biometria overlay'),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Shadow tokens (alphas da paleta)',
      subtitle: 'Cada sombra é um alpha de uma cor da paleta. Nome do token diz '
          'a cor base + a opacidade — ex: `blackAlpha40` = black @ 40%. Se um '
          'contexto pede variante nova, criar em CpfSeguroColors ANTES de '
          'consumir no widget.',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 96,
        columnGroups: const [
          SpecAxisGroup(title: 'Preview', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'NEUTRAL (2)', subs: [
            'blackAlpha20', 'blackAlpha40',
          ]),
        ],
        cellBuilder: (r, c) {
          final t = _tokens[r];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: CpfSeguroColors.white,
                    borderRadius: CpfSeguroRadius.all8,
                    boxShadow: [BoxShadow(color: t.$2, offset: t.$3, blurRadius: t.$4)],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'offset ${t.$3.dx.toInt()},${t.$3.dy.toInt()} · blur ${t.$4.toInt()}',
                        style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'uso: ${t.$5}',
                        style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Gradient tokens (degrades)
// ═══════════════════════════════════════════════════════════════════════════

class _GradientTokensSpec extends StatelessWidget {
  const _GradientTokensSpec();

  static const _tokens = <(String, Gradient, String, String)>[
    (
      'brandLift',
      CpfSeguroGradients.brandLift,
      'primary-05 → primary-03',
      'banner "PARA VOCÊ"',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Gradient tokens (degrades)',
      subtitle: 'Todo degrade do DS mora em CpfSeguroGradients. Paridade 1:1 '
          'com o React (`--banner-gradient`). '
          'Uso: `BoxDecoration(gradient: CpfSeguroGradients.brandLift)`. '
          'Se um contexto precisa de novo gradient, criar aqui ANTES de consumir.',
      child: CpfSeguroSpecTable(
        cellWidth: 360,
        cellHeight: 120,
        columnGroups: const [
          SpecAxisGroup(title: 'Preview', subs: ['·']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'DEGRADES (1)', subs: [
            'brandLift',
          ]),
        ],
        cellBuilder: (r, c) {
          final t = _tokens[r];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 80,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    gradient: t.$2,
                    borderRadius: CpfSeguroRadius.all8,
                    border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.$3,
                        style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'uso: ${t.$4}',
                        style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral03),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SectionHeader — com/sem trailing
// ═══════════════════════════════════════════════════════════════════════════

class _SectionHeaderSpec extends StatelessWidget {
  const _SectionHeaderSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'SectionHeader',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Eyebrow de seção da Home. Trailing opcional (SeeAllLink).',
      child: CpfSeguroSpecTable(
        cellWidth: 360,
        cellHeight: 44,
        columnGroups: const [
          SpecAxisGroup(title: 'Trailing', subs: ['sem', 'com SeeAllLink']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['default']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: CpfSeguroSectionHeader(
            label: 'PARA VOCÊ',
            trailing: c == 1 ? const CpfSeguroSeeAllLink() : null,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FeatureCard — 3 exemplos canônicos do carrossel
// ═══════════════════════════════════════════════════════════════════════════

class _FeatureCardSpec extends StatelessWidget {
  const _FeatureCardSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'FeatureCard',
      composedOf: const ['IconAccessory', 'StatusTag', 'Color', 'Gradients', 'Typography', 'Radius'],
      subtitle: '150×150 · bg gradient card-pv · brandColor tinge ícone+título. '
          'ActionLabel opcional (linha inferior com seta).',
      child: CpfSeguroSpecTable(
        cellWidth: 170,
        cellHeight: 170,
        columnGroups: const [
          SpecAxisGroup(title: 'Feature', subs: ['Sou eu!', 'CPF Seguro', 'Carteira']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['card']),
        ],
        cellBuilder: (r, c) => switch (c) {
          0 => const CpfSeguroFeatureCard(
              icon: CpfSeguroIcons.fingerprintLight,
              title: 'Sou eu!',
              brandColor: CpfSeguroColors.primary04,
              status: CpfSeguroStatusTagData(label: 'Limitado', tone: CpfSeguroStatusTone.warning),
              description: 'Login · Autenticar',
              actionLabel: 'Ativar login por código',
            ),
          1 => const CpfSeguroFeatureCard(
              icon: CpfSeguroIcons.idCardLight,
              title: 'CPF Seguro',
              brandColor: CpfSeguroColors.neutral04,
              status: CpfSeguroStatusTagData(label: 'Te esperando', tone: CpfSeguroStatusTone.neutral, icon: CpfSeguroIcons.lockLight),
              description: 'Pausar CPF',
              actionLabel: 'Ativar Pausa',
            ),
          _ => const CpfSeguroFeatureCard(
              icon: CpfSeguroIcons.walletLight,
              title: 'Carteira',
              brandColor: CpfSeguroColors.warning04,
              status: CpfSeguroStatusTagData(label: 'Em breve', tone: CpfSeguroStatusTone.warning, icon: CpfSeguroIcons.lockLight),
              description: 'Cartões num só lugar.',
            ),
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QuickAccessCard — 2 states (active / inactive)
// ═══════════════════════════════════════════════════════════════════════════

class _QuickAccessCardSpec extends StatelessWidget {
  const _QuickAccessCardSpec();

  static const _states = [
    ('active', CpfSeguroQuickAccessState.active),
    ('inactive', CpfSeguroQuickAccessState.inactive),
  ];

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'QuickAccessCard',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: '75×84 · border neutral-10 · círculo 34 (icon 18 + p8) · '
          'label nowrap (quebra só com \\n) · lock badge 8px no disabled.',
      child: CpfSeguroSpecTable(
        cellWidth: 110,
        cellHeight: 100,
        columnGroups: const [
          SpecAxisGroup(title: 'State', subs: ['active', 'inactive']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['card']),
        ],
        cellBuilder: (r, c) => CpfSeguroQuickAccessCard(
          icon: CpfSeguroIcons.fingerprintLight,
          label: 'Sou eu!',
          state: _states[c].$2,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EmptyState — única variante
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyStateSpec extends StatelessWidget {
  const _EmptyStateSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'EmptyState',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: 'Card de lista vazia · border neutral-09 · radius 24 · '
          'px 40 py 16 · spot 32 neutral-10 + icon 12.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 140,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['default']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['card']),
        ],
        cellBuilder: (r, c) => const SizedBox(
          width: 340,
          child: CpfSeguroEmptyState(
            title: 'Nenhuma ação ainda',
            caption: 'Quando o CPF for usado em um parceiro, o registro aparece aqui.',
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OfflinePill — única variante
// ═══════════════════════════════════════════════════════════════════════════

class _OfflinePillSpec extends StatelessWidget {
  const _OfflinePillSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'OfflinePill',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: 'Bg neutral-01 · radius 8 · px 16 py 4 · wifi 16 + '
          'label-sm neutral-09. Sempre acima do StatusBanner com gap 8.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 56,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['default']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['pill']),
        ],
        cellBuilder: (r, c) => const SizedBox(width: 340, child: CpfSeguroOfflinePill()),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SearchInput — única variante
// ═══════════════════════════════════════════════════════════════════════════

class _SearchInputSpec extends StatefulWidget {
  const _SearchInputSpec();
  @override
  State<_SearchInputSpec> createState() => _SearchInputSpecState();
}

class _SearchInputSpecState extends State<_SearchInputSpec> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'SearchInput',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: 'Busca com ícone à esquerda (lista de Atividade).',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 72,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['default']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['input']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: CpfSeguroSearchInput(controller: _controller),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Tooltip — 2 styles × 2 sides
// ═══════════════════════════════════════════════════════════════════════════

class _TooltipSpec extends StatelessWidget {
  const _TooltipSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Tooltip',
      composedOf: const ['Color', 'Typography', 'Radius'],
      subtitle: '2 styles (dark/light) × 2 sides (top/bottom) · tail opcional.',
      child: CpfSeguroSpecTable(
        cellWidth: 160,
        cellHeight: 72,
        columnGroups: const [
          SpecAxisGroup(title: 'Side', subs: ['top', 'bottom']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Style', subs: ['dark', 'light']),
        ],
        cellBuilder: (r, c) => CpfSeguroTooltip(
          label: 'Tooltip',
          style: r == 0 ? CpfSeguroTooltipStyle.dark : CpfSeguroTooltipStyle.light,
          side: c == 0 ? CpfSeguroTooltipSide.top : CpfSeguroTooltipSide.bottom,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// InputChip — default/filled × trailIcon
// ═══════════════════════════════════════════════════════════════════════════

class _InputChipSpec extends StatelessWidget {
  const _InputChipSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'InputChip',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: 'Pill h24 · border primary-04 · label-sm primary. '
          'filled = bg primary-08 (filtro ativo). trailIcon típico: '
          'chevron-down (dropdown) ou circle-minus (remover filtro).',
      child: CpfSeguroSpecTable(
        cellWidth: 150,
        cellHeight: 56,
        columnGroups: const [
          SpecAxisGroup(title: 'Fill', subs: ['default', 'filled']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Trail', subs: ['chevron-down', 'circle-minus', 'sem']),
        ],
        cellBuilder: (r, c) => CpfSeguroInputChip(
          label: r == 1 ? '15 dias' : 'Meu CPF',
          trailIcon: switch (r) {
            0 => 'chevron-down-light',
            1 => 'circle-minus-light',
            _ => null,
          },
          filled: c == 1,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AmountDisplay — única variante (timestamp opcional)
// ═══════════════════════════════════════════════════════════════════════════

class _AmountDisplaySpec extends StatelessWidget {
  const _AmountDisplaySpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'AmountDisplay',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Valor headline centralizado + timestamp body-sm neutral-04, '
          'entre hairlines neutral-09 · py 16.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 110,
        columnGroups: const [
          SpecAxisGroup(title: 'Timestamp', subs: ['com', 'sem']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['display']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: CpfSeguroAmountDisplay(
            value: 'R\$ 560,00',
            timestamp: c == 0 ? '13/10/2023 as 14:25' : null,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DetailRow — descrição × chevron × hairline
// ═══════════════════════════════════════════════════════════════════════════

class _DetailRowSpec extends StatelessWidget {
  const _DetailRowSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'DetailRow',
      composedOf: const ['IconAccessory', 'Color', 'Typography'],
      subtitle: 'Title title-sm neutral-01 + descrição body-sm neutral-03 · '
          'py 16 · hairline inferior opcional · chevron para rows de navegação.',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 96,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['row']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variante', subs: ['label + descrição', 'action + chevron', 'sem hairline']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 310,
          child: switch (r) {
            0 => const CpfSeguroDetailRow(title: 'Rede', description: 'Mastercard'),
            1 => CpfSeguroDetailRow(title: 'Entre em contato com Swile', chevron: true, onTap: () {}),
            _ => const CpfSeguroDetailRow(title: 'Para', description: 'Pague menos', hairline: false),
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// InfoCard — card horizontal com status opcional
// ═══════════════════════════════════════════════════════════════════════════

class _InfoCardSpec extends StatelessWidget {
  const _InfoCardSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'InfoCard',
      composedOf: const ['IconAccessory', 'StatusTag', 'Color', 'Typography'],
      subtitle: 'Card borda neutral-09 · ícone 20 textSecondary + título subheading '
          'fg (+ StatusTag opcional) + descrição body-sm até 3 linhas · '
          'CONSOME CpfSeguroStatusTag no slot de status.',
      child: CpfSeguroSpecTable(
        cellWidth: 420,
        cellHeight: 116,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['card']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variante', subs: ['status success', 'status primary', 'sem status']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 390,
          child: switch (r) {
            0 => const CpfSeguroInfoCard(
                icon: CpfSeguroIcons.walletLight,
                title: 'Carteira digital',
                description: 'Todos os seus cartões num só lugar, com segurança.',
                status: CpfSeguroStatusTagData(label: 'Disponível', tone: CpfSeguroStatusTone.success)),
            1 => const CpfSeguroInfoCard(
                icon: CpfSeguroIcons.usersLight,
                title: 'Sou eu',
                description: 'Autenticação rápida e sem fricção.',
                status: CpfSeguroStatusTagData(label: 'Em breve', tone: CpfSeguroStatusTone.primary)),
            _ => const CpfSeguroInfoCard(
                icon: CpfSeguroIcons.lockLight,
                title: 'CPF Seguro',
                description: 'Pause e despause seu CPF para evitar golpes.'),
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FaceIdCard — única variante
// ═══════════════════════════════════════════════════════════════════════════

class _FaceIdCardSpec extends StatelessWidget {
  const _FaceIdCardSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'FaceIdCard',
      composedOf: const ['IconAccessory', 'Color', 'Typography', 'Radius'],
      subtitle: '156×156 · bg neutral-10 · radius 16 · glifo face-id 56 + '
          'label title-md. Inline (não é overlay).',
      child: CpfSeguroSpecTable(
        cellWidth: 200,
        cellHeight: 190,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['default']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['card']),
        ],
        cellBuilder: (r, c) => const CpfSeguroFaceIdCard(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppListDayGroup — regra do divider
// ═══════════════════════════════════════════════════════════════════════════

class _DayGroupSpec extends StatelessWidget {
  const _DayGroupSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'AppListDayGroup',
      composedOf: const ['AppList', 'Color', 'Typography'],
      subtitle: 'Grupo flat por dia. Divider 1px neutral-09 (inset 56): entre '
          'itens (todo item que não é o último) E abaixo do item quando ele é '
          'o ÚNICO do dia.',
      child: CpfSeguroSpecTable(
        cellWidth: 400,
        cellHeight: 200,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['grupo']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Itens', subs: ['2 itens · divider entre', '1 item · divider fecha']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 380,
          child: r == 0
              ? CpfSeguroAppListDayGroup(label: 'Hoje', children: [
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
                ])
              : CpfSeguroAppListDayGroup(label: '14/05', children: [
                  CpfSeguroAppListRow.transactionItem(
                    title: 'Pix aproximação',
                    source: 'Pague menos',
                    time: '18:22',
                    amount: 'R\$ 560,00',
                  ),
                ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Receipt — compra no cartão × Pix aproximação
// ═══════════════════════════════════════════════════════════════════════════

class _ReceiptSpec extends StatelessWidget {
  const _ReceiptSpec();

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Receipt',
      composedOf: const ['IconAccessory', 'Logo', 'Color', 'Typography', 'Radius'],
      subtitle: 'Comprovante (Figma 11168:57881): spot status + headline + '
          'timestamp + rows label/valor + seções com header/hairline + card '
          'de rodapé (institucional + ID da transação + logo).',
      child: CpfSeguroSpecTable(
        cellWidth: 400,
        cellHeight: 596,
        columnGroups: const [
          SpecAxisGroup(title: 'Tipo', subs: ['compra no cartão', 'Pix aproximação']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['comprovante']),
        ],
        cellBuilder: (r, c) {
          final pix = c == 1;
          return SizedBox(
            width: 360,
            child: CpfSeguroReceipt(
              title: 'Comprovante\nde compra',
              timestamp: '13 Out 2023 - 17:43:12',
              rows: [
                const CpfSeguroReceiptRow(label: 'Valor', value: 'R\$ 560,00'),
                CpfSeguroReceiptRow(
                  label: 'Tipo de pagamento',
                  value: pix ? 'Pix aproximação' : 'Cartão CPF Seguro',
                ),
              ],
              sections: [
                const CpfSeguroReceiptSection(
                  icon: CpfSeguroIcons.receiptLight,
                  title: 'Estabelecimento',
                  rows: [
                    CpfSeguroReceiptRow(label: 'Nome', value: 'Pague menos'),
                    CpfSeguroReceiptRow(label: 'CNPJ', value: '06.626.253/0001-51'),
                  ],
                ),
                CpfSeguroReceiptSection(
                  icon: CpfSeguroIcons.creditCardLight,
                  title: pix ? 'Pagamento' : 'Cartão',
                  rows: [
                    CpfSeguroReceiptRow(label: 'Origem', value: pix ? 'Pix aproximação' : 'CPF Seguro •••• 7654'),
                    if (!pix) const CpfSeguroReceiptRow(label: 'Bandeira', value: 'Mastercard'),
                  ],
                ),
              ],
              footerLines: const [
                'CPF Seguro - Instituição de pagamento',
                'CNPJ: 12.234.456.123/0001-58',
              ],
              transactionId: 'e00343456542444324453455666e3555434554',
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// COBERTURA COMPLETA — specs adicionados p/ refletir 100% dos componentes
// ═══════════════════════════════════════════════════════════════════════════

/// Moldura p/ overlays full-screen (sheets, biometria): dá um Stack + MediaQuery
/// do tamanho do frame pra o overlay ancorar dentro do card do catálogo.
Widget _overlayFrame(BuildContext context, Widget overlay,
    {double w = 300, double h = 560}) {
  return SizedBox(
    width: w,
    height: h,
    child: ClipRRect(
      borderRadius: CpfSeguroRadius.all24,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          size: Size(w, h),
          padding: EdgeInsets.zero,
          viewInsets: EdgeInsets.zero,
          viewPadding: EdgeInsets.zero,
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: CpfSeguroColors.neutral10),
            ),
            overlay,
          ],
        ),
      ),
    ),
  );
}

// ─── ATOMS ─────────────────────────────────────────────────────────────────

class _SeeAllLinkSpec extends StatelessWidget {
  const _SeeAllLinkSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'SeeAllLink',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Link "Ver todos" · label 12/600 cor primary. Trailing padrão do SectionHeader.',
      child: CpfSeguroSpecTable(
        cellWidth: 160,
        cellHeight: 44,
        columnGroups: const [
          SpecAxisGroup(title: 'Label', subs: ['Ver todos', 'custom']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['link']),
        ],
        cellBuilder: (r, c) => CpfSeguroSeeAllLink(
          label: c == 0 ? 'Ver todos' : 'Ver mais',
          onPressed: () {},
        ),
      ),
    );
  }
}

class _StatusBarSpec extends StatelessWidget {
  const _StatusBarSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'StatusBar',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Barra de status do device · h40 · relógio mono + signal/wifi/battery. Compõe a TopBar.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 56,
        columnGroups: const [
          SpecAxisGroup(title: 'time', subs: ['9:41', '10:30']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['bar']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: CpfSeguroStatusBar(time: c == 0 ? '9:41' : '10:30'),
        ),
      ),
    );
  }
}

class _IllustrationSpec extends StatelessWidget {
  const _IllustrationSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Illustration',
      composedOf: const ['Asset'],
      subtitle: 'Ilustração pura é TOKEN (${CpfSeguroIllustration.all.length} nomes · '
          'pares light/dark resolvem pelo tema). O IllustrationAccessory (átomo) só '
          'dimensiona — degraus fixos sm/md/lg/xl = 100/200/300/400 — e recolore a '
          'família de marca por token. Mesmo padrão de Icon ↔ IconAccessory.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final ill in CpfSeguroIllustration.all)
            SizedBox(
              width: 120,
              child: Column(children: [
                CpfSeguroIllustrationAccessory(
                    illustration: ill, size: CpfSeguroIllustrationSize.sm),
                const SizedBox(height: 6),
                Text(ill.base,
                    textAlign: TextAlign.center,
                    style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
              ]),
            ),
        ],
      ),
    );
  }
}

// ─── MOLECULES ───────────────────────────────────────────────────────────────

class _InputSpec extends StatefulWidget {
  const _InputSpec();
  @override
  State<_InputSpec> createState() => _InputSpecState();
}

class _InputSpecState extends State<_InputSpec> {
  final _c = List.generate(5, (_) => TextEditingController());
  @override
  void dispose() {
    for (final c in _c) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Input',
      composedOf: const ['Color', 'Typography', 'Radius', 'Elevation'],
      subtitle: 'label + field + tooltip · h48 (long ≥72) · radius 16 · focus ring spread 3. '
          'Types: text / password / long / dropdown · states normal/error/disabled.',
      child: CpfSeguroSpecTable(
        cellWidth: 300,
        cellHeight: 132,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['field']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variante', subs: ['text', 'password', 'long', 'error', 'disabled']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 280,
          child: switch (r) {
            0 => CpfSeguroInput(controller: _c[0], label: 'Nome completo', helper: 'Como no documento'),
            1 => CpfSeguroInput(controller: _c[1], label: 'Senha', type: CpfSeguroInputType.password),
            2 => CpfSeguroInput(controller: _c[2], label: 'Comentário', type: CpfSeguroInputType.long),
            3 => CpfSeguroInput(controller: _c[3], label: 'CPF', error: 'CPF inválido'),
            _ => CpfSeguroInput(controller: _c[4], label: 'Bloqueado', disabled: true),
          },
        ),
      ),
    );
  }
}

class _RadioListSpec extends StatelessWidget {
  const _RadioListSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'RadioList',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Single-select · dot 20 (1.5px) · título opcional subheading. Row selecionada = fg + primary.',
      child: CpfSeguroSpecTable(
        cellWidth: 320,
        cellHeight: 150,
        columnGroups: const [
          SpecAxisGroup(title: 'Título', subs: ['com', 'sem']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['list']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 300,
          child: CpfSeguroRadioList(
            title: c == 0 ? 'Selecione o motivo' : null,
            value: 'oferta',
            onChanged: (_) {},
            options: const [
              CpfSeguroRadioOption(value: 'oferta', label: 'Recebi oferta de outro banco'),
              CpfSeguroRadioOption(value: 'tarifas', label: 'Insatisfação com tarifas'),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageTitleSpec extends StatelessWidget {
  const _PageTitleSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'PageTitle',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'h1 22/32 (title) + subtitle opcional (bodyMd) · gap 4 · pb 24.',
      child: CpfSeguroSpecTable(
        cellWidth: 360,
        cellHeight: 120,
        columnGroups: const [
          SpecAxisGroup(title: 'Subtitle', subs: ['com', 'sem']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['title']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: CpfSeguroPageTitle(
            title: 'Nome',
            subtitle: c == 0 ? 'Atualize seu nome completo. Vamos usá-lo na sua identificação.' : null,
          ),
        ),
      ),
    );
  }
}

class _StepperSpec extends StatelessWidget {
  const _StepperSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Stepper',
      composedOf: const ['Color', 'Typography', 'Radius'],
      subtitle: 'Trilho h3 · segmentos radius 2 gap 4 (passado primary / futuro primary-07) · label "Passo X de Y".',
      child: CpfSeguroSpecTable(
        cellWidth: 360,
        cellHeight: 64,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['stepper']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Progresso', subs: ['1 de 4', '2 de 4', '4 de 4']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: CpfSeguroStepper(
            current: const [1, 2, 4][r],
            total: 4,
            labelText: 'Cadastro',
          ),
        ),
      ),
    );
  }
}

class _NavSpec extends StatelessWidget {
  const _NavSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Nav',
      composedOf: const ['IconAccessory', 'GlassSurface', 'Color', 'Elevation', 'Typography'],
      subtitle: 'Barra glass (radius topo 40 · blur 10 · elevation medium) · item ativo pop-out '
          '(círculo primary · icon 32) · dot vermelho na tab cpfSeguro quando pauseActive.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 160,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['nav']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'activeTab', subs: ['home', 'souEu', 'carteira', 'cpfSeguro', 'cpfSeguro · pausa']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: CpfSeguroNav(
            activeTab: const [
              CpfSeguroNavTab.home,
              CpfSeguroNavTab.souEu,
              CpfSeguroNavTab.carteira,
              CpfSeguroNavTab.cpfSeguro,
              CpfSeguroNavTab.cpfSeguro,
            ][r],
            pauseActive: r == 4,
            onTabChanged: (_) {},
          ),
        ),
      ),
    );
  }
}

class _NavigationButtonSpec extends StatelessWidget {
  const _NavigationButtonSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'NavigationButton',
      composedOf: const ['Button'],
      subtitle: 'Pilha de CTAs lg fullWidth (gap 12). Slots primary / secondary / tertiary · state error por slot.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 210,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['stack']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'CTAs', subs: ['1', '2', '3 · error']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: switch (r) {
            0 => CpfSeguroNavigationButton(
                primary: CpfSeguroNavigationAction(label: 'Continuar', onPressed: () {}),
              ),
            1 => CpfSeguroNavigationButton(
                primary: CpfSeguroNavigationAction(label: 'Salvar', onPressed: () {}),
                secondary: CpfSeguroNavigationAction(label: 'Cancelar', onPressed: () {}),
              ),
            _ => CpfSeguroNavigationButton(
                primary: CpfSeguroNavigationAction(
                    label: 'Excluir', state: CpfSeguroButtonState.error, onPressed: () {}),
                secondary: CpfSeguroNavigationAction(label: 'Voltar', onPressed: () {}),
                tertiary: CpfSeguroNavigationAction(label: 'Ajuda', onPressed: () {}),
              ),
          },
        ),
      ),
    );
  }
}

class _NavigationTopBarSpec extends StatelessWidget {
  const _NavigationTopBarSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'NavigationTopBar',
      composedOf: const ['IconButton', 'Button', 'InputChip', 'Color', 'Typography'],
      subtitle: 'h52 · px 24 · título heading centralizado. Left: back/close/home · '
          'Right: icons (1-3, badge) / buttonTertiarySmall / inputChip.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 68,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['bar']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variante', subs: ['back + título', 'home + icons', 'close + button', 'inputChip']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: switch (r) {
            0 => CpfSeguroNavigationTopBar(
                left: CpfSeguroNavigationLeftAccessory.back(onPressed: () {}),
                title: 'Detalhes',
              ),
            1 => CpfSeguroNavigationTopBar(
                left: CpfSeguroNavigationLeftAccessory.home(firstName: 'Ana', onOpenProfile: () {}),
                centerAlign: TextAlign.start,
                right: CpfSeguroNavigationRightAccessory.icons(
                  icons: [
                    CpfSeguroNavRightIcon(
                        icon: CpfSeguroIcons.bellLight,
                        semanticLabel: 'Notificações',
                        badge: true,
                        onPressed: () {}),
                  ],
                ),
              ),
            2 => CpfSeguroNavigationTopBar(
                left: CpfSeguroNavigationLeftAccessory.close(onPressed: () {}),
                title: 'Cadastro',
                right: CpfSeguroNavigationRightAccessory.buttonTertiarySmall(label: 'Pular', onPressed: () {}),
              ),
            _ => CpfSeguroNavigationTopBar(
                title: 'Home',
                right: CpfSeguroNavigationRightAccessory.inputChip(label: 'Meu CPF', onPressed: () {}),
              ),
          },
        ),
      ),
    );
  }
}

class _ChatInputSpec extends StatefulWidget {
  const _ChatInputSpec();
  @override
  State<_ChatInputSpec> createState() => _ChatInputSpecState();
}

class _ChatInputSpecState extends State<_ChatInputSpec> {
  final _c = List.generate(5, (_) => TextEditingController());
  @override
  void dispose() {
    for (final c in _c) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'ChatInput',
      composedOf: const ['IconAccessory', 'StatusTag', 'Checkbox', 'Color', 'Elevation', 'Radius'],
      subtitle: 'h56 · radius 24 · elevation medium · botões eye/send 36 (icon 20). '
          'Types text/numeric/tel · sendReady · erro (StatusTag danger) · checkbox chip.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 120,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['input']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'Variante', subs: ['text', 'numeric · ready', 'password', 'erro', 'checkbox']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 340,
          child: switch (r) {
            0 => CpfSeguroChatInput(controller: _c[0], placeholder: 'Digite...'),
            1 => CpfSeguroChatInput(
                controller: _c[1],
                type: CpfSeguroChatInputType.numeric,
                sendReady: true,
                onSend: () {},
              ),
            2 => CpfSeguroChatInput(
                controller: _c[2],
                password: true,
                onToggleVisible: () {},
                onSend: () {},
              ),
            3 => CpfSeguroChatInput(controller: _c[3], errorText: 'CPF inválido'),
            _ => CpfSeguroChatInput(
                controller: _c[4],
                checkbox: CpfSeguroChatInputCheckbox(
                  label: 'Não tenho apelido',
                  checked: false,
                  onChanged: (_) {},
                  onTooltipTap: () {},
                ),
              ),
          },
        ),
      ),
    );
  }
}

class _ChatTypingIndicatorSpec extends StatelessWidget {
  const _ChatTypingIndicatorSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'ChatTypingIndicator',
      composedOf: const ['ChatTokens', 'Color'],
      subtitle: 'Bubble surfaceMuted (radius 25, anchor 0 bottom-left) · 3 dots 6px pulsando (1200ms).',
      child: CpfSeguroSpecTable(
        cellWidth: 200,
        cellHeight: 72,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['typing']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['bubble']),
        ],
        cellBuilder: (r, c) => const Align(
          alignment: Alignment.centerLeft,
          child: CpfSeguroChatTypingIndicator(),
        ),
      ),
    );
  }
}

class _KeyboardSpec extends StatelessWidget {
  const _KeyboardSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'Keyboard',
      composedOf: const ['Color', 'Typography', 'Elevation', 'Radius'],
      subtitle: 'Numpad iOS (bg neutral-08) · key h47 radius 8 elevation keyPress · backspace transparente. '
          '+ KeyboardIndicator (barra 134×5).',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 340,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['numpad']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['keyboard']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
              const CpfSeguroKeyboardIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── ORGANISMS ───────────────────────────────────────────────────────────────

class _TopAppBarSpec extends StatelessWidget {
  const _TopAppBarSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'TopAppBar',
      composedOf: const ['StatusBar', 'NavigationTopBar', 'Stepper', 'GlassSurface'],
      subtitle: 'default/stepper: glass + StatusBar + NavigationTopBar (+ Stepper). '
          'bottomsheet: grip 75×5 + NavigationTopBar (radius topo 24, sem StatusBar).',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 160,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['bar']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'variant', subs: ['default', 'stepper', 'bottomsheet']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: switch (r) {
            0 => CpfSeguroTopAppBar.defaultVariant(
                navBar: CpfSeguroNavigationTopBar(
                  left: CpfSeguroNavigationLeftAccessory.back(onPressed: () {}),
                  title: 'Detalhes',
                ),
              ),
            1 => CpfSeguroTopAppBar.stepper(
                navBar: CpfSeguroNavigationTopBar(
                  left: CpfSeguroNavigationLeftAccessory.close(onPressed: () {}),
                  title: 'Cadastro',
                ),
                stepper: const CpfSeguroStepper(current: 2, total: 4, labelText: 'Cadastro'),
              ),
            _ => CpfSeguroTopAppBar.bottomsheet(
                navBar: CpfSeguroNavigationTopBar(
                  left: CpfSeguroNavigationLeftAccessory.close(onPressed: () {}),
                  title: 'Filtros',
                ),
              ),
          },
        ),
      ),
    );
  }
}

class _BottomAppSpec extends StatefulWidget {
  const _BottomAppSpec();
  @override
  State<_BottomAppSpec> createState() => _BottomAppSpecState();
}

class _BottomAppSpecState extends State<_BottomAppSpec> {
  final _chat = TextEditingController();
  @override
  void dispose() {
    _chat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'BottomApp',
      composedOf: const ['Nav', 'NavigationButton', 'Keyboard', 'ChatInput', 'GlassSurface'],
      subtitle: 'Slot inferior do app (glass + home indicator). Variantes: default(34) · nav(126) · '
          'button(122/190/258) · keyboard(315) · chatInput(122) · buttonAndKeyboard · chatInputAndKeyboard(369). '
          'Preview mostra default/nav/button/keyboard/chatInput.',
      child: CpfSeguroSpecTable(
        cellWidth: 380,
        cellHeight: 340,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['slot']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: 'variant', subs: ['default', 'nav', 'button', 'keyboard', 'chatInput']),
        ],
        cellBuilder: (r, c) => SizedBox(
          width: 360,
          child: switch (r) {
            0 => const CpfSeguroBottomApp.defaultVariant(),
            1 => CpfSeguroBottomApp.nav(
                nav: CpfSeguroNav(activeTab: CpfSeguroNavTab.home, onTabChanged: (_) {}),
              ),
            2 => CpfSeguroBottomApp.button(
                button: CpfSeguroNavigationButton(
                  primary: CpfSeguroNavigationAction(label: 'Continuar', onPressed: () {}),
                ),
              ),
            3 => CpfSeguroBottomApp.keyboard(
                keyboard: CpfSeguroKeyboard(onKey: (_) {}, onBackspace: () {}),
              ),
            _ => CpfSeguroBottomApp.chatInput(
                input: CpfSeguroChatInput(controller: _chat, placeholder: 'Digite...'),
              ),
          },
        ),
      ),
    );
  }
}

class _PasswordBottomSheetSpec extends StatelessWidget {
  const _PasswordBottomSheetSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'PasswordBottomSheet',
      composedOf: const ['TopAppBar', 'Keyboard', 'Button', 'GlassSurface'],
      subtitle: 'Sheet de senha (radius topo 24) · PinDots 24 (length 4/6) · Continuar (glass) + Keyboard. '
          'Preview emoldurado (overlay full-screen).',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 580,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['open']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['sheet']),
        ],
        cellBuilder: (r, c) => _overlayFrame(
          context,
          CpfSeguroPasswordBottomSheet(
            open: true,
            onClose: () {},
            onSubmit: (_) {},
            onForgot: () {},
          ),
        ),
      ),
    );
  }
}

class _ExitConfirmSheetSpec extends StatelessWidget {
  const _ExitConfirmSheetSpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'ExitConfirmSheet',
      composedOf: const ['TopAppBar', 'Button'],
      subtitle: 'Sheet de confirmação de saída · title + subtitle + Sair (primary error) / Cancelar (secondary). '
          'Preview emoldurado (overlay full-screen).',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 480,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['open']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['sheet']),
        ],
        cellBuilder: (r, c) => _overlayFrame(
          context,
          CpfSeguroExitConfirmSheet(
            open: true,
            onClose: () {},
            onConfirm: () {},
          ),
          h: 460,
        ),
      ),
    );
  }
}

class _BiometriaOverlaySpec extends StatelessWidget {
  const _BiometriaOverlaySpec();
  @override
  Widget build(BuildContext context) {
    return SpecSection(
      title: 'BiometriaOverlay',
      composedOf: const ['Color', 'Typography'],
      subtitle: 'Overlay full-screen (scrim black@85) · bubble 96 (border white@90 · icon fingerprint 56) '
          'pulsando · mensagem heading. Preview em scanning (autoSuccess off).',
      child: CpfSeguroSpecTable(
        cellWidth: 340,
        cellHeight: 480,
        columnGroups: const [
          SpecAxisGroup(title: '·', subs: ['scanning']),
        ],
        rowGroups: const [
          SpecAxisGroup(title: '·', subs: ['overlay']),
        ],
        cellBuilder: (r, c) => _overlayFrame(
          context,
          CpfSeguroBiometriaOverlay(
            open: true,
            autoSuccess: false,
            onSuccess: () {},
            onCancel: () {},
          ),
          h: 460,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Roles — a camada semântica (o dicionário de significado)
// ═══════════════════════════════════════════════════════════════════════════

class _RolesSpec extends StatelessWidget {
  const _RolesSpec();
  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return SpecSection(
      title: 'Roles',
      subtitle: 'Camada semântica — o dicionário de significado. Cada role = cor + on-color + subtle '
          '+ ícone default. Componente consome role, nunca cor crua. Contraste WCAG do par cor/on-color '
          'validado no CI (AA ≥ 4.5 texto · ≥ 3.0 UI/large).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final role in CpfSeguroRoles.all) _RoleRow(s, role),
        ],
      ),
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow(this.scheme, this.role);
  final CpfSeguroScheme scheme;
  final CpfSeguroRole role;

  @override
  Widget build(BuildContext context) {
    final st = CpfSeguroRoles.of(scheme, role);
    final ratio = cpfSeguroContrastRatio(st.color, st.onColor);
    final aa = ratio >= cpfSeguroContrastAANormal;
    final aaLarge = ratio >= cpfSeguroContrastAALarge;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        SizedBox(
          width: 84,
          child: Text(CpfSeguroRoles.label(role),
              style: CpfSeguroType.subheading.copyWith(color: CpfSeguroColors.neutral01)),
        ),
        // Fill: color + on-color (prova o contraste do par)
        Container(
          width: 150,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: st.color, borderRadius: CpfSeguroRadius.all8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (st.icon != null) ...[
              CpfSeguroIcon(name: st.icon!, size: 16, color: st.onColor),
              const SizedBox(width: 6),
            ],
            Text('Aa', style: CpfSeguroType.subheading.copyWith(color: st.onColor)),
          ]),
        ),
        const SizedBox(width: 12),
        // Subtle
        Container(
          width: 56,
          height: 48,
          decoration: BoxDecoration(
            color: st.subtle,
            borderRadius: CpfSeguroRadius.all8,
            border: Border.all(color: CpfSeguroColors.neutral09),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 70,
          child: Text('${ratio.toStringAsFixed(2)}:1',
              style: CpfSeguroType.bodyMd.copyWith(color: CpfSeguroColors.neutral02)),
        ),
        _AaBadge('AA', aa),
        const SizedBox(width: 6),
        _AaBadge('AA large', aaLarge),
      ]),
    );
  }
}

class _AaBadge extends StatelessWidget {
  const _AaBadge(this.label, this.pass);
  final String label;
  final bool pass;
  @override
  Widget build(BuildContext context) {
    final bg = pass ? CpfSeguroColors.success07 : CpfSeguroColors.error07;
    final fg = pass ? CpfSeguroColors.success04 : CpfSeguroColors.error04;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
      child: Text('${pass ? "✓" : "✕"} $label',
          style: CpfSeguroType.labelSm.copyWith(color: fg)),
    );
  }
}
