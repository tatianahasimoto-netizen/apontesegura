#!/usr/bin/env bash
# Build + serve o catálogo Flutter Web em http://localhost:8080
set -e

cd "$(dirname "$0")"

echo "==> flutter pub get"
flutter pub get

echo "==> flutter build web --release"
flutter build web --release

echo "==> serving at http://localhost:8080"
cd build/web
python3 -m http.server 8080
