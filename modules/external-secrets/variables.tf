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
  default = "external-secrets"
}

variable "chart_version" {
  description = "Pinned external-secrets Helm chart version."
  type        = string
  default     = "2.11.0"
}

variable "aws_endpoint_override" {
  description = "Custom AWS Secrets Manager endpoint injected into the controller as AWS_ENDPOINT_URL_SECRETSMANAGER (e.g. MiniStack's in-cluster address). Empty string means real AWS."
  type        = string
  default     = ""
}

variable "use_static_creds" {
  description = "Create a Kubernetes Secret with static AWS creds for the ClusterSecretStore to reference (local/MiniStack). False means auth is IRSA-based (dev/EKS, not yet implemented)."
  type        = bool
  default     = true
}

variable "static_access_key" {
  type      = string
  default   = "test"
  sensitive = true
}

variable "static_secret_key" {
  type      = string
  default   = "test"
  sensitive = true
}
