# TODO's

- terraform to build and run a local kind cluster
- use providers where applicable
- modularize terraform code
- use terragrunt
- include instructions on how to install terraform/terragrunt
- come up with an approach for managing k8s resources (secrets, config maps, deploying helm charts, etc.)
- keep security at the forefront of your decisions
- ideally would have the terragrunt be able to deploy a local (kind) and dev (EKS) environment - I say this to remind you about keeping components modular and reusable
- store the terraform and terragrunt in this project (for now)
- for the workload deployments, I'll use ArgoCD & GitOps. Deploy Argo and then write a doc on how to set up deployments.
- For the tooling, use the K8S and Helm providers
- Install Tekton for CI/CD
- Install headlamp
- ask questions for clarification