#!/usr/bin/env bash
# Build command real do Vercel (o campo buildCommand do vercel.json tem limite
# de 256 caracteres, então a lógica mora aqui em vez de inline).
set -e

if [ ! -x flutter/bin/flutter ]; then
  curl -sL -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.44.4-stable.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

git config --global --add safe.directory '*'
export PATH="$PWD/flutter/bin:$PATH"

flutter config --enable-web --no-analytics
flutter pub get
flutter test
flutter build web --release
