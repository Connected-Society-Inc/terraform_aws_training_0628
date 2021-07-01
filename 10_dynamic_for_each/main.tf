provider "aws" {
    region = "us-west-2"
}

variable "open_ports" {
    type = list(number)
    default = [22, 80]
    description = "List of port numbers to be opened on the instance"
}

variable "vpc_id" {
    type = string
}

resource "aws_instance" "ec2" { 
    ami           = "ami-0721c9af7b9b75114"
    instance_type = "t3.micro"
}

resource "aws_security_group" "allow_ports" {
    # for_each = .... # iterator is always "each"
    name   = "allow_ports"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        # this for_each is not identical to for_each in line 21
        for_each = toset(var.open_ports) # iterator can be (need to be) configured
        iterator = it # set the name of the iterator, which can be any name, but "each" (!!)
        content {
            // we can define, what should go in each ingress { .. } 
            protocol    = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
            from_port   = it.value
            to_port     = it.value
        }    
    }
    
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}
