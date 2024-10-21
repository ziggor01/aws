terraform {
  required_version = ">=1.7"
  required_providers {
    #Провайдер AWS
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.70.0"
    }
    #Провайдер HCP Vault
    vault = {
      source  = "hashicorp/vault"
      version = ">=4.3.0"
    }
  }
}