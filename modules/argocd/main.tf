resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.this.metadata[0].name

  values = [
    yamlencode({
      configs = var.server_insecure ? {
        params = {
          "server.insecure" = true
        }
      } : {}
    })
  ]
}

# App-of-apps: this is the only Application Terraform ever creates. Every
# other app is added by committing a new child Application manifest under
# gitops/apps — a pure git change, no Terraform apply, no kubectl apply.
resource "kubectl_manifest" "root_application" {
  yaml_body = templatefile(var.bootstrap_manifest_path, {
    root_application_name = var.root_application_name
    namespace              = kubernetes_namespace_v1.this.metadata[0].name
    repo_url               = var.repo_url
    target_revision        = var.target_revision
    apps_path              = var.apps_path
  })

  # On destroy, block until ArgoCD's resources-finalizer has cascaded through
  # every child app, so the ArgoCD controller isn't uninstalled mid-prune.
  wait = true

  depends_on = [helm_release.argocd]
}
