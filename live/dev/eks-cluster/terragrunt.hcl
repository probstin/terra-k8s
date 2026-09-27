# STUB — do not apply. modules/eks-cluster creates no real infrastructure
# yet; applying this unit fails immediately and intentionally. See
# docs/architecture.md.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}/modules/eks-cluster"
}

inputs = {
  cluster_name = local.env.locals.cluster_name
}
