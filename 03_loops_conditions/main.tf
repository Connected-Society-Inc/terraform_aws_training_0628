provider "aws" {
    region = "us-west-2"
}

module "network" {
    source = "./modules/network"
    vpc_cidr_block     = "10.1.0.0/16"
    subnet_cidr_block  = "10.1.1.0/24"

    # attributes: vpc_id, subnet_id
}

# custom resource type
module "instances" {
    // arguments of your custom resource defined by the module's vars.tf
    source         = "./modules/webserver"
    subnet_id      = module.network.subnet_id
    instance_count = 2

    // attributes are the output variables of the module
    // -> id
}

