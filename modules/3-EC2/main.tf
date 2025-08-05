resource "aws_instance" "ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  subnet_id                   = var.publicSubnetID
  security_groups             = [var.securityGroupID] # we [] this for avoid "string" error
}

