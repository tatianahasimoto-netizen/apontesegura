import 'package:flutter/widgets.dart';
import 'design_system/theme/cpf_seguro_colors.dart';

/// Cor do "roxo Figma" usado pros brackets/labels de spec table.
const _bracket = Color(0xFF9747FF);

/// Grupo de eixo (linhas OU colunas). O bracket com título vem em cima/à esquerda
/// e cobre todos os sub-labels do grupo.
class SpecAxisGroup {
  const SpecAxisGroup({required this.title, required this.subs});
  final String title;

  /// Sub-labels que aparecem dentro do grupo. Cada sub-label é uma célula
  /// no eixo (col ou row). Se [subs.length]=1, o group vira single-label.
  final List<String> subs;

  int get length => subs.length;
}

/// Renderiza uma matriz combinatória (rows × cols) com brackets + labels
/// nas margens, no estilo Figma "Instance Table".
///
/// Cada célula é construída por [cellBuilder] recebendo `(rowIdx, colIdx)`
/// no espaço achatado — ex: se `rowGroups=[3 subs, 2 subs]` então rowIdx vai
/// de 0 a 4 (5 rows totais).
class CpfSeguroSpecTable extends StatelessWidget {
  const CpfSeguroSpecTable({
    super.key,
    required this.columnGroups,
    required this.rowGroups,
    required this.cellBuilder,
    this.cellWidth = 140,
    this.cellHeight = 100,
  });

  final List<SpecAxisGroup> columnGroups;
  final List<SpecAxisGroup> rowGroups;
  final Widget Function(int rowIdx, int colIdx) cellBuilder;
  final double cellWidth;
  final double cellHeight;

  int get _totalCols => columnGroups.fold(0, (a, g) => a + g.length);
  int get _totalRows => rowGroups.fold(0, (a, g) => a + g.length);

  static const double _colTitleH = 22;
  static const double _colBracketH = 8;
  static const double _colSubH = 22;
  static const double _rowSubW = 90;
  static const double _rowBracketW = 8;
  static const double _rowTitleW = 22;

  double get _headerHeight => _colTitleH + _colBracketH + _colSubH;
  double get _sideWidth => _rowTitleW + _rowBracketW + _rowSubW;

