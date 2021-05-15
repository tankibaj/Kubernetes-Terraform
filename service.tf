resource "kubernetes_service" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.workspace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.whoami.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80 #container_port
    }

    type = "NodePort"
  }
}