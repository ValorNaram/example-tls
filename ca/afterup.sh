#!/bin/bash

base=$(basename .)
if [ "$base" = "ca" ]; then
	cd ../
fi

servicename=$(docker container ls --filter "NAME=ca." --quiet)

echo -e "\033[1;37metrieving fingerprint and saving it to an env file for use by other containers ...\033[0;m"
echo CA_FINGERPRINT=$(docker exec $servicename step certificate fingerprint /home/step/certs/root_ca.crt) >./ca/ca_fingerprint.env

echo -e "\033[1;37mcreating ACME provisioner to enable ACME ...\033[0;m"
docker exec $servicename step ca provisioner add "default-acme" --type ACME --allow-renewal-after-expiry

echo -e "\033[1;37mreloading ca server ...\033[0;m"
docker exec $servicename kill -1 1

echo -e "\033[1;37msecuring files via facl permissions ...\033[0;m"
chmod o-rwx ./ca/ca_fingerprint.env
if [ -f "./ca/passwd" ]; then
	chmod o-rwx ./ca/passwd
fi
