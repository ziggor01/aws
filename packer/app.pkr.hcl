# Plugin
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# variables (var)
variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "build_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_version" {
  type    = string
  default = "1.0-dev"
}

# locals
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  common_tags = {
    Release   = "${var.app_version}"
    OS_Family = "Ubuntu"
    OS_Vers   = "22.04"
  }
}

# source
source "amazon-ebs" "ubuntu" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  # settings
  ami_name      = "test-packer-ubuntu-aws-ebs-${local.timestamp}"
  instance_type = var.build_instance_type
  region        = var.aws_region
  profile       = "test-user"
  tags = local.common_tags
}

# build
build {
  name = "test-app-build"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = ["APP_VERSION=${var.app_version}"]
    pause_before     = "10s"
    inline = [
      "echo Welcome to test skript",
      "echo Preparing configuration for APP $APP_VERSION version",
      "sudo apt update",
      "sudo apt install mc git nginx -y"
    ]
  }
  provisioner "breakpoint" {
    disable = false
    note    = "Test network:${local.timestamp}"
  }
  
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      my_custom_data = "example"
    }
}

}