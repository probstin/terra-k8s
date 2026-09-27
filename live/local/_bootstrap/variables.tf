variable "docker_network_name" {
  type = string
}

variable "docker_network_subnet" {
  type = string
}

variable "ministack_static_ip" {
  type = string
}

variable "ministack_port" {
  type    = number
  default = 4566
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tfstate_bucket_name" {
  type = string
}

variable "tflock_table_name" {
  type = string
}
