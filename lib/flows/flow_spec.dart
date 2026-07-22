/// CPF SEGURO — FlowSpec: o INPUT da máquina de telas, como DADO.
///
/// Formaliza "um user flow" num grafo serializável (nós + arestas + raias),
/// fiel ao vocabulário do [flow_kit] / mermaid, mas máquina-legível: o
/// compositor lê isto pra montar telas (ver `DS_SCREEN_MACHINE.md`).
///
/// Origens do input:
/// - MINERADO do app real (rota→fluxo + paths-fonte) — documenta/regenera.
/// - AUTORAL (product/design descreve um fluxo novo) — cria telas novas.
///
/// Serializa/parseia com [toJson]/[fromJson] (sem codegen). [validate] checa as
/// invariantes do grafo (ids únicos, arestas referenciando nós, raias válidas).
library;

/// Papel do nó no grafo.
enum FlowNodeKind {
  start, // início ( ( ) )
  screen, // tela/etapa/bottomsheet
  decision, // losango de decisão
  terminal, // saída (→ /login, → home)
}

/// Tom do nó/aresta — mesma semântica dos chips do flow_kit.
enum FlowTone {
  normal, // caminho padrão
  error, // erro/bloqueio (:::err)
  optional, // passo opcional (:::opt)
  state, // estado transversal/loading (:::state)
  empty, // empty state (:::empty)
  terminal, // terminal (:::fim)
}

/// Um nó do fluxo.
class FlowNode {
  const FlowNode({
    required this.id,
    required this.kind,
    required this.label,
    this.route,
    this.intent,
    this.tone = FlowTone.normal,
    this.lane,
    this.data = const [],
    this.componentHint,
    this.optional = false,
  });

  /// Id único no fluxo (referenciado pelas arestas).
  final String id;
  final FlowNodeKind kind;

  /// Título humano ("CPF", "Confirmar senha").
  final String label;

  /// Rota do app quando é tela (`/onboarding/register`).
  final String? route;

  /// Intenção do passo — o que o compositor precisa realizar ("capturar CPF").
  final String? intent;
  final FlowTone tone;

  /// Raia a que pertence (CAMINHO FELIZ, DESVIOS DO CPF...).
  final String? lane;

  /// Campos capturados neste passo (["cpf"], ["senha"]).
  final List<String> data;

  /// Dica de componente do DS (ex.: "ChatInput", "OtpInput"). Opcional — sem
  /// ela o compositor decide pela intenção + manifesto.
  final String? componentHint;
  final bool optional;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'label': label,
        if (route != null) 'route': route,
        if (intent != null) 'intent': intent,
        if (tone != FlowTone.normal) 'tone': tone.name,
        if (lane != null) 'lane': lane,
        if (data.isNotEmpty) 'data': data,
        if (componentHint != null) 'componentHint': componentHint,
        if (optional) 'optional': optional,
      };

  factory FlowNode.fromJson(Map<String, dynamic> j) => FlowNode(
        id: j['id'] as String,
        kind: FlowNodeKind.values.byName(j['kind'] as String),
        label: j['label'] as String,
        route: j['route'] as String?,
        intent: j['intent'] as String?,
        tone: j['tone'] == null
            ? FlowTone.normal
            : FlowTone.values.byName(j['tone'] as String),
        lane: j['lane'] as String?,
        data: (j['data'] as List?)?.cast<String>() ?? const [],
        componentHint: j['componentHint'] as String?,
        optional: j['optional'] as bool? ?? false,
      );
}

/// Uma transição entre nós.
class FlowEdge {
  const FlowEdge({
    required this.from,
    required this.to,
    this.label,
    this.tone = FlowTone.normal,
    this.dashed = false,
  });

  final String from;
  final String to;

  /// Rótulo da transição ("li e concordo", "código válido", "3s").
  final String? label;
  final FlowTone tone;

