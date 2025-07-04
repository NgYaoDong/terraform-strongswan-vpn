# terraform-strongswan-vpn

A modular, automated lab for building, testing, and demonstrating StrongSwan-based VPN topologies using Docker and Terraform. This project enables rapid prototyping of multi-gateway, multi-client VPN networks with automated certificate management and flexible infrastructure-as-code.

## Features

- **Automated Infrastructure**: Provision Docker networks and containers for VPN gateways and clients using modularized Terraform files.
- **Certificate Management**: Bash scripts automate the creation of a root CA, gateway, and client certificates using strongSwan's PKI tools.
- **Customisable Topology**: Easily configure the number of clients and gateways via interactive scripts.
- **Containerised Environment**: Includes Dockerfiles for both Alpine and Ubuntu-based StrongSwan images.
- **Clean Up Utilities**: Scripts to remove all generated directories, certificates, and containers.

## Repository Structure

- [`start.sh`](./start.sh) — Main script to build, initialize, and manage the VPN lab.
- [`networks.tf`](./networks.tf) — Docker network resources (internet, intranet).
- [`image.tf`](./image.tf) — Docker image resource for StrongSwan.
- [`containers.tf`](./containers.tf) — Docker container resources for clients and gateways.
- [`providers.tf`](./providers.tf), [`variables.tf`](./variables.tf), [`locals.tf`](./locals.tf) — Shared Terraform configuration and variables.
- [`scripts/`](./scripts/) — Automation scripts:
  - [`gendir.sh`](./scripts/gendir.sh) — Creates directory structure for clients and gateways.
  - [`genca.sh`](./scripts/genca.sh) — Generates the root CA key and certificate.
  - [`gencerts.sh`](./scripts/gencerts.sh) — Generates client and gateway keys, CSRs, and certificates.
  - [`cleandir.sh`](./scripts/cleandir.sh) — Cleans up all generated directories and certificates.
- [`misc/`](./misc/) —
  - [`conf/`](./misc/conf/) — Example swanctl.conf files for clients and gateways.
  - [`dockerfiles/`](./misc/dockerfiles/) — Dockerfiles and entrypoint scripts for building StrongSwan images.
  - [`ref/`](./misc/ref/) — Reference Terraform configs and documentation.
  - [`tarball/`](./misc/tarball/) — Prebuilt Docker images and related tarballs.

## Usage

1. **Start the Environment**

   ```bash
   bash start.sh
   ```

   - You will be prompted for the number of clients and gateways.
   - The script will generate all necessary directories, certificates, and bring up the Dockerised VPN network using Terraform.

2. **Tear Down the Environment**

   Use the menu in `start.sh` to tear down the network and clean up resources.

3. **Clean Up Manually**

   ```bash
   bash scripts/cleandir.sh
   ```

## Customisation

- Edit `networks.tf`, `image.tf`, or `containers.tf` to change network, image, or container settings.
- Modify the scripts in `scripts/` to adjust certificate parameters or directory structure.
- Use your own Docker images by editing the Dockerfiles in `misc/dockerfiles/`.

## Requirements

- Docker
- Terraform
- Bash shell with strongSwan PKI installed (Linux or WSL recommended)

## Notes

- All Terraform resources are modularized for clarity and maintainability.
- See comments in each `.tf` and script file for further documentation and customization tips.
