resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr # Fixed variable name to match input
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name        = "${var.client_name}-${var.environment}-vpc" 
    Environment = var.environment
    Managedby   = "Terraform"
  }
}

resource "aws_internet_gateway" "this" { # Added missing quotes around type
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.client_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" { # Fixed quote spacing typo
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.client_name}-${var.environment}-public-${var.availability_zones[count.index]}"
    Environment = var.environment
    type        = "public"
  }
}

resource "aws_subnet" "private" { # Fixed name from "public" to "private" & removed leading space
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false # Private subnets shouldn't assign public IPs automatically

  tags = {
    Name        = "${var.client_name}-${var.environment}-private-${var.availability_zones[count.index]}"
    Environment = var.environment
    type        = "private"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc" # Wrapped "vpc" in quotes string definition

  tags = { 
    Name        = "${var.client_name}-${var.environment}-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public[0].id # Fixed syntax from .id[0] to [0].id
  allocation_id = aws_eip.nat.id

  tags = {
    Name        = "${var.client_name}-${var.environment}-nat-gateway"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.client_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id 
  }

  tags = {
    Name        = "${var.client_name}-${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id 
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id 
}

resource "aws_security_group" "web-server" {
  name        = "${var.client_name}-${var.environment}-web-server-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  ingress{
    description = "allow http"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


  }
  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-security-group"
  }
}