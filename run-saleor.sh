#!/usr/bin/env bash
set -e

# 0) Source the .env files (common, backend & extension)
if [ -f /app/common.env ]; then
  set -o allexport; . /app/common.env; set +o allexport
fi
if [ -f /app/backend.env ]; then
  set -o allexport; . /app/backend.env; set +o allexport
fi
if [ -f /app/saleor-app-extension/.env ]; then
  set -o allexport; . /app/saleor-app-extension/.env; set +o allexport
fi

echo "🛠️  Applying migrations…"
python3 manage.py migrate --no-input

echo "🔑 Skipping superuser creation here (handled by token-init)"

echo "🚀 Starting Django devserver on 0.0.0.0:8000…"
exec python3 manage.py runserver 0.0.0.0:8000 --verbosity 3
