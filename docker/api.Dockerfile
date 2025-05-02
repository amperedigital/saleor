# ~/dev/saleor-dev/saleor-platform/docker/api.Dockerfile

FROM ghcr.io/saleor/saleor:3.20.1

USER root

# Install useful dev tools
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

USER saleor

# Copy our token init script (optional)
COPY scripts/write-admin-token.sh /app/write-admin-token.sh
