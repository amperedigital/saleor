# docker/api.Dockerfile
FROM ghcr.io/saleor/saleor:3.20.82

USER root

# Install dev tools
RUN apt-get update && apt-get install -y \
  bash \
  curl \
  jq \
  nano \
  less \
  net-tools \
  iputils-ping \
  python3 \
  && rm -rf /var/lib/apt/lists/*

# Stub out health_check so Django can import it with two args
RUN printf 'def health_check(application, path):\n    return application\n' \
    > /app/saleor/wsgi/health_check.py


USER saleor

# Copy our init script into the image
COPY scripts/write-admin-token.sh /app/write-admin-token.sh
# ─────────────────────────────────────────────────────────────────────────────
# (rest of file unchanged)
