# GitOps with ArgoCD

## Overview

Terraform installs ArgoCD (`modules/argocd`) and creates exactly one Application, `root`, implementing the **app-of-apps** pattern: it watches the `gitops/apps/` directory of this repo's GitHub remote and recursively syncs anything it finds there. Every other app is a pure git change — no further Terraform apply, no `kubectl apply`.

This is the boundary the project draws deliberately: cluster *tooling* (ArgoCD itself, ESO, Tekton, Headlamp) is Terraform's job; application *workloads* are ArgoCD/GitOps's job.

## Bootstrap mechanics

`modules/argocd` renders `gitops/bootstrap/root-app.yaml.tftpl` (via `templatefile()`) and applies it with `kubectl_manifest`. The template is a real GitOps artifact — reviewable and diffable like any other file in `gitops/` — not something buried in HCL. It's applied to the `argocd` namespace, pointing at `spec.source.path = gitops/apps` with `directory.recurse = true`, `syncPolicy.automated = { prune: true, selfHeal: true }`.

**This only works once the repo is pushed somewhere ArgoCD (running inside the cluster) can reach over the network** — a local, uncommitted working copy is not visible to it. `repo_url` is set in `live/local/env.hcl` (`gitops_repo_url`) and currently holds a placeholder; update it once this repo has a real GitHub remote, then re-apply `live/local/argocd`. Each child Application under `gitops/apps/*/application.yaml` also repeats the repo URL and needs the same update.

### Accessing the ArgoCD UI

```sh
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open `https://localhost:8080` (self-signed cert warning expected — the chart runs `server.insecure = true`, i.e. plain HTTP behind TLS-terminating proxies in real deployments; locally there's no such proxy, so the browser still needs to accept the port-forwarded connection).

## The `gitops/apps` folder convention

Each subdirectory is one app:

```
gitops/apps/<app-name>/
├── application.yaml       # the child Application CR ArgoCD discovers
└── manifests/              # whatever application.yaml's source.path points at
    ├── kustomization.yaml
    ├── deployment.yaml
    ├── service.yaml
    └── externalsecret.yaml # if the app needs a secret — see docs/secrets-and-ministack.md
```

See `gitops/apps/example-app/` for a working reference, and `gitops/apps/README.md` for the step-by-step for adding a new one.

## Sync policy & troubleshooting

Every app here uses `syncPolicy.automated.prune=true, selfHeal=true` — ArgoCD both deletes resources removed from git and reverts manual cluster changes automatically. Useful commands:

```sh
kubectl get applications -n argocd
kubectl describe application <name> -n argocd
```

Or use the ArgoCD UI's own sync-status/history view, or Headlamp for a general cluster view alongside it.
