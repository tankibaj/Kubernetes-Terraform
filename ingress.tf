# https://kubernetes.io/docs/concepts/services-networking/ingress/
# https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types

resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = "workspace"
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
      host = "microk8s.test"
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

        path {
          path = "/cat"
          backend {
            service_name = kubernetes_service.httpinfo.metadata.0.name
            service_port = 80
          }
        }

      }
    }

    rule {
      host = "hostpath.microk8s.test"
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.hostpath_pvc_test.metadata.0.name
            service_port = 80
          }
        }
      }
    }

    rule {
      host = "nfs.microk8s.test"
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.nfs_pvc_test.metadata.0.name
            service_port = 80
          }
        }
      }
    }

  }
}

resource "kubernetes_ingress" "monitoring" {
  metadata {
    name      = "monitoring"
    namespace = var.namespace_monitoring
    annotations = {
      "kubernetes.io/ingress.class" = "public"
    }
  }
  spec {

    rule {
      host = "prometheus.microk8s.test"
      http {
        path {
          path = "/"
          backend {
            service_name = "prometheus-server"
            service_port = 80
          }
        }
      }
    }

    rule {
      host = "monitoring.microk8s.test"
      http {
        path {
          path = "/"
          backend {
            service_name = "grafana"
            service_port = 80
          }
        }
      }
    }

  }
}