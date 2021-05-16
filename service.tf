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
      port        = 80
      target_port = 80 #container_port
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "httpinfo" {
  metadata {
    name      = "httpinfo"
    namespace = kubernetes_namespace.workspace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.httpinfo.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80 #container_port
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "hostpath_pvc_test" {
  metadata {
    name      = "hostpath-pvc-test"
    namespace = kubernetes_namespace.workspace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.hostpath_pvc_test.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80 #container_port
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "nfs_pvc_test" {
  metadata {
    name      = "nfs-pvc-test"
    namespace = kubernetes_namespace.workspace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nfs_pvc_test.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80 #container_port
    }

    type = "ClusterIP"
  }
}