module "ministack" {
  source = "../../../modules/ministack-host"

  network_name   = var.docker_network_name
  network_subnet = var.docker_network_subnet
  static_ip      = var.ministack_static_ip
  host_port      = var.ministack_port
  region         = var.aws_region
}

# Aliased and isolated from any "real" aws provider used elsewhere in this
# project, so a misconfiguration can never accidentally touch real AWS.
provider "aws" {
  alias  = "ministack"
  region = var.aws_region

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3       = module.ministack.endpoint_host
    dynamodb = module.ministack.endpoint_host
  }
}

resource "aws_s3_bucket" "tfstate" {
  provider = aws.ministack
  bucket   = var.tfstate_bucket_name
}

resource "aws_s3_bucket_versioning" "tfstate" {
  provider = aws.ministack
  bucket   = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tflock" {
  provider     = aws.ministack
  name         = var.tflock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
