FROM alpine:3.20

RUN apk add --no-cache tailscale ca-certificates

RUN cat <<'EOF' > /start.sh
#!/bin/sh
set -e

mkdir -p /var/lib/tailscale

tailscaled --state=/var/lib/tailscale/tailscaled.state \
  --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --outbound-http-proxy-listen=localhost:1055 &

until tailscale status >/dev/null 2>&1; do
  sleep 0.5
done

tailscale up --authkey="${TS_AUTHKEY}" --hostname="${TS_HOSTNAME:-render-node}" --accept-dns=false

PORT="${PORT:-8080}"
while true; do
  { printf 'HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK'; } | nc -l -p "$PORT" -q 1
done
EOF

RUN chmod +x /start.sh

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
