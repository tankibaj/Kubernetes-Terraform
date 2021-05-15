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

resource "kubernetes_deployment" "pvc_test" {
  metadata {
    name      = "nginx-pvc-test"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "nginx-pvc-test"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "nginx-pvc-test"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx-pvc-test"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-pvc-test-container"

          port {
            container_port = 80
          }
          volume_mount {
            name       = "nginx-volume"
            mount_path = "/usr/share/nginx/html"
          }
        }
        volume {
          name = "nginx-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nginx_pv_claim.metadata.0.name
          }
        }
      }
    }
  }

}