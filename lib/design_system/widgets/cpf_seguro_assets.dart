import 'package:flutter/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// CPF SEGURO — resolver de assets do package.
///
/// Widgets do DS carregam SVG (ícones, ilustrações) do próprio package. Pra
/// funcionar tanto no **catálogo** (que é o package root, assets na raiz)
/// quanto num **app consumidor** (que recebe os assets do package sob o
/// namespace `packages/cpf_seguro_design_system/`), este resolver tenta a
/// chave prefixada primeiro e cai pra chave crua. Assim os widgets renderizam
/// nos dois contextos sem precisar quebrar o catálogo num `example/` separado.
///
/// O SVG cru é cacheado (estático) por chave lógica — o load só acontece uma
/// vez por asset; renders seguintes são sync do cache.
class CpfSeguroAssets {
  const CpfSeguroAssets._();

  static const String package = 'cpf_seguro_design_system';

  /// Namespace do package pros assets precompilados `.vec`. `null` = catálogo
  /// root (assets na raiz). O app consumidor seta `package` pra resolver sob
  /// `packages/cpf_seguro_design_system/`. Diferente do SVG cru, o
  /// [AssetBytesLoader] resolve o namespace nativamente via `packageName`.
  static String? assetPackage;

  /// Loader do binário `.vec` (vector_graphics). Sem parse de XML em runtime;
  /// o próprio [AssetBytesLoader] cacheia a Picture decodificada por chave.
  static AssetBytesLoader vecLoader(String path) =>
      AssetBytesLoader(path, packageName: assetPackage);

  static final Map<String, String> _svgCache = {};

  /// SVG cru já em cache (sync). `null` se ainda não carregado.
  static String? cachedSvg(String path) => _svgCache[path];

  /// Carrega o SVG cru: tenta `packages/<pkg>/<path>` (app consumidor) e cai
  /// pra `<path>` (catálogo root). Cacheia pela chave lógica [path].
  static Future<String> loadSvg(AssetBundle bundle, String path) async {
    final hit = _svgCache[path];
    if (hit != null) return hit;
    String raw;
    try {
      raw = await bundle.loadString('packages/$package/$path');
    } catch (_) {
      raw = await bundle.loadString(path);
    }
    _svgCache[path] = raw;
    return raw;
  }
}
