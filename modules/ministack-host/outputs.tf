output "network_name" {
  description = "Name of the shared Docker network, for the kind cluster to join via KIND_EXPERIMENTAL_DOCKER_NETWORK."
  value       = docker_network.this.name
}

output "container_name" {
  value = docker_container.ministack.name
}

output "container_ip" {
  description = "Static IP of the MiniStack container on the shared network."
  value       = var.static_ip
}

output "endpoint_host" {
  description = "MiniStack endpoint reachable from the host machine (Terraform backend, aws-cli)."
  value       = "http://localhost:${var.host_port}"
}

output "endpoint_incluster" {
  description = "MiniStack endpoint reachable from pods sharing the Docker network."
  value       = "http://${var.static_ip}:4566"
}
