provider "aws" {
  region = "us-west-2"
}

locals {
    vpc_cidr_block = "10.1.0.0/16"
    subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

resource "aws_vpc" "vpc" {
    cidr_block = local.vpc_cidr_block    
}

// Task: create a subnet for each cidr block defined in the local.subnet_cidr_blocks list
resource "aws_subnet" "subnet" {
    count      = length(local.subnet_cidr_blocks)
    vpc_id     = aws_vpc.vpc.id
    // cidr_block = 
}
