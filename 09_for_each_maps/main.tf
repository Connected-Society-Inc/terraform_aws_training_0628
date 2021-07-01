provider "aws" {
  region = "us-west-2"
}

variable "vpc_cidr_block" {
    type = string
    default = "10.1.0.0/16"
}

variable "subnet_configuration" {
   # Assumption: you always have at least one public subnet!!!!!
   type = map(object({
       cidr_block = string
       public     = bool
   }))
   default = {
       "subnet_public" = {
           "cidr_block" = "10.1.1.0/24",
           "public" = true
       },
       "subnet_private" = {
           "cidr_block" = "10.1.2.0/24"
           "public" = false
       }
   }
}

/*
Hints:
=======

> var.subnet_configuration["subnet_public"]
{
  "cidr_block" = "10.1.1.0/24"
  "public" = true
}

> var.subnet_configuration["subnet_public"].cidr_block
"10.1.1.0/24"
> [ for key, value in var.subnet_configuration: key ]
[
  "subnet_private",
  "subnet_public",
]

# Using for loop for iterating over a map
> [ for key, value in var.subnet_configuration: value ]
[
  {
    "cidr_block" = "10.1.2.0/24"
    "public" = false
  },
  {
    "cidr_block" = "10.1.1.0/24"
    "public" = true
  },
]
> [ for key, value in var.subnet_configuration: value.public ]
[
  false,
  true,
]

# print out the name of those subnets which are set to public
> [ for key, value in var.subnet_configuration: key if value.public == true ]
[
  "subnet_public",
]
> [ for key, value in var.subnet_configuration: key if value.public == false ]
[
  "subnet_private",
]
  
*/

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block   
    enable_dns_hostnames = true
}

resource "aws_subnet" "subnets" {
    for_each = var.subnet_configuration
    
    # TODO: set this true if subnet.public == true, otherwise false
    # map_public_ip_on_launch = true

    vpc_id     = aws_vpc.vpc.id
    cidr_block = each.value.cidr_block
    tags = {
        "Name" = each.key
    }
}


resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
}

locals {
  first_public_subnet_name = [ for subnet_name, subnet_conf in var.subnet_configuration: subnet_name if subnet_conf.public == true ][0]
}

resource "aws_eip" "nat_ip" {
    // TODO: create this one if you have at least one private subnet (same as nat_gw)
    # count = 0/1
    count = length([ for subnet in var.subnet_configuration: subnet if subnet.public == false ]) > 0 ? 1 : 0
}

# We need just one nat gw, but needs to be placed into a public subnet
resource "aws_nat_gateway" "nat_gw" {
    # TODO: create this resource only if we have at least one private subnet
    # count = 1 or 0 depending if you have any private subnet defined
    count = length([ for subnet in var.subnet_configuration: subnet if subnet.public == false ]) > 0 ? 1 : 0
    
    // TODO: place this nat gw into a public subnet! (find the first public subnet in the configuration)
    subnet_id     = aws_subnet.subnets[local.first_public_subnet_name].id
    
    allocation_id = aws_eip.nat_ip[0].id
}

resource "aws_route_table" "public_route" {
    vpc_id     = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table" "private_route" {
    count = length([ for subnet in var.subnet_configuration: subnet if subnet.public == false ]) > 0 ? 1 : 0

    vpc_id     = aws_vpc.vpc.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw[0].id
    }
}

locals {
    public_subnet_names  = [ for subnet_name, subnet_conf in var.subnet_configuration: subnet_name if subnet_conf.public == true ]
    private_subnet_names = [ for subnet_name, subnet_conf in var.subnet_configuration: subnet_name if subnet_conf.public == false ]
}

resource "aws_route_table_association" "public" {
    for_each = toset(local.public_subnet_names)

    # associate public_route to all public subnets
    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private" {
    for_each = toset(local.private_subnet_names)

    # associate private_route table to all private subnets
    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.private_route[0].id
}
