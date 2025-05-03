# docker/api.Dockerfile
FROM ghcr.io/saleor/saleor:3.20.1

USER root

# Install dev/debugging tools
RUN apt-get update && apt-get install -y \
  bash curl jq nano less net-tools iputils-ping python3 \
  && rm -rf /var/lib/apt/lists/*

# Optional: Copy your token writer or other scripts
COPY scripts/write-admin-token.sh /app/write-admin-token.sh

# Use Gunicorn to run Django WSGI app
CMD ["gunicorn", "--config", "saleor/gunicorn.conf.py", "saleor.asgi:application"]
