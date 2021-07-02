provider "aws" {
    region = "us-west-2"    
}

/*variable "username" {
    type = string
}

variable "password" {
    type      = string
    sensitive = true
}*/

// Use remote backend as your state file along with the secret information won't be stored on your hard disk unencrypted
/*terraform {
    backend "s3" {

    }
}*/

data "aws_secretsmanager_secret_version" "db_creds" {
    secret_id = "test-secret2" // json string
}

locals {
    db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}

resource "aws_db_instance" "db_instance" {
    engine              = "mysql"
    instance_class      = "db.t3.medium"
    name                = "terraform"
    allocated_storage   = 10
    skip_final_snapshot = true

    username = local.db_creds.username
    password = local.db_creds.password
}


