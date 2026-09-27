variable "network_name" {
  description = "Name of the Docker network MiniStack and the kind cluster's nodes share."
  type        = string
}

variable "network_subnet" {
  description = "CIDR subnet for the shared Docker network."
  type        = string
}

variable "container_name" {
  description = "Name of the MiniStack container."
  type        = string
  default     = "ministack"
}

variable "static_ip" {
  description = "Static IP assigned to the MiniStack container on the shared network, so pods can reach it without relying on Docker's container-name DNS (not visible from pod network namespaces)."
  type        = string
}

variable "host_port" {
  description = "Host port MiniStack's gateway is published on, for host-side access (Terraform backend, aws-cli)."
  type        = number
  default     = 4566
}

variable "image" {
  description = "MiniStack image, pinned to an exact version tag (never 'latest')."
  type        = string
  default     = "ministackorg/ministack:1.5.17"
}

variable "region" {
  description = "Default region MiniStack advertises. Dummy value used only for API shape, never a real AWS region."
  type        = string
  default     = "us-east-1"
}
