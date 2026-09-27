# gitops/apps

Each subdirectory here is one application, deployed by ArgoCD's app-of-apps pattern. The root `Application` (created once by Terraform via `modules/argocd`) watches this directory and treats every `application.yaml` it finds as a child app to sync — recursively, automatically, with pruning and self-heal on.

## Adding a new app

1. Copy `example-app/` to `<your-app>/`.
2. Edit `<your-app>/application.yaml`: change `metadata.name` and `spec.source.path` to point at `<your-app>/manifests`.
3. Put your Kubernetes manifests (or a `kustomization.yaml`) in `<your-app>/manifests/`.
4. If your app needs a secret, add an `ExternalSecret` there too, referencing the `aws-secretsmanager` `ClusterSecretStore` — see [docs/secrets-and-ministack.md](../../docs/secrets-and-ministack.md).
5. Commit and push. ArgoCD picks it up automatically — no `kubectl apply`, no Terraform apply.

See [docs/gitops.md](../../docs/gitops.md) for the full workflow, including how to check sync status and troubleshoot.
