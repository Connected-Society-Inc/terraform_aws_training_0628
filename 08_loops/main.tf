provider "aws" {
  region = "us-west-2"
}

variable "subnet_cidr_blocks" {
    type = list(string)
    default = ["10.1.1.0/24", /*"10.1.2.0/24",*/ "10.1.3.0/24"]
}

locals {
    vpc_cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "vpc" {
    cidr_block = local.vpc_cidr_block    
}

// Task: create a subnet for each cidr block defined in the local.subnet_cidr_blocks list
// "less perfect" solution is to use count, but beware of removing central elements from the list!
/*resource "aws_subnet" "subnet" {
    count      = length(var.subnet_cidr_blocks)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_blocks[count.index]
}*/

resource "aws_subnet" "subnets" {
    // other "loop" type:
    for_each = toset(var.subnet_cidr_blocks)

    vpc_id     = aws_vpc.vpc.id
    cidr_block = each.value
}
