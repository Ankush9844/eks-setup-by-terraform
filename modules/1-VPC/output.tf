# we use this output to export our variable
output "vpc_id" {
  value = aws_vpc.main.id
}

output "publicSubnetIDs" {
  value = [aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]
}
output "privateSubnetIDs" {
  value = [aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]
}
output "securityGroupID" {
  value = aws_security_group.securityGroup.id
}

output "availability_zone" {
  value = data.aws_availability_zones.zones.names[0]
}



