resource "kubernetes_deployment" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "whoami"
    }
  }

  spec {
    replicas = 2
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


resource "kubernetes_deployment" "httpinfo" {
  metadata {
    name      = "httpinfo"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "httpinfo"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "httpinfo"
      }
    }
    template {
      metadata {
        labels = {
          App = "httpinfo"
        }
      }
      spec {
        container {
          image = "thenaim/httpinfo"
          name  = "httpinfo-container"

          port {
            container_port = 80
          }
        }
      }
    }
  }

}