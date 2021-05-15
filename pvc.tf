resource "kubernetes_persistent_volume_claim" "nginx_pv_claim" {
  metadata {
    name      = "nginx-pv-claim"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    annotations = {
      "volume.beta.kubernetes.io/storage-provisioner" = "microk8s.io/hostpath"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    # volume_name = kubernetes_persistent_volume.example.metadata.0.name
  }
}