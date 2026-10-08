include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_repo_root()}/live/_envcommon/argocd.hcl"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Not an output dependency — purely ordering. Apps that ArgoCD deploys use
# ExternalSecrets, so on destroy ArgoCD (and the app resources it prunes)
# must go before ESO; otherwise the ExternalSecrets are left holding ESO's
# cleanup finalizer with no controller to clear it, and ESO's CRD deletion
# hangs.
dependencies {
  paths = ["../external-secrets-store"]
}

dependency "cluster" {
  config_path = "../kind-cluster"

  mock_outputs = {
    host                   = "https://mock"
    cluster_ca_certificate = ""
    client_certificate     = ""
    client_key             = ""
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

inputs = {
  cluster_host               = dependency.cluster.outputs.host
  cluster_ca_certificate     = dependency.cluster.outputs.cluster_ca_certificate
  cluster_client_certificate = dependency.cluster.outputs.client_certificate
  cluster_client_key         = dependency.cluster.outputs.client_key

  repo_url = local.env.locals.gitops_repo_url
}
