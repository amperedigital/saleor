#!/bin/sh

echo "🕓 Waiting for ngrok to be ready..."

# Wait until ngrok API responds
until curl -s http://ngrok:4040/api/tunnels > /dev/null; do
  sleep 1
done

# Extract public_url
PUBLIC_URL=$(curl -s http://ngrok:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | cut -d '"' -f4)

if [ -z "$PUBLIC_URL" ]; then
  echo "❌ Could not get ngrok URL"
  exit 1
fi

echo "🌐 Ngrok URL detected: $PUBLIC_URL"

# Update .env file
ENV_FILE=/env/.env
cp $ENV_FILE /env/.env.bak

sed -i "s|^API_URL=.*|API_URL=${PUBLIC_URL}/graphql/|" $ENV_FILE
sed -i "s|^EXTENSIONS_API_URL=.*|EXTENSIONS_API_URL=${PUBLIC_URL}/graphql/|" $ENV_FILE

echo "✅ Updated .env with Ngrok URL"

# Restart dashboard container
echo "🔁 Restarting dashboard..."
docker restart saleor-platform-dashboard-1

echo "🎉 Done! Access dashboard at http://localhost:9000"
