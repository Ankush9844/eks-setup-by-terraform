###############################################################
# Add Addons in EKS cluster                                   #
###############################################################

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version               = "v1.46.0-eksbuild.1"
  service_account_role_arn    = aws_iam_role.ebsAddonRole.arn
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version               = "v1.20.0-eksbuild.1"
  service_account_role_arn    = aws_iam_role.vpcAddonRole.arn
}

###############################################################
#                                                             #
###############################################################