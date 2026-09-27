output "namespace" {
  value = kubernetes_namespace_v1.this.metadata[0].name
}

output "root_application_name" {
  value = var.root_application_name
}
