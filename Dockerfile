FROM tailscale/tailscale:stable

# Open the standard universal web port for Render
EXPOSE 80

# Force the container to run a shell command string on startup
ENTRYPOINT ["/bin/sh", "-c"]

# 1. Create the 'Welcome to Japan' webpage
# 2. Launch the Python server on standard port 80 (using root privileges)
# 3. Initialize Tailscale daemon in userspace mode
# 4. Authenticate your account and turn on the VPN exit node flag
CMD ["echo '<h1>Welcome to Japan</h1>' > index.html && python3 -m http.server 80 & tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & sleep 2 && tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node"]
