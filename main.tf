provider "kubernetes" {
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
  host                   = var.kubernetes_cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"  # Correct version
    command     = "aws-iam-authenticator"
    args        = ["token", "-i", var.kubernetes_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
    host                   = var.kubernetes_cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"  # Correct version
      command     = "aws-iam-authenticator"
      args        = ["token", "-i", var.kubernetes_cluster_name]
    }
  }
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "argo"
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
      source = "hashicorp/kubernetes"
      version = ">= 2.0"  # Ensure the latest version
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.0"  # Ensure the latest version
    }
  }
}
