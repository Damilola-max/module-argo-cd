variable "kubernetes_cluster_id" {
  type = string
}

variable "kubernetes_cluster_cert_data" {
  type = string
}

variable "kubernetes_cluster_endpoint" {
  type = string
}

variable "kubernetes_cluster_name" {
  type = string
}

variable "eks_nodegroup_id" {
  type = string
}

provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  client_certificate     = base64decode(var.kubernetes_cluster_cert_data)
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = var.kubernetes_cluster_name
  }
}
