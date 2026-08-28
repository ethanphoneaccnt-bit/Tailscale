FROM tailscale/tailscale:stable

# Force the container to run a basic shell command string on startup
ENTRYPOINT ["/bin/sh", "-c"]

# Start the background daemon first, then wait 2 seconds, then run the up command
CMD ["tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & sleep 2 && tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node"]
