# Prerequisites

Install these before running anything in this repo. Versions shown are what this project was built and verified against — newer patch/minor versions should be fine, but pin to these if you hit an incompatibility.

| Tool | Purpose | Minimum version |
|---|---|---|
| [Terraform](https://developer.hashicorp.com/terraform/install) | Provisions everything | 1.13.x |
| [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) | Orchestrates Terraform across environments/components | 0.89.x |
| [Docker](https://docs.docker.com/get-docker/) | Runs MiniStack and the `kind` cluster's nodes | 27.x+ (Docker Desktop on macOS) |
| [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) | Inspect/debug the cluster | 1.31.x+ |
| [Helm](https://helm.sh/docs/intro/install/) | Inspect/debug Helm releases installed by Terraform | 3.x |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | Talk to MiniStack (and, later, real AWS for `dev`) with `--endpoint-url` | 2.x |

The `kind` CLI itself is **not required** — the cluster is created by the `tehcyx/kind` Terraform provider, not the CLI. Docker is still required because that provider drives the Docker daemon directly, same as the CLI would.

## macOS install (Homebrew)

```sh
brew install terraform terragrunt docker kubectl helm awscli
```

If you don't already have Docker Desktop, install it separately and make sure it's running before applying anything — `docker info` should succeed.

## Verifying your setup

```sh
terraform version      # >= 1.13
terragrunt --version   # >= 0.89
docker info             # daemon reachable
kubectl version --client
helm version
aws --version
```

## Next step

Once these are installed, see [architecture.md](architecture.md) for the full bootstrap → apply sequence, starting with the one manual step: `live/local/_bootstrap`.
