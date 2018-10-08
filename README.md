# SOGo

This repository is a docker image for [SOGo](https://sogo.nu/).

## Build and Run

Start the server:
```
docker build . -t sogo
docker run --rm --name sogo sogo
```

Start a shell inside the container:
```
docker exec -it sogo bash
```

## Users
List of users created in this container
### sogo
Created by `sogo` package

## Environment Variable
### SOGO_CONF
The content of this variable will override everything in `/etc/sogo/sogo.conf` if it is not empty.
