#!/bin/bash

GRAPHQL_ENDPOINT="http://localhost:8000/graphql/"
TOKEN=$(cat ./auth/admin_token.txt)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

QUERY=$1

curl -s "$GRAPHQL_ENDPOINT" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"$QUERY\"}" | "$PROJECT_ROOT/bin/jq"
