import 'package:flutter_test/flutter_test.dart';
import 'package:cpf_seguro_design_system/design_system/cpf_seguro_design_system.dart';

/// Gate de acessibilidade (V4): todo par role.color / role.onColor SHALL passar
/// no mínimo WCAG AA para UI/large (≥ 3.0:1), em light e dark.
/// Se falhar, é um problema real de token — não afrouxe o alvo, corrija a cor.
void main() {
  final schemes = <String, CpfSeguroScheme>{
    'light': CpfSeguroScheme.light(CpfSeguroPalette.cpf),
    'dark': CpfSeguroScheme.dark(CpfSeguroPalette.cpf),
  };

  for (final entry in schemes.entries) {
    for (final role in CpfSeguroRoles.all) {
      test('contraste ${role.name} (${entry.key}) >= AA large (3.0)', () {
        final st = CpfSeguroRoles.of(entry.value, role);
        final ratio = cpfSeguroContrastRatio(st.color, st.onColor);
        expect(
          ratio,
          greaterThanOrEqualTo(cpfSeguroContrastAALarge),
          reason: '${role.name}/${entry.key}: par color/onColor em ${ratio.toStringAsFixed(2)}:1',
        );
      });
    }
  }
}
