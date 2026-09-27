resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.this.metadata[0].name

  values = [
    yamlencode({
      installCRDs = true
      # The env var name is derived from the AWS SDK's ServiceID for
      # Secrets Manager, which is literally "Secrets Manager" (with a
      # space) -> uppercased with the space replaced by an underscore.
      extraEnv = var.aws_endpoint_override != "" ? [
        {
          name  = "AWS_ENDPOINT_URL_SECRETS_MANAGER"
          value = var.aws_endpoint_override
        }
      ] : []
    })
  ]
}

# Referenced by the ClusterSecretStore created in modules/external-secrets-store,
# which must be a separate Terraform apply — a kubernetes_manifest resource for
# a CRD-typed object can't be planned in the same apply that installs the CRD.
resource "kubernetes_secret_v1" "backend_auth" {
  count = var.use_static_creds ? 1 : 0

  metadata {
    name      = "aws-secretsmanager-creds"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  data = {
    access-key        = var.static_access_key
    secret-access-key = var.static_secret_key
  }
}
