provider "aws" {
    region = "us-west-2"
  
}

variable "vpc_id" {
    type = string
}

resource "aws_instance" "ec2" {
    ami             = "ami-0721c9af7b9b75114"
    instance_type   = "t3.micro"
    key_name        = aws_key_pair.ssh_key.key_name
    vpc_security_group_ids = [ aws_security_group.allow_ports.id ]
}

resource "aws_key_pair" "ssh_key" {
    key_name = "ssh_key"
    public_key = file("test_key.pub")
}

resource "aws_security_group" "allow_ports" {
    name   = "allow_ports"
    vpc_id = var.vpc_id

    ingress {
        description = "Allows HTTP"
        # port range 80 - 80
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allows SSH"
        # port range 22 - 22
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

output "public_ip" {
    value = aws_instance.ec2.public_ip
}