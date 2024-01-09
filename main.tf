provider "aws" {
    region = var.region
}

module "instances" {
    source = "./modules/instance"
     vpc_id              = aws_vpc.main.id
    subnet_id            = aws_subnet.public.*.id
    security_groups      = [aws_security_group.security_group.id]
}

