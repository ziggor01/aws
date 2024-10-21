provider "aws" {
  # Configuration options
  region     = var.aws_region
  profile = "test-user"
}

locals {
  basic_name_prefix = "dz-${var.group_name}"
}

#Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name"  = local.basic_name_prefix
    "Group" = var.group_name
  }
}

#Create Security Group defoult
resource "aws_default_security_group" "defoult_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Default ingress ${local.basic_name_prefix} security group rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Default egress ${local.basic_name_prefix} security group rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} security group"
    "Group" = var.group_name
  }

}

#Create Gateway
resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} internet gateway"
    "Group" = var.group_name
  }
}

#Create Route
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} internet gateway"
    "Group" = var.group_name
  }
}

#Create Subnet
resource "aws_subnet" "main" {
  count                   = length(var.environment_name)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(var.subnets, var.environment_name[count.index])
  map_public_ip_on_launch = true

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} internet gateway"
    "Group" = var.group_name
  }
}

resource "aws_route_table_association" "main_rta" {
  count          = length(var.environment_name)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.name.id
}

#Create Security Group MAIN
resource "aws_security_group" "main_sg" {
  name        = "${local.basic_name_prefix} Security Group"
  description = "Security group for main resources"
  vpc_id      = aws_vpc.main.id

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} internet gateway"
    "Group" = var.group_name
  }


  ingress {
    description = "Open 22 ${local.basic_name_prefix} security group rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Open 80 ${local.basic_name_prefix} security group rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Default egress ${local.basic_name_prefix} security group rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "name" {
  subnet_id       = aws_subnet.main["${var.subnets_number["Development"]}"].id
  security_groups = ["${aws_security_group.main_sg.id}"]
  description     = ""

  tags = {
    "Name"  = "Default ${local.basic_name_prefix} internet gateway"
    "Group" = var.group_name
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "main_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "key-dz"

  network_interface {
    network_interface_id = aws_network_interface.name.id
    device_index         = 0
  }

  monitoring = true
  tags = {
    "Name"  = "Default ${local.basic_name_prefix}"
    "Group" = var.group_name
  }
  volume_tags = {
    "Name"  = "Default ${local.basic_name_prefix}"
    "Group" = var.group_name
  }

  depends_on = [aws_network_interface.name]
}

resource "aws_s3_bucket" "s3_main" {
  bucket = var.s3_bucket_dz
  
  
  tags = {
    "Name"  = "Default ${local.basic_name_prefix} s3 bucket"
    "Group" = var.group_name
  }
}