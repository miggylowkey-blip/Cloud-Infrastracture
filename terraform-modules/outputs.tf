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

output "web_security_group_id" {
    description = "The ID of the web security group"
    value = aws_security_group.web_server.id
}

output "server_public_ip" {
  value       = module.compute.public_ip
  description = "The public IP of our live server"
}