  /// Aresta tracejada = retomada/retry (o `-.->`  do mermaid).
  final bool dashed;

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        if (label != null) 'label': label,
        if (tone != FlowTone.normal) 'tone': tone.name,
        if (dashed) 'dashed': dashed,
      };

  factory FlowEdge.fromJson(Map<String, dynamic> j) => FlowEdge(
        from: j['from'] as String,
        to: j['to'] as String,
        label: j['label'] as String?,
        tone: j['tone'] == null
            ? FlowTone.normal
            : FlowTone.values.byName(j['tone'] as String),
        dashed: j['dashed'] as bool? ?? false,
      );
}

/// Proveniência de um fluxo minerado (pra rastrear o que gerou o input).
class FlowSource {
  const FlowSource({required this.origin, this.files = const [], this.routes = const {}});

  /// De onde veio ("app real · design-hunter").
  final String origin;

  /// Paths-fonte no app que compõem o fluxo.
  final List<String> files;

  /// Mapa rota → nó de entrada.
  final Map<String, String> routes;

  Map<String, dynamic> toJson() => {
        'origin': origin,
        if (files.isNotEmpty) 'files': files,
        if (routes.isNotEmpty) 'routes': routes,
      };

  factory FlowSource.fromJson(Map<String, dynamic> j) => FlowSource(
        origin: j['origin'] as String,
        files: (j['files'] as List?)?.cast<String>() ?? const [],
        routes: (j['routes'] as Map?)?.cast<String, String>() ?? const {},
      );
}

/// Erro de validação do grafo (ids/arestas/raias inconsistentes).
class FlowSpecError implements Exception {
  const FlowSpecError(this.message);
  final String message;
  @override
  String toString() => 'FlowSpecError: $message';
}

/// Um user flow completo — o input da máquina de telas.
class FlowSpec {
  const FlowSpec({
    required this.id,
    required this.title,
    this.subtitle,
    this.lanes = const [],
    required this.nodes,
    required this.edges,
    this.source,
  });

  /// Id kebab-case ("onboarding-cadastro").
  final String id;
  final String title;
  final String? subtitle;

  /// Raias declaradas (ordem de leitura: CAMINHO FELIZ primeiro).
  final List<String> lanes;
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final FlowSource? source;

  FlowNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  /// Checa as invariantes do grafo. Lança [FlowSpecError] no primeiro problema.
  void validate() {
    final ids = <String>{};
    for (final n in nodes) {
      if (!ids.add(n.id)) {
        throw FlowSpecError('id de nó duplicado: "${n.id}"');
      }
      if (n.lane != null && !lanes.contains(n.lane)) {
        throw FlowSpecError('nó "${n.id}" referencia raia inexistente: "${n.lane}"');
      }
    }
    for (final e in edges) {
      if (!ids.contains(e.from)) {
        throw FlowSpecError('aresta parte de nó inexistente: "${e.from}"');
      }
      if (!ids.contains(e.to)) {
        throw FlowSpecError('aresta vai pra nó inexistente: "${e.to}"');
      }
    }
    if (!nodes.any((n) => n.kind == FlowNodeKind.start)) {
      throw FlowSpecError('fluxo sem nó de início (start)');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        if (lanes.isNotEmpty) 'lanes': lanes,
        'nodes': nodes.map((n) => n.toJson()).toList(),
        'edges': edges.map((e) => e.toJson()).toList(),
        if (source != null) 'source': source!.toJson(),
      };

  factory FlowSpec.fromJson(Map<String, dynamic> j) => FlowSpec(
        id: j['id'] as String,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String?,
        lanes: (j['lanes'] as List?)?.cast<String>() ?? const [],
        nodes: (j['nodes'] as List)
            .map((e) => FlowNode.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        edges: (j['edges'] as List)
            .map((e) => FlowEdge.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        source: j['source'] == null
            ? null
            : FlowSource.fromJson((j['source'] as Map).cast<String, dynamic>()),
      );
}
