#!/usr/bin/env bash
set -e

echo "🔑 Generating token & installing extension…"

# 1) Generate JWT
RESPONSE=$(curl -s http://api:8000/graphql \
  -H "Content-Type: application/json" \
  -d "{\"query\":\"mutation { tokenCreate(email: \\\"${DJANGO_SUPERUSER_EMAIL}\\\", password: \\\"${DJANGO_SUPERUSER_PASSWORD}\\\") { token errors { field message } } }\"}")

TOKEN=$(echo "$RESPONSE" | jq -r '.data.tokenCreate.token // empty')
if [ -z "$TOKEN" ]; then
  echo "❌ tokenCreate failed:" >&2
  echo "$RESPONSE" | jq '.data.tokenCreate.errors' >&2
  exit 1
fi

# 2) Compute TTL
PAYLOAD=$(echo "$TOKEN" | cut -d . -f2 | base64 -d 2>/dev/null || echo '{}')
EXP=$(echo "$PAYLOAD" | jq '.exp // 0')
NOW=$(date +%s)
TTL=$((EXP - NOW))

# 3) Write token
echo "{\"Authorization\":\"Bearer $TOKEN\",\"ttl_seconds\":$TTL}" > /app/auth/token.txt

# 4) Install app via GraphQL
INSTALL=$(curl -s http://api:8000/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  --data-raw '{"query":"mutation InstallApp{ appInstall(input:{appName:\"saleor-app-extension\",manifestUrl:\"http://saleor-app-extension:3000/api/manifest/\"}){ appInstallation{ id status appName } appErrors{ field message } } }"}')

echo "$INSTALL" > /app/auth/install_response.json
echo "✅ Token and install_response.json written."
