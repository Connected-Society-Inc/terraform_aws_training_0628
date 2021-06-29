provider "aws" {
    region = "us-west-2"
}

module "network" {
    source = "../03_modules/modules/network"
    vpc_cidr_block     = "10.1.0.0/16"
    subnet_cidr_block  = "10.1.1.0/24"
}


output "vpc_id" {
    value = module.network.vpc_id
}
