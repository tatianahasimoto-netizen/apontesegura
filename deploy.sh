#!/usr/bin/env bash
# Build + deploy o catálogo pra Vercel prod. Uso: ./deploy.sh
set -e
cd "$(dirname "$0")"

echo "==> flutter build web --release"
flutter build web --release

echo "==> vercel --prod"
cd build/web
vercel --prod --yes
