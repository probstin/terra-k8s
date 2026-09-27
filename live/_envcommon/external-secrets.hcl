terraform {
  source = "${get_repo_root()}/modules/external-secrets"
}

inputs = {
  chart_version = "2.11.0"
  namespace     = "external-secrets"
}
