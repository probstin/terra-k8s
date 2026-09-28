# terra-k8s

Terraform + Terragrunt platform for a local Kubernetes environment (via [kind](https://kind.sigs.k8s.io/)) and a future AWS EKS `dev` environment, sharing modules wherever a component isn't cluster-type-specific.

Cluster **tooling** (ArgoCD, Tekton, Headlamp, External Secrets Operator) is installed via Terraform's `kubernetes`/`helm` providers. Application **workloads** are deployed via ArgoCD/GitOps from [`gitops/apps`](gitops/apps), never directly via Terraform.

The local environment uses [MiniStack](https://ministack.org/) — an open-source AWS emulator — as a stand-in for every AWS service it needs, including Terraform's own state backend (S3 + DynamoDB) and Secrets Manager. This makes the whole local environment a portable, self-contained prototype of the real AWS-backed `dev` environment.

## Docs

- [Prerequisites](docs/prerequisites.md) — what to install before you start.
- [Accessing the cluster & services](docs/access.md) — connect `kubectl`, reach ArgoCD/Headlamp/Tekton Dashboard/MiniStack.
- [Architecture](docs/architecture.md) — components, dependency order, design rationale.
- [Secrets & MiniStack](docs/secrets-and-ministack.md) — how secrets flow from MiniStack through External Secrets Operator.
- [GitOps](docs/gitops.md) — how ArgoCD is bootstrapped and how to add a new app deployment.

## Layout

```
modules/    reusable Terraform modules
live/       Terragrunt environments (local, dev) that compose those modules
gitops/     ArgoCD Application manifests and app source, synced from GitHub
docs/       setup and design documentation
```

## Quick start (local environment)

See [docs/prerequisites.md](docs/prerequisites.md) for required tooling, then [docs/architecture.md](docs/architecture.md) for the full bootstrap → apply sequence. Once it's up, see [docs/access.md](docs/access.md) for how to connect to it and reach every UI.
