region          = "us-east-1"
ami             = "ami-021589336d307b577"
key_name        = "eks-bastion-node"
region_name     = "virginia"
project_name    = "EKS-By-Terraform"
instance_type   = "t2.micro"
instance_types  = "t3.medium"
aws_profile     = "ankush-katkurwar30"
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
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
    description = "Allow SSH traffic from my IP"
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
