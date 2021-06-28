# resource <resource_type> <"internal" resource name>
resource "aws_vpc" "vpc" {
    # cidr_block = "10.1.0.0/16"
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    tags = {
        Name = "${var.resource_name_prefix}-vpc"
    }
}

resource "aws_subnet" "subnet" {
    # passing the ID of the VPC which will be also provisioned by this script
    vpc_id     = aws_vpc.vpc.id
    #cidr_block = "10.1.1.0/24"
    cidr_block = var.subnet_cidr_block
    tags = {
        Name = "${var.resource_name_prefix}-subnet"
    }
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
    // this is just an argument which expects a map as a value
    tags = {        
        Name = "${var.resource_name_prefix}-gw"
    }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id
    // block (~ argument namespaces)
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "subnet_association" {
    #        <resource type>.<resource id>.<attribute>
    subnet_id      = "${aws_subnet.subnet.id}"
    route_table_id = "${aws_route_table.route_table.id}"
}
