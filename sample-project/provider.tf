terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.99"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.37"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["--profile", var.aws_profile, "eks", "get-token", "--cluster-name", module.eks_cluster.eks_cluster_name, "--region", "us-east-1"]
      command     = "aws"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

