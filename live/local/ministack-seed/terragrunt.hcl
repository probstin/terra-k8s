include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}/modules/ministack-seed"
}

inputs = {
  ministack_endpoint = local.env.locals.ministack_endpoint_host
  region             = local.env.locals.aws_region
}
