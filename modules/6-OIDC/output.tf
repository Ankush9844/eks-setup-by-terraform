output "aws_iam_openid_connect_provider_url" {
  value = aws_iam_openid_connect_provider.eks_oidc.url
}

output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "cluster_ca_certificate" {
value = data.aws_eks_cluster.eks.certificate_authority[0].data
}