module "vpc" {
  source        = "../modules/1.VPC"
  cluster_name  = var.cluster_name
  region        = var.region
  project_name  = var.project_name
  cidr_block    = var.cidr_block
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

# module "ssh_key" {
#   source   = "../modules/2.SSH-KEY"
#   key_name = var.key_name
# }

# module "ec2_instance" {
#   source        = "../modules/3.EC2"
#   instance_type = var.instance_type
#   ami           = var.ami
#   key_name      = var.key_name
#   subnet_ids    = module.vpc_demo.subnet_ids
#   sg_id         = module.vpc_demo.sg_id
# }

module "iam" {
  source       = "../modules/4.IAM"
  project_name = var.project_name
}

module "eks_cluster" {
  source                 = "../modules/5.EKS"
  region                 = var.region
  project_name           = var.project_name
  instance_types         = var.instance_types
  aws_profile            = var.aws_profile
  eks_cluster_role_arn   = module.iam.eks_cluster_role_arn
  eks_nodegroup_role_arn = module.iam.eks_nodegroup_role_arn
  private_subnet_ids     = module.vpc.privateSubnetIDs
  securityGroupID        = module.vpc.securityGroupID
  node_group_name        = var.node_group_name
}




module "karpenter" {
  source                              = "../modules/6.KARPENTER"
  project_name                        = var.project_name
  aws_profile                         = var.aws_profile
  region                              = var.region
  eks_cluster_name                    = module.eks_cluster.eks_cluster_name
  eks_cluster_endpoint                = module.eks_cluster.eks_cluster_endpoint
  aws_iam_openid_connect_provider_arn = module.eks_cluster.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = module.eks_cluster.aws_iam_openid_connect_provider_url
  cluster_ca_certificate              = module.eks_cluster.cluster_ca_certificate
  eks_nodegroup_role_name             = module.iam.eks_nodegroup_role_name

  depends_on = [module.eks_cluster]
}