import 'dart:convert';
import 'dart:io';

import 'package:cpf_seguro_design_system/flows/flow_spec.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contrato do INPUT da máquina de telas: o FlowSpec parseia de JSON, valida o
/// grafo e faz round-trip (JSON→objeto→JSON) sem perda.
void main() {
  final file = File('lib/flows/fixtures/onboarding_cadastro.flow.json');
  final raw = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

  test('fixture real parseia e valida o grafo', () {
    final flow = FlowSpec.fromJson(raw);
    flow.validate(); // não lança
    expect(flow.id, 'onboarding-cadastro');
    expect(flow.lanes, contains('CAMINHO FELIZ'));
    // início existe
    expect(flow.nodes.any((n) => n.kind == FlowNodeKind.start), isTrue);
    // o passo de CPF carrega o dado e a dica de componente
    final cpf = flow.nodeById('cpf')!;
    expect(cpf.data, contains('cpf'));
    expect(cpf.componentHint, 'ChatInput');
    // desvio de erro modelado com tom
    final desvio = flow.edges.firstWhere((e) => e.to == 'cpfJa');
    expect(desvio.tone, FlowTone.error);
    // decisão é um nó decision
    expect(flow.nodeById('rascunho')!.kind, FlowNodeKind.decision);
  });

  test('round-trip JSON→objeto→JSON preserva o grafo', () {
    final flow = FlowSpec.fromJson(raw);
    final reparsed = FlowSpec.fromJson(flow.toJson());
    expect(reparsed.nodes.length, flow.nodes.length);
    expect(reparsed.edges.length, flow.edges.length);
    expect(reparsed.toJson(), flow.toJson());
  });

  test('validate() pega aresta pendurada', () {
    final broken = FlowSpec(
      id: 'x',
      title: 'x',
      nodes: const [FlowNode(id: 'a', kind: FlowNodeKind.start, label: 'a')],
      edges: const [FlowEdge(from: 'a', to: 'nao-existe')],
    );
    expect(broken.validate, throwsA(isA<FlowSpecError>()));
  });

  test('validate() exige nó de início', () {
    final semStart = FlowSpec(
      id: 'x',
      title: 'x',
      nodes: const [FlowNode(id: 'a', kind: FlowNodeKind.screen, label: 'a')],
      edges: const [],
    );
    expect(semStart.validate, throwsA(isA<FlowSpecError>()));
  });
}
