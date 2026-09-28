# Accessing the cluster & services

Quick reference for connecting to the local `kind` cluster and reaching every UI/tool it runs. There's no ingress controller in this setup (see [architecture.md](architecture.md)), so every UI is reached via `kubectl port-forward`.

## Connect `kubectl` to the cluster

The kind cluster's kubeconfig lives at `~/.kube/terra-k8s-local-kubeconfig` (written there by `modules/kind-cluster`, not the default `~/.kube/config`).

**Per-shell (simplest):**
```sh
export KUBECONFIG=~/.kube/terra-k8s-local-kubeconfig
kubectl get nodes
```

**Merge into your default kubeconfig** (so it shows up in `kubectl config get-contexts` alongside anything else you use):
```sh
KUBECONFIG=~/.kube/config:~/.kube/terra-k8s-local-kubeconfig kubectl config view --flatten > /tmp/merged-kubeconfig
mv /tmp/merged-kubeconfig ~/.kube/config
kubectl config use-context kind-terra-k8s-local
```

## Quick reference

| Service | URL (after port-forward below) | Credentials |
|---|---|---|
| ArgoCD | `http://localhost:8080` (**not** https — runs with `server.insecure=true`) | `admin` / see below |
| Headlamp | `http://localhost:8081` | token — see below |
| Tekton Dashboard | `http://localhost:9097` | none |
| MiniStack | `http://localhost:4566` (already host-reachable, no port-forward needed) | `test`/`test` (dummy) |

Run each `port-forward` in its own terminal (it blocks), or background it with `&` / `nohup ... &`.

### ArgoCD

```sh
export KUBECONFIG=~/.kube/terra-k8s-local-kubeconfig
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
kubectl port-forward svc/argocd-server -n argocd 8080:80
```
Open `http://localhost:8080`, log in as `admin` with the password printed above.

### Headlamp

```sh
export KUBECONFIG=~/.kube/terra-k8s-local-kubeconfig
kubectl get secret -n headlamp headlamp-full-access-token -o jsonpath='{.data.token}' | base64 -d; echo
kubectl port-forward svc/headlamp -n headlamp 8081:80
```
Open `http://localhost:8081`, paste the token when prompted to log in.

### Tekton Dashboard

```sh
export KUBECONFIG=~/.kube/terra-k8s-local-kubeconfig
kubectl port-forward svc/tekton-dashboard -n tekton-pipelines 9097:9097
```
Open `http://localhost:9097`.

### MiniStack (AWS CLI)

No port-forward needed — it's a standalone Docker container already published to the host at `localhost:4566`.

```sh
AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws --endpoint-url http://localhost:4566 --region us-east-1 s3 ls
AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws --endpoint-url http://localhost:4566 --region us-east-1 secretsmanager list-secrets
```

## Everything at a glance

```sh
export KUBECONFIG=~/.kube/terra-k8s-local-kubeconfig
kubectl get pods -A
kubectl get applications -n argocd
```

## Troubleshooting

- **Port-forward connection refused / "nothing running at that port"**: the `kubectl port-forward` command has to stay running in a terminal (or be started with `nohup ... &`) — it's not a one-time setup step. Check `ps aux | grep port-forward` to see if one is still alive.
- **ArgoCD `https://localhost:8080` doesn't work**: use `http://`, not `https://` — the chart runs `server.insecure=true` locally (plain HTTP, no self-signed cert to accept).
