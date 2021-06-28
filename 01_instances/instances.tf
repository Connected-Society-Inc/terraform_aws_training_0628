resource "aws_instance" "ec2" {
    ami           = "ami-0721c9af7b9b75114"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.subnet.id
    tags = {
        Name: "terraform-course"
    }
}
