import 'package:flutter/widgets.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Text (primitivo instrumentado).
///
/// Wrapper de [Text] com dev inspect — mostra o preset de tipografia, tamanho,
/// peso, altura de linha e a cor (por token). Drop-in pra `Text(str, style:)`
/// em qualquer texto SOLTO das telas de handoff. Consome o subsistema
/// [CpfSeguroDevInfo]/[CpfSeguroDevMode] (import acima).
class CpfSeguroText extends StatelessWidget {
  const CpfSeguroText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
    if (!CpfSeguroDevMode.of(context)) return text;
    final sz = style?.fontSize;
    final h = style?.height;
    final wIdx = style?.fontWeight?.index;
    final weight = wIdx == null ? '' : ' · ${(wIdx + 1) * 100}';
    final line = (sz != null && h != null) ? ' · lh ${(sz * h).round()}' : '';
    return CpfSeguroDevInfo(
      component: 'Text',
      props: {'"$data"': ''},
      tokens: [
        'type: ${cpfSeguroTypeToken(style)}${sz != null ? ' (${sz.toInt()}px$weight$line)' : ''}',
        'color: ${cpfSeguroColorToken(style?.color)}',
      ],
      child: text,
    );
  }
}
