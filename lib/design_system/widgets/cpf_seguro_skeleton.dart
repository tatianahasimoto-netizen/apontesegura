import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_dev_inspect.dart';

enum _SkelShape { box, line, circle }

/// CPF SEGURO — Skeleton (forma de placeholder de loading).
///
/// A FORMA cinza que ocupa o lugar do conteúdo enquanto carrega. Não anima
/// sozinha — embrulhe num [CpfSeguroShimmer] pra ganhar o brilho. Compõe-se
/// pra montar o esqueleto de uma tela (linhas de texto, avatar, cards).
///
/// ```dart
/// CpfSeguroShimmer(child: Column(children: [
///   CpfSeguroSkeleton.circle(size: 40),
///   CpfSeguroSkeleton.line(width: 160),
///   CpfSeguroSkeleton.box(height: 120),
/// ]))
/// ```
class CpfSeguroSkeleton extends StatelessWidget {
  /// Caixa retangular (card, imagem, bloco). `width` null = ocupa o pai.
  const CpfSeguroSkeleton.box({super.key, this.width, this.height, this.radius})
      : _shape = _SkelShape.box;

  /// Linha de texto (pill baixa). `width` null = ocupa o pai.
  const CpfSeguroSkeleton.line({super.key, this.width, this.height})
      : radius = null,
        _shape = _SkelShape.line;

  /// Círculo (avatar / ícone).
  const CpfSeguroSkeleton.circle({super.key, double size = 40})
      : width = size,
        height = size,
        radius = null,
        _shape = _SkelShape.circle;

  final double? width;
  final double? height;
  final double? radius;
  final _SkelShape _shape;

  @override
  Widget build(BuildContext context) {
    final h = height ?? (_shape == _SkelShape.line ? 12.0 : 16.0);
    final r = switch (_shape) {
      _SkelShape.circle => BorderRadius.circular(h / 2),
      _SkelShape.line => BorderRadius.circular(h / 2),
      _SkelShape.box => radius != null
          ? BorderRadius.circular(radius!)
          : CpfSeguroRadius.all4,
    };
    return CpfSeguroDevInfo(
      component: 'CpfSeguroSkeleton',
      props: {'shape': _shape.name},
      tokens: const ['fill neutral-08', 'radius: circle/pill/4 por forma'],
      child: Container(
        width: width,
        height: h,
        decoration: BoxDecoration(color: CpfSeguroColors.neutral08, borderRadius: r),
      ),
    );
  }
}

/// CPF SEGURO — Shimmer (efeito de brilho sobre skeletons).
///
/// Wrapper: aplica um sweep de gradiente animado sobre os [CpfSeguroSkeleton]
/// filhos enquanto [isLoading]. O loop consome [CpfSeguroMotion.shimmer]. Quando
/// `isLoading` é false, renderiza o child normalmente (sem brilho) — troque o
/// child pelo conteúdo real.
class CpfSeguroShimmer extends StatefulWidget {
  const CpfSeguroShimmer({super.key, this.isLoading = true, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  State<CpfSeguroShimmer> createState() => _CpsShimmerState();
}

class _CpsShimmerState extends State<CpfSeguroShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: CpfSeguroMotion.shimmer);
  late final Animation<double> _a = Tween<double>(begin: 0, end: 2)
      .animate(CurvedAnimation(parent: _c, curve: CpfSeguroMotion.standard));

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) _c.repeat();
  }

  @override
  void didUpdateWidget(CpfSeguroShimmer old) {
    super.didUpdateWidget(old);
    if (widget.isLoading != old.isLoading) {
      widget.isLoading ? _c.repeat() : _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: const Alignment(-1, 0),
          end: const Alignment(1, 0),
          tileMode: TileMode.clamp,
          colors: [
            CpfSeguroColors.neutral10.withValues(alpha: 0.5),
            CpfSeguroColors.white.withValues(alpha: 0.1),
          ],
          stops: [_a.value, _a.value + 0.9],
        ).createShader(bounds),
        child: child,
      ),
      child: widget.child,
    );
  }
}
