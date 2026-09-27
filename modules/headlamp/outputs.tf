output "namespace" {
  value = kubernetes_namespace_v1.this.metadata[0].name
}

output "admin_token_secret_name" {
  value = kubernetes_secret_v1.admin_token.metadata[0].name
}
