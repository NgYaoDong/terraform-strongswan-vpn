# Docker networks for StrongSwan VPN lab
# intranet and internet networks

resource "docker_network" "internet" {
  name     = "internet"
  driver   = "bridge"
  internal = true

  ipam_config {
    subnet = "192.168.138.0/24" # Configure subnet of the network
  }
}

resource "docker_network" "intranet" {
  name   = "intranet"
  driver = "bridge"

  ipam_config {
    subnet = "192.168.162.0/24" # Configure subnet of the network
  }
}
