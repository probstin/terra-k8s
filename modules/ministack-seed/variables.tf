variable "ministack_endpoint" {
  description = "MiniStack endpoint this module's aws provider talks to (host-reachable, since this module runs on the operator's machine, not in-cluster)."
  type        = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "example_secrets" {
  description = "Map of secret name -> plaintext value to seed into MiniStack's Secrets Manager emulation, for ESO to later sync into a real Kubernetes Secret."
  type        = map(string)
  default = {
    "demo/example-app/api-key" = "changeme-local-dev-value"
  }
}
