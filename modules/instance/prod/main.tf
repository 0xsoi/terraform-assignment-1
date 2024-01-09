resource "aws_instance" "instance" {
    ami                 = var.region == "eu-west-1" ? var.ami_eu_west_1 : var.ami_eu_central_1
    instance_type       = var.instance_type
    key_name            = var.region == "eu-west-1" ? "eu-west-key" : "eu-central-key"
    vpc_id              = var.vpc_id
    subnet_id           = var.subnet_id[0]

    environment         = var.environment

    user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y ansible
              sudo apt-get install -y docker.io
              sudo usermod -aG docker ubuntu
              EOF


    tags                  = {
        Name              = "${var.environment}-instance"
    }
}

output "public_ip" {
    value = aws_instance.instance.public_ip
}