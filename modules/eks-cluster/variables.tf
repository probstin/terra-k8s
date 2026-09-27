# Declared for the eventual real implementation, not yet wired to any
# resource — see main.tf.

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.31"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "node_groups" {
  description = "Managed node group definitions, shape TBD when implemented."
  type        = any
  default     = {}
}

variable "enable_irsa" {
  type    = bool
  default = true
}
