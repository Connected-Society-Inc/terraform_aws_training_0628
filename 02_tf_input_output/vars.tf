variable "resource_name_prefix" {
    type = string
    description = "Prefix added to the name tags"
}

variable "vpc_cidr_block" {
    type = string
    description = "CIDR block of your VPC"
    default = "10.1.0.0/16"
}

variable "subnet_cidr_block" {
    type = string
    # supported: bool, number, (list, map, set ... complex types!)
    description = "CIDR block of your Subnet"
    default = "10.1.1.0/24"
}
