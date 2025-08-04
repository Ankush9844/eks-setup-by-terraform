terraform {

  backend "s3" {
    bucket  = "eks-setup-by-terraform-23858"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "ankush-katkurwar30"
  }
}

