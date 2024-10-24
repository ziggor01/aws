variable "group_name" {
  description = "Groupe name"
  type        = string
  default     = "test-groupe-name"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment_name" {
  description = "environment_name"
  type        = list(any)
  default     = ["Development", "Prodaction"]
}

variable "vpc" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
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

variable "s3_b" {
  description = "S3_BUCKET"
  type        = string
  default     = "s3_bucket_dz"
}