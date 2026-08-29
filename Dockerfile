FROM tailscale/tailscale:stable

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["echo '<h1>Welcome to Japan</h1>' > index.html && tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & python3 -m http.server 8080 & sleep 2 && tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node"]
