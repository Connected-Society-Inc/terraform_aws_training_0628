provider "aws" {
    region = "us-west-2"
  
}

resource "aws_instance" "ec2" {
    ami                    = "ami-0721c9af7b9b75114"
    instance_type          = "t3.micro"
}    
