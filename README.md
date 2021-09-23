# Certbot

## To create/renew

1. Stop the cluster:

```
cd $HOME
docker-compose down
```

1. Change to the `certbot` directory:

```
cd certbot
```

1. Dry run (the default):

```
./create_cert.sh -c www -c italy -d benjamintoll.com -e benjam72@yahoo.com
```

1. For real:

```
./create_cert.sh -c www -c italy -d benjamintoll.com -e benjam72@yahoo.com -p
```

1. Re-start the cluster:

```
cd -
docker-compose up -d
```

## References

- [Certbot Documentation](https://certbot.eff.org/docs/)

