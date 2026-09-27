terraform {
  required_version = ">= 1.13"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    # No official Tekton Helm chart exists, so Pipelines/Dashboard are
    # installed from their pinned official release manifests instead —
    # kubectl_manifest applies raw YAML, matching how Tekton's release.yaml
    # is documented to be installed (a single `kubectl apply -f`).
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.4"
    }
  }
}
