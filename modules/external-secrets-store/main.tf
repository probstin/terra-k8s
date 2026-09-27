resource "kubectl_manifest" "cluster_secret_store" {
  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = var.cluster_secret_store_name
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.aws_region
          auth = {
            secretRef = {
              accessKeyIDSecretRef = {
                name      = var.backend_auth_secret_name
                namespace = var.backend_auth_secret_namespace
                key       = "access-key"
              }
              secretAccessKeySecretRef = {
                name      = var.backend_auth_secret_name
                namespace = var.backend_auth_secret_namespace
                key       = "secret-access-key"
              }
            }
          }
        }
      }
    }
  })

  lifecycle {
    precondition {
      condition     = var.use_static_creds
      error_message = "IRSA/jwt-based auth (use_static_creds = false) is not yet implemented for dev/EKS — see docs/secrets-and-ministack.md."
    }
  }
}
