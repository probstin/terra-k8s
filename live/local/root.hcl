locals {
  project = "terra-k8s"
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Every unit under live/local/ stores its state in the MiniStack-emulated
# S3 bucket + DynamoDB lock table created once, manually, by _bootstrap
# (see live/local/_bootstrap and docs/architecture.md). _bootstrap itself
# is the one deliberate exception to this and uses local state, since
# nothing can store state in a bucket that doesn't exist yet.
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

    access_key = "test"
    secret_key = "test"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true

    endpoints = {
      s3       = local.env.locals.ministack_endpoint_host
      dynamodb = local.env.locals.ministack_endpoint_host
    }
  }
}

inputs = {
  environment = local.env.locals.environment
}
