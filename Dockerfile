FROM tailscale/tailscale:stable

# Expose the required port clearly to Render's network
EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c"]

# Instantly boot the webpage on port 8080, then start Tailscale alongside it
CMD ["echo '<h1>Welcome to Japan</h1>' > index.html && python3 -m http.server 8080 & tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & sleep 2 && tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node"]
