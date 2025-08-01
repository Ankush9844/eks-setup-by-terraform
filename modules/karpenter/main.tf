module "iam" {
  source                              = "./iam"
  project_name                        = var.project_name
  region                              = var.region
  aws_account_id                      = var.aws_account_id
  aws_iam_openid_connect_provider_arn = var.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = var.aws_iam_openid_connect_provider_url
  eks_nodegroup_role_name             = var.eks_nodegroup_role_name
}


#########################################################
# Karpenter Install Using Helm in EKS Cluster           #
#########################################################

resource "helm_release" "karpenter" {

  name             = "karpenter"
  namespace        = "kube-system"
  repository       = "oci://public.ecr.aws/karpenter/"
  chart            = "karpenter"
  version          = "1.5.0"
  create_namespace = false

  depends_on = [ var.eks_cluster_name ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam.karpenter_controller_role_arn
  }

  set {
    name  = "settings.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.eks_cluster_endpoint
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.iam.karpenter_instance_profile_name
  }

}
