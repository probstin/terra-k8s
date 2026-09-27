resource "docker_network" "this" {
  name   = var.network_name
  driver = "bridge"

  ipam_config {
    subnet = var.network_subnet
  }
}

resource "docker_image" "ministack" {
  name = var.image
}

resource "docker_container" "ministack" {
  name  = var.container_name
  image = docker_image.ministack.image_id

  ports {
    internal = 4566
    external = var.host_port
  }

  env = [
    "MINISTACK_REGION=${var.region}",
    "MINISTACK_HOST=localhost",
    "DOCKER_NETWORK=${docker_network.this.name}",
  ]

  networks_advanced {
    name         = docker_network.this.name
    ipv4_address = var.static_ip
  }

  restart = "unless-stopped"
}
