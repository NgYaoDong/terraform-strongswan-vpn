terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # source  = "terraform-provider-docker/docker"
      version = "~> 3.0.1"           # version = "3.6.0"
    }
  }
}

provider "docker" {}

# Configure the networks for the docker containers
# Create a docker network to simulate the internet
resource "docker_network" "internet" {
  name     = "internet"
  driver   = "bridge"
  internal = true # Setting the network to Host-Only

  ipam_config {
    subnet = "192.168.138.0/24" # Configure subnet of the network
  }
}

# Create a docker network to simulate the intranet
resource "docker_network" "intranet" {
  name   = "intranet"
  driver = "bridge"

  ipam_config {
    subnet = "192.168.162.0/24" # Configure subnet of the network
  }
}

# Create docker image resource
# Similar to docker pull "wtv-image"
resource "docker_image" "strongswan" {
  name         = "ngyaodong/strongswan:alpine"
  keep_locally = true
}

# Define variables for the number of clients and gateways
variable "num_clients" {
  type = number
}

variable "num_gateways" {
  type = number
}

# Define local variables for client and gateway names, and the current directory
# The client and gateway names are generated based on the number of clients and gateways specified in the variables.
# The current directory is used to specify the path for the volumes in the docker containers.
locals {
  client_names  = [for i in range(1, var.num_clients + 1) : "client${i}"]   # Creates client1, client2, ...
  gateway_names = [for i in range(1, var.num_gateways + 1) : "gateway${i}"] # Creates gateway1, gateway2, ...
  current_dir   = abspath(path.module)                                      # Get the absolute path of the current directory
}

# Configure the client container
resource "docker_container" "client" {
  for_each   = toset(local.client_names)
  name       = each.key
  image      = docker_image.strongswan.image_id
  privileged = true            # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run
  env        = ["ROLE=client"] # Set environment variable to indicate the role of the container

  volumes {
    host_path      = "${local.current_dir}/clients/${each.key}" # Path of client certs and swanctl.conf in the local machine (MUST BE absolute path)
    container_path = "/etc/swanctl"                             # Path of certs and config file for the container
  }

  networks_advanced {
    name         = docker_network.internet.name
    ipv4_address = "192.168.138.${128 + index(local.client_names, each.key)}" # Setting Internet static IP address for each container
  }
  # command = ["tail", "-f", "/dev/null"]
}

# Configure the gateway containers
resource "docker_container" "gateway" {
  for_each   = toset(local.gateway_names)
  name       = each.key
  image      = docker_image.strongswan.image_id
  privileged = true             # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run
  env        = ["ROLE=gateway"] # Set environment variable to indicate the role of the container

  volumes {
    host_path      = "${local.current_dir}/gateways/${each.key}" # Path of gateway certs and swanctl.conf in the local machine (MUST BE absolute path)
    container_path = "/etc/swanctl"                              # Path of certs and config file for the container
  }

  networks_advanced {
    name         = docker_network.internet.name
    ipv4_address = "192.168.138.${140 + index(local.gateway_names, each.key)}" # Setting Internet static IP address for each container
  }
  networks_advanced {
    name         = docker_network.intranet.name
    ipv4_address = "192.168.162.${134 + index(local.gateway_names, each.key)}" # Setting Intranet static IP address for each container
  }
  # command = ["tail", "-f", "/dev/null"]
}
