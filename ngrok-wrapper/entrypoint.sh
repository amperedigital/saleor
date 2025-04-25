#!/bin/bash
set -e

sleep 5  # ⏳ Delay to ensure DNS + API container is ready

echo "⏳ Waiting for Saleor API at http://api:8000..."
for i in {1..30}; do
  if curl -sSf http://api:8000/graphql/ > /dev/null; then
    echo "✅ Saleor API is online."
    break
  fi
  echo "⏳ Retry $i: API not ready..."
  sleep 2
done

echo "🚀 Launching ngrok..."
exec ngrok start --all --config /ngrok/ngrok.yml --log stdout
