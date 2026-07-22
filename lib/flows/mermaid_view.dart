// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'package:flutter/widgets.dart';

/// Ponte pro `window.renderMermaid(el, def)` vendorado no web/index.html.
@JS('renderMermaid')
external void _renderMermaid(web.HTMLElement el, String def);

/// Renderiza uma definição mermaid (flowchart) via mermaid.js vendorado no
/// web/index.html. O container HTML tem pan (drag) e zoom (wheel) próprios —
/// não precisa de scroll/InteractiveViewer do lado Flutter.
///
/// Convenção de classes pros estados (o [MermaidView] injeta os classDefs em
/// toda definição — é só usar `:::err`, `:::state`, `:::empty`, `:::opt`):
/// - `err`   — erro/bloqueio (vermelho)
/// - `state` — estado transversal (cinza)
/// - `empty` — empty state (âmbar)
/// - `opt`   — passo opcional (azul tracejado)
/// - `fim`   — terminal (pill azul)
class MermaidView extends StatelessWidget {
  const MermaidView({super.key, required this.definition});

  /// Definição mermaid (ex.: `flowchart TD\n A --> B`).
  final String definition;

  /// classDefs padrão do DS, anexados a toda definição.
  static const String _classDefs = '''

classDef err fill:#FEF3F2,stroke:#B42318,color:#7E1911
classDef state fill:#F6F6F6,stroke:#B3B3B3,color:#3D3939
classDef empty fill:#FEF4E6,stroke:#B55B08,color:#623104
classDef opt fill:#EEF3FF,stroke:#003BE0,color:#003BE0,stroke-dasharray:5 4
classDef fim fill:#003BE0,stroke:#003BE0,color:#FFFFFF
''';

  static final Set<String> _registered = <String>{};

  @override
  Widget build(BuildContext context) {
    final def = '$definition$_classDefs';
    final viewType = 'mermaid-${def.hashCode}';
    if (!_registered.contains(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final el = web.document.createElement('div') as web.HTMLDivElement;
        el.style
          ..width = '100%'
          ..height = '100%'
          ..overflow = 'hidden'
          ..cursor = 'grab'
          ..backgroundColor = '#FFFFFF';
        _renderMermaid(el, def);
        return el;
      });
      _registered.add(viewType);
    }
    return HtmlElementView(viewType: viewType);
  }
}
