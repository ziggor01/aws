terraform {
  backend "s3" {
    bucket = "test-bucket-dz-courses"
    key    = "./terraform.tfstate"
    region = "eu-central-1"
    #dynamodb_table = "value"
    encrypt = true
  }
}
