provider "aws" {
    region = "us-west-2"
}

locals {
    instance_count = 4
    instance_type = "t3.micro"
    my_list = ["aaa", "bbbb", "ccc"]
}

resource "aws_instance" "ec2" {
    count = local.instance_count
    
    ami           = "ami-0721c9af7b9b75114"
    instance_type = local.instance_type    
    tags = {
        Name: count.index % 2 == 0 ? "even" : "odd"
    }
}

output "public_ips" {
    value = aws_instance.ec2[*].public_ip
}

output "public_ips_v2" {
    value = [ for instance in aws_instance.ec2: instance.public_ip ] // semantically similar to public_ips
}

output "public_ips_even" {
    value = [ for instance in aws_instance.ec2: instance.public_ip if instance.tags["Name"] == "even" ]
}

output "public_ips_odd" {
    value = [ for instance in aws_instance.ec2: 
        instance.public_ip if instance.tags["Name"] == "odd" ]
}

