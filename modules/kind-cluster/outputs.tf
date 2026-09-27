# Same output shape (host/cluster_ca_certificate/client_certificate/client_key)
# that modules/eks-cluster will eventually expose, so downstream shared
# components only ever swap which `dependency` they point at.

output "cluster_name" {
  value = kind_cluster.this.name
}

output "host" {
  value = kind_cluster.this.endpoint
}

output "client_certificate" {
  value     = kind_cluster.this.client_certificate
  sensitive = true
}

output "client_key" {
  value     = kind_cluster.this.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = kind_cluster.this.cluster_ca_certificate
  sensitive = true
}

output "kubeconfig_path" {
  value = kind_cluster.this.kubeconfig_path
}
