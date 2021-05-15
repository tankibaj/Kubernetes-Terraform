variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace_workspace" {
  type    = string
  default = "workspace"
}

variable "namespace_monitoring" {
  type    = string
  default = "monitoring"
}

variable "grafana_password" {
  type    = string
  default = "admin"
}