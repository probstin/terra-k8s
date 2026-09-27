locals {
  environment  = "dev"
  cluster_name = "terra-k8s-dev"

  # TODO: all of the below are placeholders — fill in once a real AWS
  # account/region is chosen. Do not `terragrunt apply` in live/dev until
  # modules/eks-cluster is implemented (see docs/architecture.md) and these
  # values are real.
  aws_region          = "us-east-1"
  aws_account_id      = ""
  tfstate_bucket_name = "REPLACE_ME-terra-k8s-dev-tfstate"
  tflock_table_name   = "REPLACE_ME-terra-k8s-dev-tflocks"
  gitops_repo_url     = "https://github.com/REPLACE_ME/terra-k8s.git"
}
