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

resource "kubernetes_deployment" "hostpath_pvc_test" {
  metadata {
    name      = "hostpath-pvc-test"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "hostpath-pvc-test"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "hostpath-pvc-test"
      }
    }
    template {
      metadata {
        labels = {
          App = "hostpath-pvc-test"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "hostpath-pvc-test-container"

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
            claim_name = kubernetes_persistent_volume_claim.hostpath_pvc.metadata.0.name
          }
        }
      }
    }
  }

}

resource "kubernetes_deployment" "nfs_pvc_test" {
  metadata {
    name      = "nfs-pvc-test"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    labels = {
      App = "nfs-pvc-test"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "nfs-pvc-test"
      }
    }
    template {
      metadata {
        labels = {
          App = "nfs-pvc-test"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nfs-pvc-test-container"

          port {
            container_port = 80
          }
          volume_mount {
            name       = "nfs-volume"
            mount_path = "/usr/share/nginx/html"
          }
        }
        volume {
          name = "nfs-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nfs_pvc.metadata.0.name
          }
        }
      }
    }
  }

}