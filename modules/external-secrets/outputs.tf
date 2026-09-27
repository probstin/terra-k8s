output "namespace" {
  value = kubernetes_namespace_v1.this.metadata[0].name
}

output "backend_auth_secret_name" {
  value = var.use_static_creds ? kubernetes_secret_v1.backend_auth[0].metadata[0].name : null
}
