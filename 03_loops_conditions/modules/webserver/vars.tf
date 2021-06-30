variable "subnet_id" {
    type = string  
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "instance_count" {
    type = number
    description = "Number of instances to be provisioned"
    default = 1
}

variable "name_prefix" {
    type = string
    default = "terraform-course"
}
