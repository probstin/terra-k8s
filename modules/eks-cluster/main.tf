# STUB — no real infrastructure is created by this module yet. It exists so
# the live/dev Terragrunt structure and the _envcommon-shared modules
# (external-secrets, argocd, tekton, headlamp) can be wired up against it
# now, ready to swap in a real implementation later without touching those
# shared modules — they only depend on this module's output shape (host,
# cluster_ca_certificate, client_certificate, client_key), matching
# modules/kind-cluster.
#
# TODO when a real AWS account is available, roughly in this order:
#   1. VPC + subnets — likely via terraform-aws-modules/vpc, sized from
#      var.vpc_cidr, with public subnets for a NAT/ALB and private subnets
#      for nodes.
#   2. EKS control plane — likely via terraform-aws-modules/eks, at
#      var.kubernetes_version, with private_subnet_ids/public_subnet_ids
#      wired from step 1 (or var.private_subnet_ids/var.public_subnet_ids if
#      the VPC is provisioned separately).
#   3. aws_iam_openid_connect_provider for the cluster's OIDC issuer, gated
#      on var.enable_irsa — this is what IRSA (used by
#      modules/external-secrets-store's dev path) depends on.
#   4. Managed node group(s) from var.node_groups.
#   5. Real remote_state backend (live/dev/root.hcl already has the shape;
#      just needs real bucket/table/region values in live/dev/env.hcl).
#
# Until then, this precondition fails any apply of this unit clearly and
# immediately, rather than silently doing nothing.
resource "terraform_data" "not_yet_implemented" {
  lifecycle {
    precondition {
      condition     = false
      error_message = "modules/eks-cluster is a scaffold only — see the TODOs in this file and docs/architecture.md before applying live/dev."
    }
  }
}
