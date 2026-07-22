import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:cpf_seguro_design_system/design_system/widgets/cpf_seguro_icon.dart';
import 'package:cpf_seguro_design_system/design_system/theme/cpf_seguro_icon_tokens.dart';

void main() {
  testWidgets('CpfSeguroIcon renderiza via .vec precompilado sem excecao',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CpfSeguroIcon(
          name: CpfSeguroIcons.bellLight,
          size: 24,
          color: Color(0xFF003BE0),
        ),
      ),
    );
    // Deixa o AssetBytesLoader resolver o binario.
    await tester.pumpAndSettle();

    expect(find.byType(VectorGraphic), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('multicolor (pix-mark) tambem carrega via .vec', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CpfSeguroIcon(name: CpfSeguroIcons.pixMark, size: 32),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VectorGraphic), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('arrow-right (derivado do arrow-left por rotacao 180) carrega',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [
          CpfSeguroIcon(name: CpfSeguroIcons.arrowRightLight, size: 24),
          CpfSeguroIcon(name: CpfSeguroIcons.arrowRightSolid, size: 24),
        ]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VectorGraphic), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
