################################################################
# Create VPC                                                   #
################################################################

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

################################################################
# Create IGW in VPC                                            #
################################################################

resource "aws_internet_gateway" "internetGateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }

}

################################################################
# Get Available Zones                                          #
################################################################

data "aws_availability_zones" "zones" {
  state = "available"
}
output "zones" {
  value = data.aws_availability_zones.zones.names
}


################################################################
# Create Public Subnets in VPC                                 #
################################################################

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  cidr_block              = cidrsubnet("${var.cidr_block}", 8, count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name"                      = "Public-Subnet-${count.index + 1}"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/eks" = "owned"
    "karpenter.sh/discovery"    = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

################################################################
# Create Public Route Table                                    #
################################################################

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetGateway.id
  }
}

################################################################
# Associate Public Subnet Route                                #
################################################################

resource "aws_route_table_association" "publicSubnetRoute" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicRouteTable.id
}


################################################################
# Create Private Subnets in VPC                                #
################################################################

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("${var.cidr_block}", 8, count.index + 2) # start from 10.0.2.0/24
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = {
    Name                              = "Private-Subnet-${count.index + 1}"
    Type                              = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks"       = "owned"
    "karpenter.sh/discovery"          = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


################################################################
# Create Private Route Table                                   #
################################################################

resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private-Route-Table"
  }
}

################################################################
# Associate Private Subnet Route                               #
################################################################

resource "aws_route_table_association" "privateSubnetRoute" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privateRouteTable.id
}



###############################################################
#Create Elastic IP for Natgateway                             #
###############################################################

resource "aws_eip" "elasticIP" {}

###############################################################
#Create  Natgateway                                           #
###############################################################

resource "aws_nat_gateway" "natGateway" {
  allocation_id = aws_eip.elasticIP.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "NAT-Gateway"
  }
}

###############################################################
# Create  Natgateway Route in Private Route Table              #
###############################################################

resource "aws_route" "natGatewayRoute" {
  route_table_id         = aws_route_table.privateRouteTable.id
  nat_gateway_id         = aws_nat_gateway.natGateway.id
  destination_cidr_block = "0.0.0.0/0"
}


###############################################################
# Create  Security Group for EKS Cluster                      #
###############################################################

resource "aws_security_group" "securityGroup" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                     = "security-group"
    "karpenter.sh/discovery" = var.cluster_name
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}


