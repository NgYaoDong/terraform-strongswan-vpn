terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # source  = "terraform-provider-docker/docker"
      version = "~> 3.0.1" # version = "3.6.0"
    }
  }
}

provider "docker" {}

# Configure the networks for the docker containers
resource "docker_network" "internet" {
  name = "internet"
  driver = "bridge"
  internal = true # Setting the network to Host-Only

  ipam_config {
    subnet = "192.168.138.0/24" # Configure subnet of the network
  }
}

resource "docker_network" "intranet" {
  name = "intranet"
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

# Configure the client container
resource "docker_container" "client" {
  name  = "client"
  image = docker_image.strongswan.image_id
  privileged = true # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run
  volumes {
    # TODO: to be edited to the correct path of the certs and swanctl.conf in the local machine
    host_path = "/home/ubdesk/Desktop/strongswan-certs/client" # Path of client certs and swanctl.conf in the local machine
    container_path = "/etc/swanctl" # Path of certs and config file for the container
  }
  networks_advanced {
    name = docker_network.internet.name
    ipv4_address = "192.168.138.128" # Setting Internet static IP address for the container
  }
  command = ["tail", "-f", "/dev/null"]
}

# Configure the gateway container
resource "docker_container" "gateway" {
  name  = "gateway"
  image = docker_image.strongswan.image_id
  privileged = true # Required for us to run "ipsec start" then use swanctl, equivalent to --privileged in docker run
  volumes {
    # TODO: to be edited to the correct path of the certs and swanctl.conf in the local machine
    host_path = "/home/ubdesk/Desktop/strongswan-certs/gateway" # Path of gateway certs and swanctl.conf in the local machine
    container_path = "/etc/swanctl" # Path of certs and config file for the container
  }
  networks_advanced {
    name = docker_network.internet.name
    ipv4_address = "192.168.138.129" # Setting Internet static IP address for the container
  }
  networks_advanced {
    name = docker_network.intranet.name
    ipv4_address = "192.168.162.134" # Setting Intranet static IP address for the container
  }
  command = ["tail", "-f", "/dev/null"]
}