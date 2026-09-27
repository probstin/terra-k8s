variable "cluster_host" {
  type = string
}

variable "cluster_ca_certificate" {
  type      = string
  sensitive = true
}

variable "cluster_client_certificate" {
  type      = string
  sensitive = true
}

variable "cluster_client_key" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type    = string
  default = "headlamp"
}

variable "chart_version" {
  type    = string
  default = "0.45.0"
}

variable "admin_cluster_role" {
  description = "ClusterRole bound to Headlamp's admin ServiceAccount. Defaults to cluster-admin for local convenience — a local-only relaxation that must be narrowed before any dev/EKS equivalent."
  type        = string
  default     = "cluster-admin"
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}
