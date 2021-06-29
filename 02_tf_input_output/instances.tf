data "aws_ami" "amazon_linux2" {
    // this expects a list ["aaa", "bbb"]
    owners = ["amazon"]
    most_recent = true
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
    }
}

resource "aws_instance" "ec2" {
    # ami           = "ami-0721c9af7b9b75114"
    ami           = data.aws_ami.amazon_linux2.id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.subnet.id
    
    key_name      = aws_key_pair.ssh_key.key_name
    user_data     = file("user_script.sh")
    
    vpc_security_group_ids = [aws_security_group.allow_ports.id]

    tags = {
        Name: "terraform-course"
    }    
}

// +sg allow_ports 

resource "aws_security_group" "allow_ports" {
    name   = "allow_ports"
    vpc_id = aws_vpc.vpc.id

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

resource "aws_key_pair" "ssh_key" {
    key_name = "ssh_key"
    public_key = file("test_key.pub")
}
