resource "aws_instance" "ec2" {
    count = var.instance_count # starts from 0 to N - 1
    
    ami           = "ami-0721c9af7b9b75114"
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    tags = {
        Name: "${var.name_prefix}-${count.index + 1}"
    }
}

# count = 3
# tags: 
#  instance-1
#  instance-2
#  instance-3
