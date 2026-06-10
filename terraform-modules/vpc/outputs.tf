output "vpc_id" {
    description = "The ID of this vpc"
    value = aws_vpc.this.id
}

output "public_subnet_ids" {
    description = "List Of ID's created in the public subnet"
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    description = "List Of ID's created in the private subnet"
    value = aws_subnet.private[*].id
}

output "private_subnet_availability_zones" {
  description = "List of Availability zones for private subnets"
  value       = aws_subnet.private[*].availability_zone 
}

output "public_subnet_availability_zones" {
  description = "List of Availability zones for public subnets"
  value       = aws_subnet.public[*].availability_zone 
}
