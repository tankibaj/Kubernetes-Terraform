terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}