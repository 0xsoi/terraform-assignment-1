variable "region" {
    default = ["eu-west-1", "eu-central-1"]
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr_template" {
    default = "10.0"
}

variable "key_pair_name" {
    default = ["eu-west-key", "eu-central-key"]
}

variable "subnet_cidr_eu_west_1" {
    default = "10.0.1.0/20"
}

variable "subnet_cidr_eu_central_1" {
    default = "10.0.2.0/20"
}