module "vpc" {
  source        = "../modules/1-VPC"
  region        = var.region
  project_name  = var.project_name
  cidr_block    = var.cidr_block
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

module "ssh_key" {
  source   = "../modules/2-SSH-KEY"
  key_name = var.key_name
}

module "ec2_instance" {
  source            = "../modules/3-EC2"
  instance_type     = var.instance_type
  ami               = var.ami
  key_name          = module.ssh_key.private_key
  publicSubnetID    = module.vpc.publicSubnetIDs[0]
  availability_zone = module.vpc.availability_zone
  securityGroupID   = module.vpc.securityGroupID

}

module "iam" {
  source       = "../modules/4-IAM"
  project_name = var.project_name
}

module "eks_cluster" {
  source                 = "../modules/5-EKS"
  region                 = var.region
  aws_profile            = var.aws_profile
  project_name           = var.project_name
  instance_types         = var.instance_types
  node_group_name        = var.node_group_name
  private_subnet_ids     = module.vpc.privateSubnetIDs
  eks_cluster_role_arn   = module.iam.eks_cluster_role_arn
  eks_nodegroup_role_arn = module.iam.eks_nodegroup_role_arn
}

module "oidc_provider" {
  source       = "../modules/6-OIDC"
  cluster_name = module.eks_cluster.eks_cluster_name
  depends_on   = [module.eks_cluster]
}

module "eks_addon" {
  source                              = "../modules/7-ADDONS"
  cluster_name                        = module.eks_cluster.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = module.oidc_provider.aws_iam_openid_connect_provider_url
  depends_on                          = [module.eks_cluster]
}

module "karpenter" {
  source                              = "../modules/8-KARPENTER"
  region                              = var.region
  aws_profile                         = var.aws_profile
  project_name                        = var.project_name
  eks_cluster_name                    = module.eks_cluster.eks_cluster_name
  eks_cluster_endpoint                = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate              = module.oidc_provider.cluster_ca_certificate
  eks_nodegroup_role_name             = module.iam.eks_nodegroup_role_name
  aws_iam_openid_connect_provider_arn = module.oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = module.oidc_provider.aws_iam_openid_connect_provider_url
  depends_on                          = [module.eks_cluster]
}

module "load_balancer_controller" {
  source                              = "../modules/9-LB"
  vpc_id                              = module.vpc.vpc_id
  aws_region                          = var.region
  cluster_name                        = module.eks_cluster.eks_cluster_name
  project_name                        = var.project_name
  aws_iam_openid_connect_provider_arn = module.oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = module.oidc_provider.aws_iam_openid_connect_provider_url
}
