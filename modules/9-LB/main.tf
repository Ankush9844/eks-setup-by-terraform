################################################################
# Fetch IAM Policy for LBC                                     #
################################################################

data "http" "loadBalancerControllerIAM_PolicyFile" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json"
  request_headers = {
    Accept = "application/json"
  }
}


################################################################
# Create IAM Policy for LBC using json data                    #
################################################################

resource "aws_iam_policy" "loadBalancerControllerIAM_Policy" {
  name   = "${var.project_name}-LBC-Policy"
  path   = "/"
  policy = data.http.loadBalancerControllerIAM_PolicyFile.response_body
}


################################################################
# Create IAM AssumeRole Policy for LBC                         #
################################################################

data "aws_iam_policy_document" "loadBalancerControllerIAM_AssumeRolePolicy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }

  }
}

################################################################
# Create IAM AssumeRole for LBC                                #
################################################################

resource "aws_iam_role" "loadBalancerControllerIAM_Role" {
  assume_role_policy = data.aws_iam_policy_document.loadBalancerControllerIAM_AssumeRolePolicy.json
  name               = "AmazonEKS-LBC-ControllerRole"
  tags = {
    "Name" = "AmazonEKS-LBC-ControllerRole"
  }
}


resource "aws_iam_role_policy_attachment" "lbc_policy_attachment" {
  policy_arn = aws_iam_policy.loadBalancerControllerIAM_Policy.arn
  role       = aws_iam_role.loadBalancerControllerIAM_Role.name
}


################################################################
# Create LBC using Helm Release                                #
################################################################


resource "helm_release" "loadBalancerController" {
  name       = "load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.loadBalancerControllerIAM_Role.arn
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}


################################################################
#                                                              #
################################################################
