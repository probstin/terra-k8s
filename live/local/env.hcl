locals {
  environment  = "local"
  cluster_name = "terra-k8s-local"

  # Shared Docker network that both MiniStack and the kind cluster's nodes join,
  # so pods can reach MiniStack by static IP without relying on Docker's
  # container-name DNS (not visible from pod network namespaces).
  docker_network_name   = "terra-k8s-local"
  docker_network_subnet = "172.28.0.0/16"
  ministack_static_ip   = "172.28.0.10"
  ministack_port        = 4566

  ministack_endpoint_host      = "http://localhost:4566"
  ministack_endpoint_incluster = "http://172.28.0.10:4566"

  # MiniStack-emulated S3 bucket + DynamoDB table backing every local
  # component's Terraform state (created once by live/local/_bootstrap).
  tfstate_bucket_name = "terra-k8s-local-tfstate"
  tflock_table_name   = "terra-k8s-local-tflocks"

  aws_region = "us-east-1"

  gitops_repo_url = "https://github.com/probstin/terra-k8s.git"
}
