# Aliased and isolated from any "real" aws provider used elsewhere in this
# project, so a misconfiguration can never accidentally touch real AWS.
provider "aws" {
  alias  = "ministack"
  region = var.region

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    secretsmanager = var.ministack_endpoint
  }
}

resource "aws_secretsmanager_secret" "this" {
  for_each = var.example_secrets
  provider = aws.ministack

  name = each.key
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = var.example_secrets
  provider = aws.ministack

  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = each.value
}
