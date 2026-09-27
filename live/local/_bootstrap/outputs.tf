output "ministack_endpoint_host" {
  value = module.ministack.endpoint_host
}

output "ministack_endpoint_incluster" {
  value = module.ministack.endpoint_incluster
}

output "docker_network_name" {
  value = module.ministack.network_name
}

output "tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

output "tflock_table_name" {
  value = aws_dynamodb_table.tflock.name
}
