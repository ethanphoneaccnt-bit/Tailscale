FROM tailscale/tailscale:stable

# This forces the app to bypass Kubernetes checks entirely
ENTRYPOINT ["tailscaled", "--state=/var/lib/tailscale/tailscaled.state", "--socket=/var/run/tailscale/tailscaled.sock"]
CMD ["tailscale", "up", "--advertise-exit-node"]
