import 'package:flutter/widgets.dart';
import '../design_system/cpf_seguro_design_system.dart';

/// Kit público do fluxograma da aba Fluxos (versão plugável dos primitivos
/// que nasceram privados no flow_screen). Cada fluxo do app real vive num
/// arquivo em `lib/flows/` e usa estes blocos.
///
/// Vocabulário (estilo mermaid):
/// - [FlowStartDot]/[FlowEndDot] — início/fim
/// - [FlowProcessBox] — tela/etapa (com chip opcional de erro/estado)
/// - [FlowDecision] — losango de decisão
/// - [FlowVArrow]/[FlowHArrow] — setas com label/chip
/// - [FlowLaneHeader] — separador de raia (CAMINHO FELIZ, DESVIOS...)
/// - [FlowEndPill] — terminal textual ("→ Home")
/// - [flowSpine] — centraliza um elemento na espinha vertical de 240
/// Um fluxo da aba: (título, subtítulo, diagrama, telas?). Telas é opcional —
/// fluxos minerados do app real começam só com o diagrama.
typedef FlowEntry = (String, String, Widget Function(), Widget Function()?);

enum FlowChipTone { action, optional, error, state, empty }

(Color, Color) _chipColors(FlowChipTone tone) => switch (tone) {
      FlowChipTone.action => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
      FlowChipTone.optional => (CpfSeguroColors.primary08, CpfSeguroColors.primary04),
      FlowChipTone.error => (CpfSeguroColors.error07, CpfSeguroColors.error03),
      FlowChipTone.state => (CpfSeguroColors.neutral09, CpfSeguroColors.neutral03),
      FlowChipTone.empty => (CpfSeguroColors.warning07, CpfSeguroColors.warning03),
    };

/// Centraliza um elemento na coluna da espinha (largura fixa 240).
Widget flowSpine(Widget child) => SizedBox(width: 240, child: Center(child: child));

class FlowLegendChip extends StatelessWidget {
  const FlowLegendChip({super.key, required this.label, required this.tone});
  final String label;
  final FlowChipTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _chipColors(tone);
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: CpfSeguroRadius.pillAll),
      child: Text(label, style: CpfSeguroType.labelSm.copyWith(color: fg)),
    );
  }
}

class FlowLaneHeader extends StatelessWidget {
  const FlowLaneHeader(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: CpfSeguroType.overline.copyWith(color: CpfSeguroColors.neutral04));
  }
}

/// Bolinha de início (círculo cheio primary).
class FlowStartDot extends StatelessWidget {
  const FlowStartDot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(color: CpfSeguroColors.primary04, shape: BoxShape.circle),
    );
  }
}

/// Bolinha de fim (círculo duplo).
class FlowEndDot extends StatelessWidget {
  const FlowEndDot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CpfSeguroColors.primary04, width: 2),
      ),
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(color: CpfSeguroColors.primary04, shape: BoxShape.circle),
      ),
    );
  }
}

/// Caixa de processo (tela/etapa/bottomsheet).
class FlowProcessBox extends StatelessWidget {
  const FlowProcessBox({super.key, required this.title, this.subtitle, this.chip, this.width = 200});
  final String title;
  final String? subtitle;
  final (String, FlowChipTone)? chip;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CpfSeguroColors.white,
        borderRadius: CpfSeguroRadius.all8,
        border: Border.all(color: CpfSeguroColors.neutral07, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(
              child: Text(title, style: CpfSeguroType.titleSm.copyWith(color: CpfSeguroColors.neutral01)),
            ),
            if (chip != null) FlowLegendChip(label: chip!.$1, tone: chip!.$2),
          ]),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: CpfSeguroType.bodySm.copyWith(color: CpfSeguroColors.neutral04)),
          ],
        ],
      ),
    );
  }
}

/// Losango de decisão.
class FlowDecision extends StatelessWidget {
  const FlowDecision({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(alignment: Alignment.center, children: [
        Transform.rotate(
          angle: 0.7853981633974483, // 45°
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: CpfSeguroColors.primary08,
              border: Border.all(color: CpfSeguroColors.primary04, width: 1),
              borderRadius: CpfSeguroRadius.all8,
            ),
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.primary04),
        ),
      ]),
    );
  }
}

/// Seta vertical com label ao lado.
class FlowVArrow extends StatelessWidget {
  const FlowVArrow({super.key, this.label, this.chip});
  final String? label;
  final (String, FlowChipTone)? chip;

  @override
  Widget build(BuildContext context) {
    final arrow = SizedBox(
      width: 10,
      height: 44,
      child: CustomPaint(painter: const _ArrowPainter(vertical: true)),
    );
    if (label == null && chip == null) return arrow;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        arrow,
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chip != null) FlowLegendChip(label: chip!.$1, tone: chip!.$2),
            if (label != null)
              Text(label!, style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04)),
          ],
        ),
      ],
    );
  }
}

/// Seta horizontal com label em cima.
class FlowHArrow extends StatelessWidget {
  const FlowHArrow({super.key, this.label, this.chip, this.width = 90});
  final String? label;
  final (String, FlowChipTone)? chip;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chip != null) ...[
            FlowLegendChip(label: chip!.$1, tone: chip!.$2),
            const SizedBox(height: 4),
          ],
          if (label != null) ...[
            Text(
              label!,
              textAlign: TextAlign.center,
              style: CpfSeguroType.labelSm.copyWith(color: CpfSeguroColors.neutral04),
            ),
            const SizedBox(height: 6),
          ],
          SizedBox(
            width: width,
            height: 10,
            child: CustomPaint(painter: const _ArrowPainter()),
          ),
        ],
      ),
    );
  }
}

/// Nó terminal textual ("→ Home").
class FlowEndPill extends StatelessWidget {
  const FlowEndPill({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CpfSeguroColors.primary08,
        borderRadius: CpfSeguroRadius.pillAll,
        border: Border.all(color: CpfSeguroColors.primary04, width: 1),
      ),
      child: Text(label, style: CpfSeguroType.labelMd.copyWith(color: CpfSeguroColors.primary04)),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({this.vertical = false});
  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CpfSeguroColors.neutral06
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final head = Paint()..color = CpfSeguroColors.neutral06;
    if (vertical) {
      final x = size.width / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height - 8), paint);
      final path = Path()
        ..moveTo(x - 5, size.height - 8)
        ..lineTo(x, size.height)
        ..lineTo(x + 5, size.height - 8)
        ..close();
      canvas.drawPath(path, head);
    } else {
      final y = size.height / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width - 8, y), paint);
      final path = Path()
        ..moveTo(size.width - 8, y - 5)
        ..lineTo(size.width, y)
        ..lineTo(size.width - 8, y + 5)
        ..close();
      canvas.drawPath(path, head);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
