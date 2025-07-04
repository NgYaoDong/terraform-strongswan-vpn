# Variable declarations for Docker-based VPN deployment
variable "num_clients" { type = number }  # Number of client containers to create
variable "num_gateways" { type = number } # Number of gateway containers to create
