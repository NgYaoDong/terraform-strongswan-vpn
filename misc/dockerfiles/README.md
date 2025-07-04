# Dockerfiles for StrongSwan VPN

This directory contains Dockerfiles and entrypoint scripts for building custom StrongSwan VPN images used in the automated VPN network environment.

## Contents

- `Dockerfile` — Builds an Alpine-based StrongSwan image (`ngyaodong/strongswan:alpine`).
- `latest.dockerfile` — Builds an Ubuntu 22.04-based StrongSwan image (`ngyaodong/strongswan:latest`).
- `entrypoint.sh` — Entrypoint script used by both images to initialise and manage the StrongSwan service inside the container.

## Image Details

### Alpine-based Image (`Dockerfile`)

- Uses `alpine:latest` as the base image.
- Installs StrongSwan, TPM2 tools, and networking utilities.
- Exposes UDP ports 500 and 4500 for IPsec VPN traffic.
- Uses `entrypoint.sh` to start the StrongSwan service and manage client/gateway roles.

### Ubuntu-based Image (`latest.dockerfile`)

- Uses `ubuntu:22.04` as the base image.
- Installs StrongSwan and related plugins.
- Exposes UDP ports 500 and 4500 for IPsec VPN traffic.
- Uses `entrypoint.sh` for container startup logic.

## Entrypoint Script

The `entrypoint.sh` script:

- Starts the StrongSwan IPsec daemon (`ipsec start`).
- Loads all VPN configuration using `swanctl --load-all`.
- If the container is running as a client (`ROLE=client`), it initiates the VPN connection.
- Keeps the container running for debugging and management.

## Usage

These Dockerfiles are used by the Terraform and automation scripts in the root of the repository to build and run VPN gateway and client containers. You can build the images manually with:

```bash
docker build -f Dockerfile -t ngyaodong/strongswan:alpine .
docker build -f latest.dockerfile -t ngyaodong/strongswan:latest .
```

## Customisation

- Modify the Dockerfiles to add packages or change the base image as needed.
- Edit `entrypoint.sh` to customise container startup behavior.
