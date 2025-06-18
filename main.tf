terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "strongswan" {
  name         = "strongswan"
  keep_locally = true
}

resource "docker_container" "strongswan" {
  image = docker_image.strongswan.image_id
  name  = "tutorial"
}

