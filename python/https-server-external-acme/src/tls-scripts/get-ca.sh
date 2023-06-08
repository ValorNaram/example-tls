#!/bin/bash
# uses environment variables to download CA certificate/root certificate

echo -e "\033[1;37mdownload & install CA ...\033[0;m"
## Variable              Description
## ------------------------------------
## CA_URL                HTTP URL to the authority to obtain the CA (root) from
## CA_FINGERPRINT        Fingerprint of the authority
step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT --install;
mkdir -p $(dirname ${TLS_CERT_LOCATION}) $(dirname ${TLS_KEY_LOCATION}) $(dirname ${TLS_CA_CERT_LOCATION}) --verbose
cp ${STEPPATH}/certs/root_ca.crt ${TLS_CA_CERT_LOCATION}
echo -e "\033[1;37m[DONE]: download & install CA\033[0;m"