# STUB — blocked on modules/eks-cluster (see ../eks-cluster/terragrunt.hcl).

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_repo_root()}/live/_envcommon/tekton.hcl"
}

dependency "cluster" {
  config_path = "../eks-cluster"

  mock_outputs = {
    host                   = "https://mock"
    cluster_ca_certificate = ""
    client_certificate     = ""
    client_key             = ""
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  cluster_host               = dependency.cluster.outputs.host
  cluster_ca_certificate     = dependency.cluster.outputs.cluster_ca_certificate
  cluster_client_certificate = dependency.cluster.outputs.client_certificate
  cluster_client_key         = dependency.cluster.outputs.client_key
}
