resource "kubernetes_namespace" "workspace" {
  metadata {
    name = var.namespace_workspace
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace_monitoring
  }
}