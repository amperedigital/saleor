#!/usr/bin/env bash
set -e

# Wait for ngrok’s local API
until curl -s http://ngrok:4040/api/tunnels > /dev/null; do
  sleep 1
done

# Grab the HTTPS tunnel
TUNNEL=$(curl -s http://ngrok:4040/api/tunnels \
  | jq -r '.tunnels[]|select(.proto=="https")|.public_url' \
  | head -n1)

echo "🔗 ngrok tunnel is $TUNNEL"

# Patch common.env
sed -i '/^DASHBOARD_URL=/d' common.env
echo "DASHBOARD_URL=$TUNNEL" >> common.env
sed -i '/^ALLOWED_HOSTS=/d' common.env
echo "ALLOWED_HOSTS=localhost,api,127.0.0.1,${TUNNEL#https://}" >> common.env

# Patch extension .env
sed -i '/^APP_API_BASE_URL=/d' saleor-app-extension/.env
echo "APP_API_BASE_URL=$TUNNEL" >> saleor-app-extension/.env
sed -i '/^APP_IFRAME_BASE_URL=/d' saleor-app-extension/.env
echo "APP_IFRAME_BASE_URL=$TUNNEL" >> saleor-app-extension/.env

echo "✅ Env files updated with $TUNNEL"
