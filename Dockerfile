FROM tailscale/tailscale:stable

# Force the container to run a basic shell command string on startup
ENTRYPOINT ["/bin/sh", "-c"]

# Start the daemon in userspace mode, pause, then advertise as an exit node
CMD ["tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & sleep 2 && tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node"]
