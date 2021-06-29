/*terraform {
    backend "s3" {
        // to access your state file
        // profile = "state-access"
    }
}*/

provider "aws" {
    region = "us-west-2"
    // to provision your resources + for using data sources
    // profile = "provisioner-access"
}

data "terraform_remote_state" "remote_state" {
    backend = "local"
    config = {
        path = "../03_modules/deployments/prod/terraform.tfstate"        
    }
}

/*data "terraform_remote_state" "s3_remote_state" {
    backend "s3" {
        bucket = ""
        key = ""
        # will be used to fetch the remote state of the other project
        profile = ""
    }
}*/

resource "aws_instance" "ec2" {
    ami = "ami-0721c9af7b9b75114"
    instance_type = "t3.micro"
    subnet_id = data.terraform_remote_state.remote_state.outputs.subnet_id
}
