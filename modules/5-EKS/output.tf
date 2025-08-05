output "eks_cluster_id" {
  value = aws_eks_cluster.eksCluster.id
}

output "eks_cluster" {
  value = aws_eks_cluster.eksCluster
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eksCluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eksCluster.endpoint
}




