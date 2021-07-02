provider "aws" {
    region = "us-west-2"
}

module "kms-key" {
  source  = "cloudposse/kms-key/aws"  
  version = "0.10.0"
  
   # insert the 11 required variables here
   namespace               = "eg"
   stage                   = "test"
   name                    = "chamber"
   description             = "KMS key for chamber"
   deletion_window_in_days = 10
   enable_key_rotation     = true
   alias                   = "alias/parameter_store_key"  
}
