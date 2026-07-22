import 'package:flutter_test/flutter_test.dart';
import 'package:cpf_seguro_design_system/design_system/cpf_seguro_design_system.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_color_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_dimension_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_role_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_elevation_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_gradient_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_type_tokens.g.dart';
import 'package:cpf_seguro_design_system/design_system/theme/generated/cps_duration_tokens.g.dart';
import 'package:flutter/widgets.dart';

/// Paridade V2: a fonte DTCG (tokens/*.json) -> gerado (cps_color_tokens.g.dart)
/// SHALL bater 1:1 com a CpfSeguroPalette.cpf viva. Pega drift entre o DTCG e o
/// token vivo (e qualquer typo de hex no JSON). Ponte até o DS consumir o gerado.
void main() {
  final p = CpfSeguroPalette.cpf;

  final expected = <String, int>{
    'primary01': p.primary01.value,
    'primary02': p.primary02.value,
    'primary03': p.primary03.value,
    'primary04': p.primary04.value,
    'primary05': p.primary05.value,
    'primary06': p.primary06.value,
    'primary07': p.primary07.value,
    'primary08': p.primary08.value,
    'primary09': p.primary09.value,
    'primaryStateSelected': p.primaryStateSelected.value,
    'primaryStateHover': p.primaryStateHover.value,
    'onPrimary': p.onPrimary.value,
    'neutral01': p.neutral01.value,
    'neutral02': p.neutral02.value,
    'neutral03': p.neutral03.value,
    'neutral04': p.neutral04.value,
    'neutral05': p.neutral05.value,
    'neutral06': p.neutral06.value,
    'neutral07': p.neutral07.value,
    'neutral08': p.neutral08.value,
    'neutral09': p.neutral09.value,
    'neutral10': p.neutral10.value,
    'white': p.white.value,
    'black': p.black.value,
    'error01': p.error01.value,
    'error02': p.error02.value,
    'error03': p.error03.value,
    'error04': p.error04.value,
    'error05': p.error05.value,
    'error06': p.error06.value,
    'error07': p.error07.value,
    'warning01': p.warning01.value,
    'warning02': p.warning02.value,
    'warning03': p.warning03.value,
    'warning04': p.warning04.value,
    'warning05': p.warning05.value,
    'warning06': p.warning06.value,
    'warning07': p.warning07.value,
    'success01': p.success01.value,
    'success02': p.success02.value,
    'success03': p.success03.value,
    'success04': p.success04.value,
    'success05': p.success05.value,
    'success06': p.success06.value,
    'success07': p.success07.value,
    'secure02': p.secure02.value,
    'secure03': p.secure03.value,
    'secure04': p.secure04.value,
    'secure05': p.secure05.value,
    'secure07': p.secure07.value,
    'secure08': p.secure08.value,
  };

  test('gerado (DTCG) == CpfSeguroPalette.cpf (paridade 1:1)', () {
    expect(cpfSeguroColorTokensGen, equals(expected));
  });

  test('nenhum token da palette ficou de fora do DTCG', () {
    expect(cpfSeguroColorTokensGen.length, expected.length);
  });

  test('breakpoints gerados (DTCG) == CpfSeguroBreakpoints', () {
    expect(
      cpfSeguroBreakpointTokensGen,
      equals(<String, double>{
        'sm': CpfSeguroBreakpoints.sm,
        'md': CpfSeguroBreakpoints.md,
        'lg': CpfSeguroBreakpoints.lg,
        'xl': CpfSeguroBreakpoints.xl,
      }),
    );
  });

  test('radius gerado (DTCG) == CpfSeguroRadius', () {
    expect(
      cpfSeguroRadiusTokensGen,
      equals(<String, double>{
        'r0': CpfSeguroRadius.r0.x,
        'r2': CpfSeguroRadius.r2.x,
        'r4': CpfSeguroRadius.r4.x,
        'r8': CpfSeguroRadius.r8.x,
        'r16': CpfSeguroRadius.r16.x,
        'r24': CpfSeguroRadius.r24.x,
        'r32': CpfSeguroRadius.r32.x,
        'r40': CpfSeguroRadius.r40.x,
        'r56': CpfSeguroRadius.r56.x,
        'r200': CpfSeguroRadius.r200.x,
      }),
    );
  });

  test('roles LIGHT gerados (DTCG) == CpfSeguroScheme.light (o coração da linguagem)', () {
    final s = CpfSeguroScheme.light(p);
    final expectedRoles = <String, int>{
      'bg': s.bg.value,
      'bgMenu': s.bgMenu.value,
      'fg': s.fg.value,
      'surface': s.surface.value,
      'onSurface': s.onSurface.value,
      'surfaceMuted': s.surfaceMuted.value,
      'textSecondary': s.textSecondary.value,
      'textTertiary': s.textTertiary.value,
      'textMuted': s.textMuted.value,
      'textPlaceholder': s.textPlaceholder.value,
      'border': s.border.value,
      'divider': s.divider.value,
      'glassTint': s.glassTint.value,
      'primary': s.primary.value,
      'onPrimary': s.onPrimary.value,
      'primaryHover': s.primaryHover.value,
      'primaryPressed': s.primaryPressed.value,
      'primarySubtle': s.primarySubtle.value,
      'onPrimarySubtle': s.onPrimarySubtle.value,
      'success': s.success.value,
      'onSuccess': s.onSuccess.value,
      'successSubtle': s.successSubtle.value,
      'warning': s.warning.value,
      'onWarning': s.onWarning.value,
      'warningSubtle': s.warningSubtle.value,
      'error': s.error.value,
      'onError': s.onError.value,
      'errorSubtle': s.errorSubtle.value,
      'secure': s.secure.value,
      'onSecure': s.onSecure.value,
      'secureSubtle': s.secureSubtle.value,
      'partner': s.partner.value,
      'onPartner': s.onPartner.value,
    };
    expect(cpfSeguroRoleLightTokensGen, equals(expectedRoles));
  });

  test('roles DARK gerados (DTCG) == CpfSeguroScheme.dark', () {
    final s = CpfSeguroScheme.dark(p);
    final expectedRoles = <String, int>{
      'bg': s.bg.value,
      'bgMenu': s.bgMenu.value,
      'fg': s.fg.value,
      'surface': s.surface.value,
      'onSurface': s.onSurface.value,
      'surfaceMuted': s.surfaceMuted.value,
      'textSecondary': s.textSecondary.value,
      'textTertiary': s.textTertiary.value,
      'textMuted': s.textMuted.value,
      'textPlaceholder': s.textPlaceholder.value,
      'border': s.border.value,
      'divider': s.divider.value,
      'glassTint': s.glassTint.value,
      'primary': s.primary.value,
      'onPrimary': s.onPrimary.value,
      'primaryHover': s.primaryHover.value,
      'primaryPressed': s.primaryPressed.value,
      'primarySubtle': s.primarySubtle.value,
      'onPrimarySubtle': s.onPrimarySubtle.value,
      'success': s.success.value,
      'onSuccess': s.onSuccess.value,
      'successSubtle': s.successSubtle.value,
      'warning': s.warning.value,
      'onWarning': s.onWarning.value,
      'warningSubtle': s.warningSubtle.value,
      'error': s.error.value,
      'onError': s.onError.value,
      'errorSubtle': s.errorSubtle.value,
      'secure': s.secure.value,
      'onSecure': s.onSecure.value,
      'secureSubtle': s.secureSubtle.value,
      'partner': s.partner.value,
      'onPartner': s.onPartner.value,
    };
    expect(cpfSeguroRoleDarkTokensGen, equals(expectedRoles));
  });

  test('elevation gerada (DTCG shadow) == valores canônicos', () {
    void check(List<BoxShadow> s, int c, double dx, double dy, double b) {
      expect(s.length, 1);
      expect(s.first.color.value, c);
      expect(s.first.offset.dx, dx);
      expect(s.first.offset.dy, dy);
      expect(s.first.blurRadius, b);
    }

    check(CpfSeguroElevationConsts.low, 0x21000000, 0, 2, 8);
    check(CpfSeguroElevationConsts.medium, 0x21000000, 5, 4, 20);
    check(CpfSeguroElevationConsts.soft, 0x14000000, 0, 4, 10);
    check(CpfSeguroElevationConsts.overlay, 0x33000000, 0, 4, 12);
    check(CpfSeguroElevationConsts.overlayLg, 0x33000000, 0, 4, 16);
    check(CpfSeguroElevationConsts.keyPress, 0x2D000000, 0, 1, 0);
    check(CpfSeguroElevationConsts.brandLow, 0x2E003BE0, 0, 2, 8);
    check(CpfSeguroElevationConsts.brandMedium, 0x662157EF, 2, 8, 20);
    check(CpfSeguroElevationConsts.brandHigh, 0x522157EF, 0, 12, 40);
    check(CpfSeguroElevationConsts.brandSoft, 0x2E003BE0, 0, 4, 10);
    check(CpfSeguroElevationConsts.subtle, 0x05000000, 0, 2, 5);
    check(CpfSeguroElevationConsts.input, 0x1A000000, 5, 4, 20);
    check(CpfSeguroElevationConsts.footerUp, 0x0D3D3939, 0, -4, 10);
    check(CpfSeguroElevationConsts.heavy, 0x80000000, 0, 4, 10);
    check(CpfSeguroElevationConsts.navGlow, 0x59003BE0, 0, 2, 10);
  });

  test('gradients gerados (DTCG) == valores canônicos', () {
    void check(LinearGradient g, Alignment begin, Alignment end,
        List<double>? stops, List<int> colors) {
      expect(g.begin, begin);
      expect(g.end, end);
      expect(g.stops, stops);
      expect(g.colors.map((c) => c.value).toList(), colors);
    }

    check(CpfSeguroGradientConsts.brandLift, const Alignment(-0.5, -1),
        const Alignment(1, 0.5), const [0.0425, 0.8665], const [0xFF002CA8, 0xFF2861FF]);
    check(CpfSeguroGradientConsts.screenBg, const Alignment(0, -1),
        const Alignment(0, 1), null, const [0xFFFFFFFF, 0xFFF2F5FF]);
    check(CpfSeguroGradientConsts.cardPv, const Alignment(-0.62, -0.78),
        const Alignment(0.62, 0.78), null, const [0xFFFFFFFF, 0xFFF8FAFF]);
  });

  test('typography gerada (DTCG) == valores canônicos', () {
    void t2(TextStyle s, double size, FontWeight w, num lh, double ls) {
      expect(s.fontSize, size);
      expect(s.fontWeight, w);
      expect(s.height, lh / size);
      expect(s.letterSpacing, ls);
    }

    const w4 = FontWeight.w400, w5 = FontWeight.w500, w6 = FontWeight.w600, w7 = FontWeight.w700;

    t2(CpfSeguroTypeConsts.displayLg, 57, w6, 64, -0.25);
    t2(CpfSeguroTypeConsts.displayMd, 45, w6, 52, 0);
    t2(CpfSeguroTypeConsts.displaySm, 36, w6, 44, 0);
    t2(CpfSeguroTypeConsts.headlineLg, 32, w6, 40, 0);
    t2(CpfSeguroTypeConsts.headlineMd, 28, w6, 36, 0);
    t2(CpfSeguroTypeConsts.headlineSm, 24, w6, 32, 0);
    t2(CpfSeguroTypeConsts.titleLg, 22, w5, 28, 0);
    t2(CpfSeguroTypeConsts.titleMd, 16, w5, 24, 0.15);
    t2(CpfSeguroTypeConsts.titleSm, 14, w5, 20, 0.1);
    t2(CpfSeguroTypeConsts.bodyLg, 16, w4, 24, 0.5);
    t2(CpfSeguroTypeConsts.bodyMd, 14, w4, 20, 0.25);
    t2(CpfSeguroTypeConsts.bodySm, 12, w4, 16, 0.4);
    t2(CpfSeguroTypeConsts.labelLg, 14, w6, 20, 1.4);
    t2(CpfSeguroTypeConsts.labelMd, 12, w5, 16, 0.5);
    t2(CpfSeguroTypeConsts.labelSm, 11, w5, 16, 0.5);
    t2(CpfSeguroTypeConsts.display, 36, w7, 44, -0.5);
    t2(CpfSeguroTypeConsts.title, 22, w6, 28, -0.2);
    t2(CpfSeguroTypeConsts.heading, 16, w6, 22, 0);
    t2(CpfSeguroTypeConsts.subheading, 14, w6, 20, 0);
    t2(CpfSeguroTypeConsts.caption, 12, w4, 16, 0.2);
    t2(CpfSeguroTypeConsts.label, 12, w6, 16, 0.5);
    t2(CpfSeguroTypeConsts.overline, 11, w7, 16, 1.0);
    t2(CpfSeguroTypeConsts.button, 15, w6, 20, -0.1);
  });

  test('durations geradas (DTCG) == CpfSeguroMotion (ms)', () {
    expect(CpfSeguroDurationConsts.micro.inMilliseconds, 120);
    expect(CpfSeguroDurationConsts.short.inMilliseconds, 150);
    expect(CpfSeguroDurationConsts.medium.inMilliseconds, 250);
    expect(CpfSeguroDurationConsts.slow.inMilliseconds, 400);
    expect(CpfSeguroDurationConsts.deliberate.inMilliseconds, 600);
    expect(CpfSeguroDurationConsts.spinner.inMilliseconds, 700);
    expect(CpfSeguroDurationConsts.shimmer.inMilliseconds, 1500);
  });

  test('spacing gerado (DTCG) == CpfSeguroSpacing', () {
    expect(
      cpfSeguroSpaceTokensGen,
      equals(<String, double>{
        's0_5': CpfSeguroSpacing.s0_5,
        's1': CpfSeguroSpacing.s1,
        's1_5': CpfSeguroSpacing.s1_5,
        's2': CpfSeguroSpacing.s2,
        's3': CpfSeguroSpacing.s3,
        's4': CpfSeguroSpacing.s4,
        's5': CpfSeguroSpacing.s5,
        's6': CpfSeguroSpacing.s6,
        's8': CpfSeguroSpacing.s8,
        's10': CpfSeguroSpacing.s10,
        's12': CpfSeguroSpacing.s12,
        's16': CpfSeguroSpacing.s16,
        's20': CpfSeguroSpacing.s20,
        's24': CpfSeguroSpacing.s24,
        's32': CpfSeguroSpacing.s32,
        's40': CpfSeguroSpacing.s40,
        's48': CpfSeguroSpacing.s48,
        's56': CpfSeguroSpacing.s56,
        's64': CpfSeguroSpacing.s64,
      }),
    );
  });
}
