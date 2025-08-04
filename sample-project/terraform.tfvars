region          = "us-east-1"
region_name     = "virginia"
project_name    = "EKS-By-Terraform"
instance_types  = "t3.medium"
cluster_name    = "EKS-By-Terraform"
aws_profile     = "ankush-katkurwar30"
aws_account_id  = 600748199510
cidr_block      = "10.0.0.0/16"
node_group_name = "Primary-Node-Group"


ingress_rules = {
  http = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }
  https = {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from 0.0.0.0/0"
  }
  ssh_my_ip = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic from my IP"
  }
  allow_all_for_nodes = {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic"
  }
}
egress_rules = {
  http = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Outbound traffic from anywhere"
  }
}
