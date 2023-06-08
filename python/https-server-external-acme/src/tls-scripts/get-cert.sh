#!/bin/bash
# Example from https://github.com/smallstep/docker-tls/blob/main/mongodb/cert-enroller.sh heavily simplified
echo -e "\033[1;37mrequest server certificate ...\033[0;m"

TLS_DOMAINS=${TLS_DOMAINS//,/ }

if [ "${#TLS_DOMAINS[@]}" = "0" ]; then
	echo "Specify at least one domain">&2
	exit 1
fi

tls_subject=${TLS_DOMAINS[0]}
tls_sans=()

if ! [ "${#TLS_DOMAINS[@]}" = "1" ]; then
	for domain in ${TLS_DOMAINS[@]}; do
		tls_sans=( "${tls_sans[@]}" --san "$domain" )
	done
fi

step ca certificate ${tls_subject} "$TLS_CERT_LOCATION" "$TLS_KEY_LOCATION" --provisioner "default-acme" ${tls_sans[@]}
if [ -f /app/tls-scripts/get-cert-post-hook.sh ]; then
	source /app/tls-scripts/get-cert-post-hook.sh
fi

echo -e "\033[1;37m[DONE]: request server certificate\033[0;m"