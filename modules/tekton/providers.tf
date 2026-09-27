provider "kubectl" {
  host                   = var.cluster_host
  cluster_ca_certificate = var.cluster_ca_certificate
  client_certificate     = var.cluster_client_certificate
  client_key             = var.cluster_client_key
  load_config_file       = false
}
