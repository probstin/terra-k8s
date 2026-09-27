variable "cluster_name" {
  description = "Name given to the kind cluster."
  type        = string
}

variable "node_image" {
  description = "Pinned kindest/node image tag (never left to kind's own default, which floats)."
  type        = string
  default     = "kindest/node:v1.34.11"
}

variable "kubeconfig_path" {
  description = "Where kind writes the cluster's kubeconfig. Defaults to ~/.kube/<cluster_name>-kubeconfig."
  type        = string
  default     = null
}
