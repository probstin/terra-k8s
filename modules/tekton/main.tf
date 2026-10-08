data "http" "pipelines_release" {
  url = "https://github.com/tektoncd/pipeline/releases/download/${var.pipelines_version}/release.yaml"
}

data "kubectl_file_documents" "pipelines" {
  content = data.http.pipelines_release.response_body
}

# A single for_each applies every document in parallel, so namespaced
# resources race the Namespace objects they live in ("namespaces ... not
# found"). `kubectl apply -f` avoids this by sending Namespaces/CRDs first;
# split them into their own wave to get the same ordering.
locals {
  prereq_kinds = ["Namespace", "CustomResourceDefinition"]

  pipelines_prereqs = {
    for k, v in data.kubectl_file_documents.pipelines.manifests : k => v
    if contains(local.prereq_kinds, yamldecode(v).kind)
  }
  pipelines_rest = {
    for k, v in data.kubectl_file_documents.pipelines.manifests : k => v
    if !contains(local.prereq_kinds, yamldecode(v).kind)
  }

  dashboard_manifests = var.install_dashboard ? data.kubectl_file_documents.dashboard[0].manifests : {}
  dashboard_prereqs = {
    for k, v in local.dashboard_manifests : k => v
    if contains(local.prereq_kinds, yamldecode(v).kind)
  }
  dashboard_rest = {
    for k, v in local.dashboard_manifests : k => v
    if !contains(local.prereq_kinds, yamldecode(v).kind)
  }
}

resource "kubectl_manifest" "pipelines_prereqs" {
  for_each  = local.pipelines_prereqs
  yaml_body = each.value
}

resource "kubectl_manifest" "pipelines" {
  for_each  = local.pipelines_rest
  yaml_body = each.value

  # Tekton's release bundle is designed to be applied all at once
  # (`kubectl apply -f release.yaml`), with its own controllers converging as
  # dependent ConfigMaps/Deployments land in whatever order the API server
  # processes them — the same crash-loop-then-recover behavior kubectl users
  # see. kubectl_manifest's default wait_for_rollout blocks each Deployment's
  # apply until it's healthy, which serializes the whole for_each behind
  # Deployments that can't succeed until later resources in the same batch
  # exist yet. Disabling it here restores the intended fire-and-forget
  # behavior; pod health is checked afterward instead.
  wait_for_rollout = false
  depends_on       = [kubectl_manifest.pipelines_prereqs]
}

data "http" "dashboard_release" {
  count = var.install_dashboard ? 1 : 0
  url   = "https://github.com/tektoncd/dashboard/releases/download/${var.dashboard_version}/release.yaml"
}

data "kubectl_file_documents" "dashboard" {
  count   = var.install_dashboard ? 1 : 0
  content = data.http.dashboard_release[0].response_body
}

resource "kubectl_manifest" "dashboard_prereqs" {
  for_each  = local.dashboard_prereqs
  yaml_body = each.value

  depends_on = [kubectl_manifest.pipelines]
}

resource "kubectl_manifest" "dashboard" {
  for_each  = local.dashboard_rest
  yaml_body = each.value

  wait_for_rollout = false
  depends_on       = [kubectl_manifest.dashboard_prereqs]
}
