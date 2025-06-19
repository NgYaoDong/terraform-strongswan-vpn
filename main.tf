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

# Variable to define the number of clients and their names
# This can be adjusted to create more or fewer clients as needed
variable "client_names" {
  description = "List of client container names to create."
  type        = list(string)
  default     = [for i in range(1, 101) : "client${i}"] # Creates client1 to client100
}

# Configure the client container
resource "docker_container" "client" {
  for_each   = toset(var.client_names)
  name       = each.key
  image      = docker_image.strongswan.image_id
  privileged = true # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run

  volumes {
    # Path of client certs and swanctl.conf in the local machine
    host_path      = "./scripts/clients/${each.key}"
    container_path = "/etc/swanctl" # Path of certs and config file for the container
  }

  networks_advanced {
    name         = docker_network.internet.name
    ipv4_address = "192.168.138.${128 + index(var.client_names, each.key)}" # Setting Internet static IP address for each container
  }
  # command = ["tail", "-f", "/dev/null"]
}

# Variable to define the number of gateways and their names
# This can be adjusted to create more or fewer gateways as needed
variable "gateway_names" {
  description = "List of gateway container names to create."
  type        = list(string)
  default     = [for i in range(1, 3) : "gateway${i}"] # Creates gateway1, gateway2
}

# Configure the gateway containers
resource "docker_container" "gateway" {
  for_each   = toset(var.gateway_names)
  name       = each.key
  image      = docker_image.strongswan.image_id
  privileged = true # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run

  volumes {
    # Path of gateway certs and swanctl.conf in the local machine
    host_path      = "./scripts/gateways/${each.key}"
    container_path = "/etc/swanctl" # Path of certs and config file for the container
  }

  networks_advanced {
    name         = docker_network.internet.name
    ipv4_address = "192.168.138.${129 + index(var.gateway_names, each.key)}" # Setting Internet static IP address for each container
  }
  networks_advanced {
    name         = docker_network.intranet.name
    ipv4_address = "192.168.162.${134 + index(var.gateway_names, each.key)}" # Setting Intranet static IP address for each container
  }
  # command = ["tail", "-f", "/dev/null"]
}
