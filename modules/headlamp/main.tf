resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "headlamp" {
  name       = "headlamp"
  repository = "https://kubernetes-sigs.github.io/headlamp/"
  chart      = "headlamp"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.this.metadata[0].name

  values = [
    yamlencode({
      service = {
        type = var.service_type
      }
    })
  ]
}

# Named distinctly from the chart's own "headlamp-admin" ClusterRoleBinding
# (created by the chart itself) to avoid a Helm ownership-metadata conflict.
resource "kubernetes_service_account_v1" "admin" {
  metadata {
    name      = "headlamp-full-access"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "admin" {
  metadata {
    name = "headlamp-full-access"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.admin_cluster_role
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.admin.metadata[0].name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "admin_token" {
  metadata {
    name      = "headlamp-full-access-token"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.admin.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}
