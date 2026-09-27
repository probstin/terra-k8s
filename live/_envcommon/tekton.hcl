terraform {
  source = "${get_repo_root()}/modules/tekton"
}

inputs = {
  pipelines_version = "v1.16.0"
  install_dashboard = true
  dashboard_version = "v0.72.0"
}
