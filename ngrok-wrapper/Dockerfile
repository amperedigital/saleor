FROM alpine:latest

RUN apk add --no-cache curl jq bash unzip && \
    curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -o ngrok.zip && \
    unzip ngrok.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/ngrok && \
    rm -f ngrok.zip

WORKDIR /ngrok

COPY entrypoint.sh /ngrok/entrypoint.sh
COPY ngrok.yml /ngrok/ngrok.yml

RUN chmod +x /ngrok/entrypoint.sh

ENTRYPOINT ["/ngrok/entrypoint.sh"]
