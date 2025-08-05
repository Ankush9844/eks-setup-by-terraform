################################################################
# Create EKS Cluster                                           #
################################################################

resource "aws_eks_cluster" "eksCluster" {
  name     = var.project_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.securityGroupID]
  }
}

################################################################
# EKS node group                                               #
################################################################

resource "aws_eks_node_group" "eksNodeGroup" {
  node_group_name = var.node_group_name
  cluster_name    = aws_eks_cluster.eksCluster.name
  node_role_arn   = var.eks_nodegroup_role_arn
  subnet_ids      = [var.private_subnet_ids[0], var.private_subnet_ids[1]]
  capacity_type   = "ON_DEMAND"
  instance_types  = [var.instance_types]
  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }
  update_config {
    max_unavailable = 1
  }
  labels = {
    role = "general"
  }
  lifecycle {
    create_before_destroy = true
  }
}


################################################################
#                                                              #
################################################################
