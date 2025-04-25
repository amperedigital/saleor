#!/bin/bash

# Read NGROK public URL
NGROK_API="http://localhost:4040/api/tunnels"
NGROK_URL=$(curl -s $NGROK_API | jq -r '.tunnels[0].public_url')

if [[ -z "$NGROK_URL" ]]; then
  echo "❌ Failed to get public URL from ngrok"
  exit 1
fi

echo "🌐 Ngrok public URL: $NGROK_URL"

# Update .env file in /saleor-platform
ENV_FILE="./.env"
sed -i.bak "s|^API_URL=.*|API_URL=${NGROK_URL}/graphql/|" $ENV_FILE
sed -i.bak "s|^EXTENSIONS_API_URL=.*|EXTENSIONS_API_URL=${NGROK_URL}/graphql/|" $ENV_FILE

echo "✅ Updated API_URL and EXTENSIONS_API_URL in $ENV_FILE"

# Restart the dashboard container only
docker compose restart dashboard

echo "🔁 Dashboard restarted!"
echo "🔗 Login URL: http://localhost:9000"
