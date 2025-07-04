# Docker image resource for StrongSwan
# Pulls and keeps the image locally

resource "docker_image" "strongswan" {
  name         = "ngyaodong/strongswan:alpine"
  keep_locally = true
}
