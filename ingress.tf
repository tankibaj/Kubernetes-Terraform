resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class" = "public"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.whoami.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}