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
  default = "argocd"
}

variable "chart_version" {
  type    = string
  default = "10.9.2"
}

variable "server_insecure" {
  description = "Run the ArgoCD server without TLS. Fine behind kubectl port-forward locally; dev/EKS should use real TLS via ingress + ACM instead."
  type        = bool
  default     = true
}

variable "bootstrap_manifest_path" {
  description = "Absolute path to the app-of-apps root Application template. This module is copied into a Terragrunt cache directory at apply time, so it can't reliably reference the live repo's gitops/ folder with a path relative to itself — the caller passes an absolute path built from get_repo_root()."
  type        = string
}

variable "repo_url" {
  description = "Git repository ArgoCD syncs gitops/apps from. Must be reachable over the network from inside the cluster (a local, unpushed repo is not)."
  type        = string
}

variable "target_revision" {
  type    = string
  default = "main"
}

variable "apps_path" {
  type    = string
  default = "gitops/apps"
}

variable "root_application_name" {
  type    = string
  default = "root"
}
