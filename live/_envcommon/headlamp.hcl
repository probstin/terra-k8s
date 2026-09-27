terraform {
  source = "${get_repo_root()}/modules/headlamp"
}

inputs = {
  chart_version = "0.45.0"
  namespace     = "headlamp"
}
