data "template_file" "grafana_values" {
  template = file("./templates/grafana-values.yml")

  vars = {
    GRAFANA_SERVICE_ACCOUNT = "grafana"
    GRAFANA_ADMIN_USER      = "admin"
    GRAFANA_ADMIN_PASSWORD  = var.grafana_password
    PROMETHEUS_SVC          = "${helm_release.prometheus.name}-server"
    NAMESPACE               = var.namespace_monitoring
  }
}