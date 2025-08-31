terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.99"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.37"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}


provider "aws" {
  region  = var.region
  profile = var.aws_profile
}
