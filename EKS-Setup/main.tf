module "vpc" {
  source        = "../modules/1-VPC"
  region        = var.region
  project_name  = var.project_name
  cidr_block    = var.cidr_block
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}
