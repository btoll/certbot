#!/bin/bash
#shellcheck disable=2086

set -e

CNAME=()
DOMAIN=
DRYRUN=true
EMAIL=root@localhost

usage() {
    echo "$0 -c CNAME -d DOMAIN -e EMAIL -p"
    exit "$1"
}

while getopts "c:d:e:hp" opt
do
    case "$opt" in
        c)
            CNAME+=("$OPTARG")
            ;;
        d)
            DOMAIN="$OPTARG"
            ;;
        e)
            EMAIL="$OPTARG"
            ;;
        h)
            usage 0
            ;;
        p)
            DRYRUN=false
            ;;
        ?)
            echo "Invalid option: -$OPTARG."
            exit 2
            ;;
        *)
            echo "Invalid flag: -$OPTARG."
            exit 2
            ;;
    esac
done

if sudo lsof -i tcp:80
then
    echo "[ERROR] Another process is already bound to port 80."
    exit 1
fi

if [ -z "$DOMAIN" ]
then
    echo "[ERROR] Missing required parameter DOMAIN"
    usage 2
fi

if $DRYRUN
then
    OPTIONS="--staging --register-unsafely-without-email"
else
    OPTIONS="--email $EMAIL --no-eff-email"
fi

DOMAINS="-d $DOMAIN "
if [ "${#CNAME[*]}" -gt 0 ]
then
    for item in "${CNAME[@]}"
    do
        DOMAINS+="-d $item.$DOMAIN "
    done
fi

echo -------------------------------
echo "DOMAINS: $DOMAINS"
echo "EMAIL:   $EMAIL"
echo "DRYRUN:  $DRYRUN"
echo -------------------------------

mkdir -p letsencrypt/{etc,var/{lib,log}}

docker-compose up -d

docker run --rm -it \
    --name letsencrypt-certbot \
    -v "$(pwd)/www:/data/letsencrypt" \
    -v "$(pwd)/letsencrypt/etc/letsencrypt:/etc/letsencrypt" \
    -v "$(pwd)/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "$(pwd)/letsencrypt/var/log/letsencrypt:/var/log/letsencrypt" \
    certbot/certbot \
    certonly --webroot \
    --agree-tos --webroot-path=/data/letsencrypt \
    $OPTIONS $DOMAINS

docker run --rm -it \
    --name letsencrypt-certbot \
    -v "$(pwd)/www:/data/letsencrypt" \
    -v "$(pwd)/letsencrypt/etc/letsencrypt:/etc/letsencrypt" \
    -v "$(pwd)/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot \
    certificates

docker-compose down

