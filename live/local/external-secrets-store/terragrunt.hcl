include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_repo_root()}/live/_envcommon/external-secrets-store.hcl"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
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

dependency "eso" {
  config_path = "../external-secrets"

  mock_outputs = {
    namespace                = "external-secrets"
    backend_auth_secret_name = "aws-secretsmanager-creds"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

inputs = {
  cluster_host               = dependency.cluster.outputs.host
  cluster_ca_certificate     = dependency.cluster.outputs.cluster_ca_certificate
  cluster_client_certificate = dependency.cluster.outputs.client_certificate
  cluster_client_key         = dependency.cluster.outputs.client_key

  use_static_creds              = true
  backend_auth_secret_name      = dependency.eso.outputs.backend_auth_secret_name
  backend_auth_secret_namespace = dependency.eso.outputs.namespace
  aws_region                    = local.env.locals.aws_region
}
