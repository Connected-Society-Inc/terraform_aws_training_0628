terraform {

/*    backend "<backend name>" {
        // configuration of backend comes here
    }*/

    backend "s3" { 
        bucket = "terraform-course-states-89889"
        key    = "terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform-lock"
    }

}
