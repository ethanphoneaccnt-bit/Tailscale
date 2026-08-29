FROM alpine:3.20

RUN apk add --no-cache tailscale ca-certificates

RUN cat <<'EOF' > /start.sh
#!/bin/sh

PORT="${PORT:-8080}"

( while true; do
    { printf 'HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK'; } | nc -l -p "$PORT"
    sleep 0.2
  done ) &

mkdir -p /var/lib/tailscale

tailscaled --state=/var/lib/tailscale/tailscaled.state \
  --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --outbound-http-proxy-listen=localhost:1055 &

sleep 3

if [ -z "$TS_AUTHKEY" ]; then
  echo "WARNING: TS_AUTHKEY is not set — tailscale will not connect"
else
  tailscale up --authkey="${TS_AUTHKEY}" --hostname="${TS_HOSTNAME:-render-node}" --accept-dns=false
  if [ $? -ne 0 ]; then
    echo "WARNING: tailscale up failed — check that TS_AUTHKEY is valid, reusable, and not expired"
  else
    echo "Tailscale connected successfully"
  fi
fi

wait
EOF

RUN chmod +x /start.sh

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
