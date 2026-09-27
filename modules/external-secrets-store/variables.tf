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

variable "cluster_secret_store_name" {
  type    = string
  default = "aws-secretsmanager"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "use_static_creds" {
  description = "True (local/MiniStack): auth via a Kubernetes Secret. False (dev/EKS, not yet implemented): auth via IRSA (jwt.serviceAccountRef)."
  type        = bool
  default     = true
}

variable "backend_auth_secret_name" {
  description = "Name of the Secret holding static AWS creds, when use_static_creds is true."
  type        = string
  default     = ""
}

variable "backend_auth_secret_namespace" {
  type    = string
  default = "external-secrets"
}

variable "irsa_service_account_name" {
  description = "ServiceAccount name for IRSA-based auth (dev/EKS, not yet implemented)."
  type        = string
  default     = "external-secrets"
}
