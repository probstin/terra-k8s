output "pipelines_version_installed" {
  value = var.pipelines_version
}

output "dashboard_version_installed" {
  value = var.install_dashboard ? var.dashboard_version : null
}
