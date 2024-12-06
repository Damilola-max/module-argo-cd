provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  cluster_ca_certificate = 
base64decode(var.kubernetes_cluster_cert_data)

  exec {
    api_version = "client.authentication.k8s.io/v1"  # Use the 
correct API version
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", 
var.kubernetes_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_cluster_endpoint
    cluster_ca_certificate = 
base64decode(var.kubernetes_cluster_cert_data)

    exec {
      api_version = "client.authentication.k8s.io/v1"  # Use the 
correct API version
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", 
var.kubernetes_cluster_name]
    }
  }
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = var.kubernetes_cluster_name
  }
}

resource "helm_release" "argocd" {
  name       = "msur"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace.example.metadata[0].name
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}
