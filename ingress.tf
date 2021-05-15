resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class" = "public"
    }
  }
  spec {

    backend {
      service_name = kubernetes_service.whoami.metadata.0.name
      service_port = 80
    }

    rule {
      http {

        path {
          path = "/"
          backend {
            service_name = kubernetes_service.whoami.metadata.0.name
            service_port = 80
          }
        }

        path {
          path = "/dog"
          backend {
            service_name = kubernetes_service.httpinfo.metadata.0.name
            service_port = 80
          }
        }

      }
    }

    rule {
      host = "microk8s.test"
      http {

        path {
          path = "/cat"
          backend {
            service_name = kubernetes_service.httpinfo.metadata.0.name
            service_port = 80
          }
        }

      }
    }

  }
}