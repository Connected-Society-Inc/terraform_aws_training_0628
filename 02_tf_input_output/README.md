Populate variables:

1. Command line:
```bash
terraform apply -var "vpc_cidr_block=10.1.0.0/16"
```

2. Through .tfvars file

```bash
terraform apply -var-file=params.tfvars
```


