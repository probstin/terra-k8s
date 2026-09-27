terraform {
  source = "${get_repo_root()}/modules/external-secrets-store"
}

inputs = {
  cluster_secret_store_name = "aws-secretsmanager"
}
