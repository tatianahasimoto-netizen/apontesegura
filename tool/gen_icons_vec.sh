#!/usr/bin/env bash
# Gera os icones precompilados (.vec) a partir do source SVG.
#
# Source of truth = svg_src/icons/*.svg (exportado do Figma, NAO vai no bundle).
# Saida = assets/icons/*.svg.vec (binario vector_graphics, ESSE vai no bundle).
#
# Rode sempre que adicionar/trocar um icone no source. Os .vec sao commitados
# (o build do Vercel nao roda dart), entao regenerar + commitar e obrigatorio.
#
#   ./tool/gen_icons_vec.sh
#
# O widget CpfSeguroIcon carrega o .vec via VectorGraphic (sem parse de XML em
# runtime). Nomes dos tokens em CpfSeguroIcons = nome do arquivo, estaveis.
set -euo pipefail
cd "$(dirname "$0")/.."

SRC=svg_src/icons
OUT=assets/icons

if [ ! -d "$SRC" ]; then
  echo "source ausente: $SRC" >&2
  exit 1
fi

echo "compilando $SRC/*.svg -> $OUT/*.svg.vec ..."
dart run vector_graphics_compiler --input-dir "$SRC" --out-dir "$OUT"
echo "ok: $(ls "$OUT"/*.vec | wc -l | tr -d ' ') .vec gerados"
