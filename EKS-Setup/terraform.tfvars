ami          = "ami-021589336d307b577"
region       = "us-east-1"
aws_profile  = "ankush-katkurwar30"
cidr_block   = "10.0.0.0/16"
project_name = "EKS-By-Terraform"
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
