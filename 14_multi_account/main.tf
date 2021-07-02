provider "aws" {
    alias   = "aws_account_1"
    profile = "account_1"
    // region = ...
}

provider "aws" {
    alias   = "aws_account_2"
    profile = "account_2"    
}

provider "google" { 
    // credentials ...
    
}

resource "..." "..." {
    provider = "aws_account_1"
    // ...
}

resource "aws_instance" "instance" {
    provider = "aws_account_2"
    // ..
}

resource "google_compute_instance" "instance" {

    // ...
}
