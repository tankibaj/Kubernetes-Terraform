resource "kubernetes_persistent_volume_claim" "hostpath_pvc" {
  metadata {
    name      = "hostpath-pvc"
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

resource "kubernetes_persistent_volume_claim" "nfs_pvc" {
  metadata {
    name      = "nfs-pvc"
    namespace = kubernetes_namespace.workspace.metadata.0.name
    annotations = {
      "volume.beta.kubernetes.io/storage-class" = "nfs-client"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}