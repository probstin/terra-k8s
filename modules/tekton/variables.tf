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

variable "pipelines_version" {
  description = "Pinned Tekton Pipelines release tag."
  type        = string
  default     = "v1.16.0"
}

variable "install_dashboard" {
  type    = bool
  default = true
}

variable "dashboard_version" {
  description = "Pinned Tekton Dashboard release tag."
  type        = string
  default     = "v0.72.0"
}
