# Working TLS setup with ease (example-tls)

This repository contains a collection of example implementation of one or more of the following coding advices for server development:

- Build an ACME client into your server application to allow operators build a certificate lifecycle for your application easily
- Auto reload new certificates either by reacting to SIGHUB (reload signal) or by registering a filesystem watcher
- make usage of TLS for all in- and outbound connections possible
- use libraries supporting and defaulting the recommended security standards (this makes it easier for you to catch up with latest TLS security trends)

## Usage

1. First start the CA

From inside the git project directory

```bash
docker-compose -f "ca/docker-compose.yml" up --detach
./ca/afterup.sh
```

2. And then try one of the examples like the lightweight TLS server with external ACME support written in python3

```bash
docker-compose -f "./python/https-server-external-acme/docker-compose.yml" up
```

(without `--detach` so you can see what happens)

Open <https://localhost:7777> on your web browser and ignore the warning. Wait a couple of minutes to see how the certificate changes