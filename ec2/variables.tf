variable "group_name" {
  description = "value"
  type        = string
  default     = "test"
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