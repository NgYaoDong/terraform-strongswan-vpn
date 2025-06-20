# terraform-strongswan-vpn

This repository provides a fully automated environment for building, testing, and deploying a StrongSwan-based VPN network using Docker containers and Terraform. It is designed for rapid prototyping, testing, and demonstration of VPN topologies with multiple clients and gateways, including automated certificate generation and network setup.

## Features

- **Automated Infrastructure**: Uses Terraform to provision Docker networks and containers for VPN gateways and clients.
- **Certificate Management**: Bash scripts automate the creation of a root CA, client, and gateway certificates using strongSwan's PKI tools.
- **Customisable Topology**: Easily configure the number of clients and gateways.
- **Containerised Environment**: Includes Dockerfiles for both Alpine and Ubuntu-based StrongSwan images.
- **Clean Up Utilities**: Scripts to clean up all generated directories and certificates.

## Repository Structure

- [`main.tf`](./main.tf) — Terraform configuration for Docker networks and containers.
- [`start.sh`](./start.sh) — Main entrypoint script to build, initialise, and manage the VPN network.
- [`scripts/`](./scripts/) — Contains all automation scripts:
  - [`gendir.sh`](./scripts/gendir.sh) — Creates directory structure for clients and gateways.
  - [`genca.sh`](./scripts/genca.sh) — Generates the root CA key and certificate.
  - [`gencerts.sh`](./scripts/gencerts.sh) — Generates client and gateway keys, CSRs, and certificates.
  - [`cleandir.sh`](./scripts/cleandir.sh) — Cleans up all generated directories and certificates.
- [`dockerfiles/`](./dockerfiles/) — Dockerfiles and entrypoint scripts for building StrongSwan images.
- [`tarball/`](./tarball/) — Prebuilt Docker images and related tarballs.

## Usage

1. **Start the Environment**

   Run the following command to launch the interactive setup:

   ```bash
   bash start.sh
   ```

   - You will be prompted for the number of clients and gateways.
   - The script will generate all necessary directories, certificates, and bring up the Dockerised VPN network using Terraform.

2. **Tear Down the Environment**

   Use the menu in [`start.sh`](./start.sh) to tear down the network and clean up resources.

3. **Clean Up Manually**

   To remove all generated directories and certificates:

   ```bash
   bash scripts/cleandir.sh
   ```

## Customisation

- Edit [`main.tf`](./main.tf) to change network settings or container parameters.
- Modify the scripts in [`scripts/`](./scripts/) to adjust certificate parameters or directory structure.
- Use your own Docker images by editing the Dockerfiles in [`dockerfiles/`](./dockerfiles/).

## Requirements

- Docker
- Terraform
- Bash shell with strongSwan PKI installed (Linux or WSL recommended)
