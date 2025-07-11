# Local values for client/gateway names and current directory
locals {
  client_names  = [for i in range(1, var.num_clients + 1) : "client${i}"]   # Creates client1, client2, ...
  gateway_names = [for i in range(1, var.num_gateways + 1) : "gateway${i}"] # Creates gateway1, gateway2, ...
  current_dir   = abspath(path.module)                                      # Get the absolute path of the current directory
}
