variable "instance_type" {
    default = "t2.micro"
}

variable "ami_eu_west_1" {
    default = "ami-0694d931cee176e7d"
}

variable "ami_eu_central_1" {
    default = "ami-06dd92ecc74fdfb36"
}

variable "key_name" {
    default = ["eu-west-key", "eu-central-key"]
}

variable "environment" {
    default = "prod"
}

variable "subnet_id" {
    default ="aws_subnet.public.*.id"
}

variable "vpc_id" {
    default = "aws_vpc.main.id"
}