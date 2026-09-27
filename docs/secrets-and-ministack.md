# Secrets & MiniStack

## The two layers

- **`ClusterSecretStore`** (cluster-wide, Terraform-owned): tells External Secrets Operator (ESO) where to fetch secrets from and how to authenticate. Created once by `modules/external-secrets-store`. This is *tooling* — it's the boundary between "what Terraform manages" and "what GitOps manages."
- **`ExternalSecret`** (per-app, GitOps-owned): a namespaced custom resource that a specific app's manifests declare, referencing the `ClusterSecretStore` by name and a specific remote key. These live in `gitops/apps/<app>/manifests/`, never in Terraform — they're workload configuration, exactly like the app's Deployment.

## Local environment: the full chain

1. `live/local/_bootstrap` starts **MiniStack** — a standalone Docker container (not a Kubernetes Deployment; see [architecture.md](architecture.md) for why) emulating AWS Secrets Manager (and S3/DynamoDB, for Terraform's own state).
2. `modules/ministack-seed` (`live/local/ministack-seed`) puts an example secret into MiniStack's Secrets Manager emulation, using an **aliased** `aws` provider pointed at MiniStack with dummy static credentials (`test`/`test`) — the standard "LocalStack-style" Terraform pattern (`skip_credentials_validation`, `skip_metadata_api_check`, `skip_requesting_account_id` all `true`).
3. `modules/external-secrets` installs ESO via Helm, with the controller's AWS SDK calls redirected to MiniStack via the `AWS_ENDPOINT_URL_SECRETS_MANAGER` environment variable. **Note the underscore**: the AWS SDK derives this env var from the service's internal `ServiceID`, which for Secrets Manager is literally `"Secrets Manager"` (with a space) — uppercased and space-replaced-with-underscore, not simply the API name concatenated. Getting this wrong silently sends requests to real AWS instead of MiniStack, which fails in a way that looks like a credentials problem (`UnrecognizedClientException: The security token included in the request is invalid`) rather than an obviously-wrong-endpoint problem — worth knowing if this ever needs to be re-derived for another AWS service.
4. The same module creates a Kubernetes `Secret` holding the dummy static credentials, referenced by the `ClusterSecretStore`'s `auth.secretRef` (created separately by `modules/external-secrets-store` — see [architecture.md](architecture.md) for why that's a second Terraform apply).
5. A per-app `ExternalSecret` (e.g. `gitops/apps/example-app/manifests/externalsecret.yaml`) references `secretStoreRef: { name: aws-secretsmanager, kind: ClusterSecretStore }` and a `remoteRef.key` matching what was seeded in step 2.
6. ESO's controller resolves that `ExternalSecret`, fetches the value from MiniStack, and materializes a real Kubernetes `Secret` in the app's namespace — which the app's Deployment consumes exactly as it would a secret backed by real AWS.

## Adding a new secret

1. Add an entry to `ministack-seed`'s `example_secrets` input (`live/local/ministack-seed/terragrunt.hcl` or the module default) and re-apply that unit.
2. In your app's manifests, add an `ExternalSecret` referencing the new key — see `gitops/apps/example-app/manifests/externalsecret.yaml` for the shape.
3. Commit and push; ArgoCD syncs the `ExternalSecret`, ESO does the rest.

## Dev / EKS (not yet implemented)

The plan for `dev` is for `modules/external-secrets-store` to point `ClusterSecretStore.auth` at `jwt.serviceAccountRef` instead of `secretRef`, using IRSA: an `aws_iam_openid_connect_provider` for the EKS cluster's OIDC issuer, an IAM role trusted by that OIDC provider and scoped to the `external-secrets` ServiceAccount (via the standard `eks.amazonaws.com/role-arn` annotation), and a real `aws_secretsmanager_secret` in place of MiniStack's emulation. `modules/external-secrets-store` already has an `irsa_service_account_name` variable declared for this, and a `lifecycle.precondition` that fails clearly if `use_static_creds = false` is set today — a reminder that this path isn't wired up yet, not a working alternative.
