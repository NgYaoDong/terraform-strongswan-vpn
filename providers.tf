# Provider and Terraform configuration
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # source  = "terraform-provider-docker/docker"
      version = "~> 3.0.1"           # version = "3.6.0"
    }
  }
}

provider "docker" {}
