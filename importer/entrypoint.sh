#!/bin/sh
set -e
echo "⏳ Waiting for API to be ready..."
until curl -s http://api:8000/health/ > /dev/null; do sleep 2; done
echo "✅ API is ready."

echo "🔐 Generating admin token..."
response=$(curl -s -X POST http://api:8000/graphql/ \
  -H "Content-Type: application/json" \
  --data-raw '{
    "query": "mutation TokenCreate($email: String!, $password: String!) { tokenCreate(email: $email, password: $password) { token errors { message } user { email isStaff }}}",
    "variables": {
      "email": "'"$ADMIN_EMAIL"'",
      "password": "'"$ADMIN_PASSWORD"'"
    }
  }')

token=$(echo "$response" | jq -r '.data.tokenCreate.token')
mkdir -p /app/tokens && echo "$token" > /app/tokens/admin.token
echo "✅ Token saved to /app/tokens/admin.token"
