provider "aws" {
    region = "us-west-2"
}

# VPC

# Subnet

resource "aws_instance" "instance" {
    count = 4
    
    ami = "ami-0721c9af7b9b75114"
    instance_type = "t3.micro" # t2.micro
}
