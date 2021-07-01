provider "aws" {
    region = "us-west-2"
  
}

variable "vpc_id" {
    type = string
}

// aws_instance other_instance

resource "aws_instance" "ec2" {

    ami                    = "ami-0721c9af7b9b75114"
    instance_type          = "t3.micro"
    key_name               = aws_key_pair.ssh_key.key_name
    vpc_security_group_ids = [ aws_security_group.allow_ports.id ]

    /* To install nginx, I need to run on the instance:
       sudo amazon-linux-extras install -y nginx1
       sudo systemctl start nginx
       sudo systemctl enable nginx */
    /*provisioner "remote-exec" {
        inline = [
            "sudo amazon-linux-extras install -y nginx1",
            "sudo systemctl start nginx",
            "sudo systemctl enable nginx"
        ]
        // Note: destroy time provisioners won't run on top of tainted resources
        when = create # / destroy == will run when the resource will be destroyed        
        connection {
            type        = "ssh"
            host        = self.public_ip
            user        = "ec2-user"
            private_key = file("./test_key")
        }
    }*/

    provisioner "local-exec" {
        command = "echo \"Hello World!\""
        when = destroy
    }   
    // user_data = "yum install ..." <== This would be much better than using provisioners! (if you can)
}

// This null_resource will be re-created when the script.sh file changed
// when the script file changes, provisiorners below will run
resource "null_resource" "null" {

    // null_resource won't be provisoned before the ec2 instance
    depends_on = [ aws_instance.ec2 ]

    // what change should trigger a re-creation event on top of this null_resource
    triggers = {
        script_content = file("./script.sh")
    }

    provisioner "remote-exec" {
        script = "./script.sh"
        connection {
            type        = "ssh"
            host        = aws_instance.ec2.public_ip
            user        = "ec2-user"
            private_key = file("./test_key")
        }
    }

    provisioner "local-exec" {
        command = "echo \"Hello from null resource provisioner!\""        
    }   
}

resource "null_resource" "null_all_time" {

    triggers = {
        random = uuid()
    }

    provisioner "local-exec" {
        command = "./post_apply.sh"
    }
}

// ========================================================================================

resource "aws_key_pair" "ssh_key" {
    key_name = "ssh_key"
    public_key = file("test_key.pub")
}

resource "aws_security_group" "allow_ports" {
    name   = "allow_ports"
    vpc_id = var.vpc_id

    ingress {
        description = "Allows HTTP"
        # port range 80 - 80
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allows SSH"
        # port range 22 - 22
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

output "public_ip" {
    value = aws_instance.ec2.public_ip
}