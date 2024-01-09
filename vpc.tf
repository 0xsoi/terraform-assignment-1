# Data source for available regions
data "aws_availability_zones" "available" {}

# VPC configuration

resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags                 = {
        Name             = "Main VPC"
    }
}

# Subnets for different availability zones 
resource "aws_subnet" "public" {
    for_each                = { for az in data.aws_availability_zones.available.names : az => az }
    availability_zone       = each.key
    cidr_block              = var.subnet_cidr_template
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true

    tags                    = {
        Name                = "Public Subnet - ${each.key}"
    }
    
    # Conditional assignment based on availability zone
 condition =
  each.key == "eu-west-1a" || each.key == "eu-west-1b" ? var.subnet_cidr_eu_west_1 : each.key == "eu-central-1a" || each.key == "eu-central-1b" ? var.subnet_cidr_eu_central_1 : null

}



# Route table 
resource "aws_route_table" "public_rtb" {
  vpc_id         = aws_vpc.main.id

  route {
    cidr_block   = "0.0.0.0.0/0"
    gateway_id   = aws_internet_gateway.internet_gateway.id
  }

  tags           = {
    Name         = "Main rtb"
  }
}

resource "aws_internet_gateway" "internet_gateway" {  
  vpc_id     = aws_vpc.main.id

  tags       = {
    Name     = "Main igw"
  }
}

# Security group
resource "aws_security_group" "security_group" {
  name        = "main_security_group"

  ingress {
    description   = "SSH"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description   = "HTTP"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description   = "HTTPS"
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Route Table association
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id          = aws_subnet.public.id
  route_table_id     = aws_route_table.public_rtb.id
}


output "vpc_id" {
    value = aws_vpc.main.id
}

output "internet_gateway" {
    value = aws_internet_gateway.internet_gateway
}