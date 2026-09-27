# Naming/networking constants only — no secrets. Must mirror live/local/env.hcl,
# which every Terragrunt unit reads to point its backend at the same bucket/table.
docker_network_name   = "terra-k8s-local"
docker_network_subnet = "172.28.0.0/16"
ministack_static_ip   = "172.28.0.10"
ministack_port        = 4566
aws_region            = "us-east-1"
tfstate_bucket_name   = "terra-k8s-local-tfstate"
tflock_table_name     = "terra-k8s-local-tflocks"
