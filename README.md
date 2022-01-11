# Certbot

## To create/renew

1. Stop the cluster:

```
$ cd $HOME
$ docker-compose down
```

2. Change to the `certbot` directory:

```
$ cd certbot
```

3. Dry run (the default):

```
$ ./create_cert.sh \
    -d benjamintoll.com \
    -d www.benjamintoll.com \
    -d italy.benjamintoll.com \
    -d theowlsnest.farm \
    -d www.theowlsnest.farm \
    -e btoll@example.com
-------------------------------
DOMAINS: benjamintoll.com www.benjamintoll.com italy.benjamintoll.com theowlsnest.farm www.theowlsnest.farm
EMAIL:   btoll@example.com
DRYRUN:  true
-------------------------------
Creating network "certbot_default" with the default driver
Creating letsencrypt-nginx ... done
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Account registered.
Requesting a certificate for benjamintoll.com and 4 more domains

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/benjamintoll.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/benjamintoll.com/privkey.pem
This certificate expires on 2022-04-11.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: benjamintoll.com
    Serial Number: fa75405f69685b5bb590d756202cecb6866e
    Key Type: RSA
    Domains: benjamintoll.com italy.benjamintoll.com theowlsnest.farm www.benjamintoll.com www.theowlsnest.farm
    Expiry Date: 2022-04-11 00:23:15+00:00 (INVALID: TEST_CERT)
    Certificate Path: /etc/letsencrypt/live/benjamintoll.com/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/benjamintoll.com/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

4. For real (add the `-p` flag):

```
$ ./create_cert.sh \
    -d benjamintoll.com \
    -d www.benjamintoll.com \
    -d italy.benjamintoll.com \
    -d theowlsnest.farm \
    -d www.theowlsnest.farm \
    -e btoll@example.com -p
```

5. Re-start the cluster:

```
$ cd -
$ docker-compose up -d
```

---

To get information on your certificate:

```
$ cat letsencrypt/etc/letsencrypt/renewal/benjamintoll.com.conf
```

The `create_cert.sh` shell script will create the following directory structur:

<pre class="math">
letsencrypt/
├── etc
└── var
    ├── lib
    └── log
</pre>

After the first container runs, the locally mounted volumes that were just created will have been filled with goodies from the [`certbot`] tool, including the certs.  The directory structure should then look very similar to this:

<pre class="math">
letsencrypt/
├── etc
│   └── letsencrypt
│       ├── accounts
│       │   └── acme-v02.api.letsencrypt.org
│       ├── archive
│       │   └── benjamintoll.com
│       ├── csr
│       ├── keys
│       ├── live
│       │   └── benjamintoll.com
│       ├── renewal
│       └── renewal-hooks
│           ├── deploy
│           ├── post
│           └── pre
└── var
    ├── lib
    │   └── letsencrypt
    └── log
        └── letsencrypt
</pre>

## References

- [Certbot Documentation](https://certbot.eff.org/docs/)
- [`certbot` Docker image](https://hub.docker.com/r/certbot/certbot/)

[`certbot`]: https://certbot.eff.org/

