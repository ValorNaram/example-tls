#!/bin/bash
# Example from https://github.com/smallstep/docker-tls/blob/main/mongodb/cert-renewer.sh sightly modified
if [ -f /app/tls-scripts/renew-cert-post-hook.sh ]; then
	step ca renew --daemon --exec "/app/tls-scripts/renew-cert-post-hook.sh" "$TLS_CERT_LOCATION" "$TLS_KEY_LOCATION" &
else
	step ca renew --daemon "$TLS_CERT_LOCATION" "$TLS_KEY_LOCATION" &
fi