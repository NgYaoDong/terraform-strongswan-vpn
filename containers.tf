# Docker containers for StrongSwan VPN lab
# Clients and gateways

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
}

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
}
