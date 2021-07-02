provider "aws" {
    region = "us-west-2"
}

module "website" {
  source  = "thrashr888/s3-website/aws"
  version = "0.4.0"

  bucket_name = "my-website-283798ancj2ca2"
}

output "public_url" {
    value = module.website.website_endpoint
}