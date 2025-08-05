###############################################################
# Create  VPC IRSA Assume Role Policy                         #
###############################################################

data "aws_iam_policy_document" "vpcAddonAssumeRolePolicy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }
  }
}

resource "aws_iam_role" "vpcAddonRole" {
  assume_role_policy = data.aws_iam_policy_document.vpcAddonAssumeRolePolicy.json
  name               = "VPC-Addon-IRSA-Role"
}

resource "aws_iam_role_policy_attachment" "vpc_cni_role_policy_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpcAddonRole.name
}

###############################################################
# Create  EBS CSI Assume Role Policy                          #
###############################################################

data "aws_iam_policy_document" "ebsAddonAssumeRolePolicy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }
  }
}

resource "aws_iam_role" "ebsAddonRole" {
  assume_role_policy = data.aws_iam_policy_document.vpcAddonAssumeRolePolicy.json
  name               = "EBS-Addon-IRSA-Role"
}

resource "aws_iam_role_policy_attachment" "ebsDriverRolePolicyAttachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebsAddonRole.name
}

###############################################################
#                                                             #
###############################################################