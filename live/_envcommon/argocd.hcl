terraform {
  source = "${get_repo_root()}/modules/argocd"
}

inputs = {
  chart_version           = "10.9.2"
  namespace               = "argocd"
  bootstrap_manifest_path = "${get_repo_root()}/gitops/bootstrap/root-app.yaml.tftpl"
  target_revision         = "main"
  apps_path               = "gitops/apps"
  root_application_name   = "root"
}
