# This module is always applied as the root module of its own Terragrunt
# unit, never nested under another module — so it configures its own
# providers directly from connection details passed in as variables
# (sourced from a `dependency` block on whichever cluster module is in use).
provider "kubernetes" {
  host                   = var.cluster_host
  cluster_ca_certificate = var.cluster_ca_certificate
  client_certificate     = var.cluster_client_certificate
  client_key             = var.cluster_client_key
}

provider "helm" {
  kubernetes = {
    host                   = var.cluster_host
    cluster_ca_certificate = var.cluster_ca_certificate
    client_certificate     = var.cluster_client_certificate
    client_key             = var.cluster_client_key
  }
}
