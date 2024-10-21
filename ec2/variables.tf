variable "group_name" {
  description = "Groupe name"
  type        = string
  default     = "test-groupe-name"
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "environment_name" {
  description = "environment_name"
  type        = list(any)
  default     = ["Development", "Prodaction"]
}

variable "subnets" {
  description = "List of subnets"
  type        = map(any)
  default = {
    "Development" = "10.0.1.0/24"
    "Prodaction"  = "10.0.2.0/24"
  }
}

variable "subnets_number" {
  type = map(any)
  default = {
    "Development" = "0"
    "Prodaction"  = "1"
  }
}

variable "s3_bucket_dz" {
  description = "S3_BUCKET"
  type = string
}