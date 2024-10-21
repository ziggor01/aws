terraform {
  backend "s3" {
    bucket = var.s3_b
    key    = "path/to/my/key"
    region = var.aws.region
    dynamodb_table = "value"
    encrypt = true
  }
}
