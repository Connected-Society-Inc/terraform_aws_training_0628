# resource <resource_type> <"internal" resource name>
resource "aws_vpc" "vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "terraform-course"
    }
}

resource "aws_subnet" "subnet" {
    # passing the ID of the VPC which will be also provisioned by this script
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.1.1.0/24"
    tags = {
        Name = "terraform-course"
    }
}

