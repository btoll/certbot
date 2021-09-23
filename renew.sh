#!/bin/bash
#shellcheck disable=2086

set -e

    #-v "$(pwd)/letsencrypt/data/letsencrypt:/data/letsencrypt" \
    #-v "$(pwd)/letsencrypt/var/log/letsencrypt:/var/log/letsencrypt" \

docker run --rm -it \
    --name letsencrypt-certbot \
    -v "$(pwd)/letsencrypt/etc/letsencrypt:/etc/letsencrypt" \
    -v "$(pwd)/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot
    renew --webroot \
    --webroot-path=/data/letsencrypt
#--webroot-path=/data/letsencrypt --quiet

#docker kill --signal=HUP production-nginx-container

