resource "kubernetes_deployment" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "whoami"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "whoami"
      }
    }
    template {
      metadata {
        labels = {
          App = "whoami"
        }
      }
      spec {
        container {
          image = "thenaim/whoami"
          name  = "whoami-container"

          port {
            container_port = 80
          }
        }
      }
    }
  }

}
