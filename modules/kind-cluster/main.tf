# Which Docker network the cluster's nodes join (so they can reach MiniStack
# by static IP) is controlled by the KIND_EXPERIMENTAL_DOCKER_NETWORK env var,
# not a resource argument here — it's injected by the calling Terragrunt unit's
# `extra_arguments` block, the same mechanism the kind CLI itself reads.
resource "kind_cluster" "this" {
  name           = var.cluster_name
  node_image     = var.node_image
  wait_for_ready = true

  kubeconfig_path = coalesce(var.kubeconfig_path, pathexpand("~/.kube/${var.cluster_name}-kubeconfig"))
}
