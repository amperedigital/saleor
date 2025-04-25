#!/usr/bin/env bash
set -e

# 0) Source our .env files from the project root
if [ -f /app/common.env ]; then
  set -o allexport
  . /app/common.env
  set +o allexport
fi
if [ -f /app/backend.env ]; then
  set -o allexport
  . /app/backend.env
  set +o allexport
fi
if [ -f /app/saleor-app-extension/.env ]; then
  set -o allexport
  . /app/saleor-app-extension/.env
  set +o allexport
fi

echo "🛠️  Applying migrations…"
python3 manage.py migrate --no-input

echo "👤 Ensuring superuser…"
python3 manage.py createsuperuser \
  --no-input \
  --email="$DJANGO_SUPERUSER_EMAIL" \
  --username="$DJANGO_SUPERUSER_EMAIL" \
  || echo "👤 Superuser exists, skipping"

echo "🚀 Launching dev server on 0.0.0.0:8000…"
exec python3 manage.py runserver 0.0.0.0:8000
