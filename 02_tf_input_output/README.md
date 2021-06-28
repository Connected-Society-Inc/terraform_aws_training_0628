Populate variables:

1. Command line:
```bash
terraform apply -var "vpc_cidr_block=10.1.0.0/16"
```

2. Through .tfvars file

```bash
terraform apply -var-file=params.tfvars
```

## Excercises:

1. Expose instance type as an input variable
2. Add a public ssh key to the instance
    (see: aws_ssh_keypair resource!  (you need to pass a public key as an argument))
    (in instance resource, set the key to be used)
    