  @override
  Widget build(BuildContext context) {
    // Eixo único (1 linha) → fluxo de células rotuladas que QUEBRAM pra próxima
    // linha quando não cabem (em vez de rolar horizontal). Cada célula leva seu
    // label em cima. Como quase toda tabela varia só um prop, é o caso comum.
    if (_totalRows == 1) {
      final labeled = <(String, int)>[];
      var col = 0;
      for (final g in columnGroups) {
        for (final sub in g.subs) {
          final lbl =
              (columnGroups.length > 1 && g.title != '·') ? '${g.title} · $sub' : sub;
          labeled.add((lbl, col));
          col++;
        }
      }
      return Wrap(
        spacing: 20,
        runSpacing: 24,
        children: [
          for (final entry in labeled)
            SizedBox(
              width: cellWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(entry.$1, style: _labelStyle),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: cellHeight),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: cellBuilder(0, entry.$2),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    final gridWidth = _totalCols * cellWidth;
    final gridHeight = _totalRows * cellHeight;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: _sideWidth + gridWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Top labels (title + bracket + subs) ─────────────────────────
            Row(
              children: [
                SizedBox(width: _sideWidth),
                SizedBox(
                  width: gridWidth,
                  child: _ColumnGroupsHeader(
                    groups: columnGroups,
                    cellWidth: cellWidth,
                    titleH: _colTitleH,
                    bracketH: _colBracketH,
                    subH: _colSubH,
                  ),
                ),
              ],
            ),
            // ─── Rows: side labels + cells ──────────────────────────────────
            SizedBox(
              width: _sideWidth + gridWidth,
              height: gridHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: _sideWidth,
                    height: gridHeight,
                    child: _RowGroupsSide(
                      groups: rowGroups,
                      cellHeight: cellHeight,
                      titleW: _rowTitleW,
                      bracketW: _rowBracketW,
                      subW: _rowSubW,
                    ),
                  ),
                  SizedBox(
                    width: gridWidth,
                    height: gridHeight,
                    child: _Grid(
                      cols: _totalCols,
                      rows: _totalRows,
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      cellBuilder: cellBuilder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Header (column groups)
// ═══════════════════════════════════════════════════════════════════════════

class _ColumnGroupsHeader extends StatelessWidget {
  const _ColumnGroupsHeader({
    required this.groups,
    required this.cellWidth,
    required this.titleH,
    required this.bracketH,
    required this.subH,
  });

  final List<SpecAxisGroup> groups;
  final double cellWidth;
  final double titleH;
  final double bracketH;
  final double subH;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: titleH + bracketH,
          child: Row(
            children: [
              for (final g in groups)
                SizedBox(
                  width: g.length * cellWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: titleH,
                        child: Center(
                          child: Text(g.title, style: _labelStyle),
                        ),
                      ),
                      _HBracket(width: g.length * cellWidth, height: bracketH),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: subH,
          child: Row(
            children: [
              for (final g in groups)
                for (final sub in g.subs)
                  SizedBox(
                    width: cellWidth,
                    child: Center(child: Text(sub, style: _labelStyle)),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Side (row groups)
// ═══════════════════════════════════════════════════════════════════════════

class _RowGroupsSide extends StatelessWidget {
  const _RowGroupsSide({
    required this.groups,
    required this.cellHeight,
    required this.titleW,
    required this.bracketW,
    required this.subW,
  });

  final List<SpecAxisGroup> groups;
  final double cellHeight;
  final double titleW;
  final double bracketW;
  final double subW;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: titleW + bracketW,
          child: Column(
            children: [
              for (final g in groups)
                SizedBox(
                  height: g.length * cellHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: titleW,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Center(child: Text(g.title, style: _labelStyle)),
                        ),
                      ),
                      _VBracket(height: g.length * cellHeight, width: bracketW),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: subW,
          child: Column(
            children: [
              for (final g in groups)
                for (final sub in g.subs)
                  SizedBox(
                    height: cellHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(sub, style: _labelStyle),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Grid (cells)
// ═══════════════════════════════════════════════════════════════════════════

class _Grid extends StatelessWidget {
  const _Grid({
    required this.cols,
    required this.rows,
    required this.cellWidth,
    required this.cellHeight,
    required this.cellBuilder,
  });

  final int cols;
  final int rows;
  final double cellWidth;
  final double cellHeight;
  final Widget Function(int rowIdx, int colIdx) cellBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      // foregroundDecoration: pinta a borda POR CIMA sem inserir o filho pra
      // dentro. Com decoration.border (0.5+0.5=1px) o Row de células perdia 1px
      // e estourava por 1.00px. Aqui o Row recebe a largura cheia.
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: _bracket.withOpacity(0.4), width: 0.5),
      ),
      child: Column(
        children: [
          for (var r = 0; r < rows; r++)
            SizedBox(
              height: cellHeight,
              child: Row(
                children: [
                  for (var c = 0; c < cols; c++)
                    Container(
                      width: cellWidth,
                      height: cellHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          right: c < cols - 1
                              ? BorderSide(color: _bracket.withOpacity(0.25), width: 0.5)
                              : BorderSide.none,
                          bottom: r < rows - 1
                              ? BorderSide(color: _bracket.withOpacity(0.25), width: 0.5)
                              : BorderSide.none,
                        ),
                      ),
                      child: Center(child: cellBuilder(r, c)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Bracket painters (aberto pra baixo / pra direita — estilo Figma "[ ]")
// ═══════════════════════════════════════════════════════════════════════════

class _HBracket extends StatelessWidget {
  const _HBracket({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _HBracketPainter()),
    );
  }
}

class _HBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _bracket
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = 4.0;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true)
      ..lineTo(size.width - r, 0)
      ..arcToPoint(Offset(size.width, r), radius: Radius.circular(r), clockwise: true)
      ..lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VBracket extends StatelessWidget {
  const _VBracket({required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _VBracketPainter()),
    );
  }
}

class _VBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _bracket
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = 4.0;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(r, 0)
      ..arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: false)
      ..lineTo(0, size.height - r)
      ..arcToPoint(Offset(r, size.height), radius: Radius.circular(r), clockwise: false)
      ..lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// Style helpers
// ═══════════════════════════════════════════════════════════════════════════

const TextStyle _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: _bracket,
);

/// Wrapper de section pra spec table: título + meta + tabela.
class SpecSection extends StatelessWidget {
  const SpecSection({
    super.key,
    required this.title,
    required this.child,
    this.figmaNode,
    this.subtitle,
    this.composedOf,
  });

  final String title;
  final Widget child;
  final String? figmaNode;
  final String? subtitle;
  final List<String>? composedOf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CpfSeguroColors.neutral01,
              ),
            ),
            if (figmaNode != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _bracket.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Figma $figmaNode',
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: _bracket,
                  ),
                ),
              ),
            ],
          ]),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                height: 20 / 13,
                color: CpfSeguroColors.neutral03,
              ),
            ),
          ],
          if (composedOf != null && composedOf!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                const Text('compõe:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: CpfSeguroColors.neutral05)),
                for (final w in composedOf!)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: CpfSeguroColors.neutral10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CpfSeguroColors.neutral09, width: 1),
                    ),
                    child: Text(
                      w,
                      style: const TextStyle(
                        fontSize: 11, fontFamily: 'monospace', color: CpfSeguroColors.neutral03,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

/// Divisor grande entre camadas do atomic design (Specs).
class SpecTierHeader extends StatelessWidget {
  const SpecTierHeader({super.key, required this.tier, required this.description});
  final String tier;
  final String description;

  static const _colors = {
    'TOKENS': (CpfSeguroColors.neutral02, CpfSeguroColors.neutral09),
    'ATOMS': (CpfSeguroColors.primary04, CpfSeguroColors.primary08),
    'MOLECULES': (CpfSeguroColors.success04, CpfSeguroColors.success07),
    'ORGANISMS': (CpfSeguroColors.warning04, CpfSeguroColors.warning07),
  };

  @override
  Widget build(BuildContext context) {
    final palette = _colors[tier] ?? (CpfSeguroColors.neutral02, CpfSeguroColors.neutral09);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: palette.$2,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: palette.$1, width: 1),
            ),
            child: Text(
              tier,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.4, color: palette.$1),
            ),
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 14, color: CpfSeguroColors.neutral03, height: 20 / 14)),
          const SizedBox(height: 8),
          Container(height: 1, color: palette.$2),
        ],
      ),
    );
  }
}
