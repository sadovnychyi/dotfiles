#!/usr/bin/env bash
set -euo pipefail
mkcert -install
mkcert -cert-file "$HOME/.localhost.crt" -key-file "$HOME/.localhost.key" \
  localhost contracts.localhost '*.contracts.localhost'
nginx -t
brew services restart nginx
