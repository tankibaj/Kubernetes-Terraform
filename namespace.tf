resource "kubernetes_namespace" "workspace" {
  metadata {
    name = "workspace"
  }
}