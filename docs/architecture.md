# Architecture

## Component inventory

| Component | How it's installed | Where |
|---|---|---|
| kind cluster | `tehcyx/kind` Terraform provider | `modules/kind-cluster` |
| EKS cluster (dev) | `hashicorp/aws` Terraform provider — **stub, not implemented** | `modules/eks-cluster` |
| MiniStack | `kreuzwerker/docker` provider (standalone container, not in-cluster) | `modules/ministack-host`, applied only by `live/local/_bootstrap` |
| MiniStack secrets seed | `hashicorp/aws` provider (aliased, pointed at MiniStack) | `modules/ministack-seed` |
| External Secrets Operator | Helm (`hashicorp/helm`) | `modules/external-secrets` |
| ClusterSecretStore | `alekc/kubectl` (`kubectl_manifest`) | `modules/external-secrets-store` |
| ArgoCD + root Application | Helm + `kubectl_manifest` | `modules/argocd` |
| Tekton Pipelines + Dashboard | Pinned official release manifests via `alekc/kubectl` | `modules/tekton` |
| Headlamp | Helm | `modules/headlamp` |
| Application workloads | ArgoCD, synced from `gitops/apps/` | not Terraform |

## Why MiniStack is a standalone Docker container, not a Kubernetes Deployment

MiniStack stands in for **every** AWS service the local environment needs — not just Secrets Manager, but Terraform's own state backend (S3 + DynamoDB). That creates an unavoidable ordering constraint: the state bucket has to exist before any Terraform run can use it as a backend, which means MiniStack itself can't be something Terraform creates *inside* the cluster it's also bootstrapping. Instead, `live/local/_bootstrap` — the one part of this project that isn't Terragrunt-orchestrated and uses local state — stands up a dedicated Docker network, the MiniStack container (with a static IP), and the state bucket/lock table, using the `kreuzwerker/docker` and (aliased) `hashicorp/aws` providers. Every other unit's Terragrunt-generated backend then points at that MiniStack-emulated S3+DynamoDB.

The kind cluster joins the same Docker network as MiniStack via `KIND_EXPERIMENTAL_DOCKER_NETWORK` (injected by Terragrunt's `extra_arguments`, see `live/local/kind-cluster/terragrunt.hcl`), so pods inside the cluster (ESO's controller) can reach MiniStack directly at its static IP — this avoids relying on Docker's container-name DNS, which isn't visible from inside pod network namespaces.

## Dependency order (local environment)

```
(manual, one-time) live/local/_bootstrap
  → docker network + MiniStack container + S3 bucket + DynamoDB lock table
        │
        ├── kind-cluster
        │      ├── external-secrets → external-secrets-store
        │      ├── argocd
        │      ├── tekton
        │      └── headlamp
        └── ministack-seed   (independent of the cluster; only needs _bootstrap done)
```

`terragrunt run-all apply` in `live/local` handles the cluster-dependent units' ordering automatically via each unit's `dependency` block. `_bootstrap` is deliberately outside that graph (it has no `terragrunt.hcl`, so `run-all` skips it) and must be applied manually, once, first — see the Bootstrap steps below.

`external-secrets` and `external-secrets-store` are two separate Terraform applies rather than one, because a `kubectl_manifest`/`kubernetes_manifest`-style resource for a CRD-typed object needs that CRD to already exist in the cluster — which it can't, if the same apply is also the one installing it via `helm_release`. Terragrunt's `dependency` block guarantees `external-secrets` fully completes before `external-secrets-store` even starts planning.

## Bootstrap steps (local, one time per machine)

```sh
cd live/local/_bootstrap
terraform init
terraform apply
```

Then, from `live/local`:

```sh
terragrunt run-all apply
```

## Module sharing between `local` and `dev`

`modules/kind-cluster` and (once built) `modules/eks-cluster` are designed to expose the identical output shape (`host`, `cluster_ca_certificate`, `client_certificate`, `client_key`). Every other module — `external-secrets`, `external-secrets-store`, `argocd`, `tekton`, `headlamp` — takes those same four values as input variables and configures its own `kubernetes`/`helm`/`kubectl` provider blocks from them. This is what makes them genuinely shared between environments: swapping `local` for `dev` only means a Terragrunt unit's `dependency` block points at `eks-cluster` instead of `kind-cluster` — the shared modules themselves don't change. The `_envcommon/*.hcl` files in `live/_envcommon` DRY up each shared module's source path and default inputs so both environments' leaf units inherit the same configuration.

## Terraform state

Local environment: every component except `_bootstrap` stores state in a MiniStack-emulated S3 bucket (`terra-k8s-local-tfstate`), with locking via a MiniStack-emulated DynamoDB table (`terra-k8s-local-tflocks`) — a deliberate choice (over Terraform's native S3 lockfile feature) to keep locking behavior realistic and consistent with the "MiniStack stands in for every AWS service" principle. `_bootstrap` itself uses local state, since nothing can use a backend that doesn't exist yet.

Dev environment: intended to use a real S3 backend (with the same DynamoDB-table locking pattern) once real AWS access exists — see `live/dev/root.hcl`, currently stubbed with placeholder values. **Local Terraform state can contain sensitive data** (even dummy credentials, and eventually real ones for dev) — this is a security-relevant reason to move dev to a properly access-controlled remote backend before using it for anything real, not just a convenience upgrade.

## Local-only relaxations to revisit before a dev/EKS equivalent

- Headlamp's admin ServiceAccount is bound to `cluster-admin` (`modules/headlamp`'s `admin_cluster_role` default) — fine for a disposable local cluster, too broad for anything real.
- ArgoCD runs with `server.insecure = true` (plain HTTP behind `kubectl port-forward`) — dev should terminate TLS via an ingress + real certificates instead.
- No ingress controller is installed in v1 — all UIs (ArgoCD, Headlamp, Tekton Dashboard) are reached via `kubectl port-forward`.
