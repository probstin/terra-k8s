# STUB environment root. Do not `terragrunt apply` anything under live/dev
# until modules/eks-cluster is a real implementation and the placeholder
# values in env.hcl are replaced — see docs/architecture.md.

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = local.env.locals.tfstate_bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.env.locals.aws_region
    dynamodb_table = local.env.locals.tflock_table_name
    encrypt        = true
  }
}

inputs = {
  environment = local.env.locals.environment
}
