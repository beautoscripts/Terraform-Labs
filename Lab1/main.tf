# Configure Required Provider
terraform {
  required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "~> 3.0"
      }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create custom vpc
resource "aws_vpc" "my_custom_vpc" {
    cidr_block = var.var_custom_vpc_cidr
    instance_tenancy        = "default"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags = {
      "Name" = "my_custom_vpc"
    }
}
/*
    Steps for creating public subnet
    - create subnet
    - create internet gateway and attached it to above custom vpc
    - create route table and add IGW route
    - associate custom subnet to route table
*/

# Create custom subnet (public)
resource "aws_subnet" "my_custom_subnet_public" {
    vpc_id = aws_vpc.my_custom_vpc.id
    cidr_block = var.var_custom_subnet_public_cidr
    tags = {
      "Name" = "my_custom_public_subnet"
    }
}

# Create custom internet gateway (IGW)
# Attache it to custom VPC
resource "aws_internet_gateway" "my_custom_igw" {
  vpc_id = aws_vpc.my_custom_vpc.id
  tags = {
    "Name" = "my_custom_igw"
  }
}

# Create custom route table
# Add IGW route
resource "aws_route_table" "my_custom_route_table" {
  vpc_id = aws_vpc.my_custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.my_custom_igw.id
  }
  tags = {
    "Name" = "my_custom_route_public"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "public_subnet_route_association" {
    subnet_id       = aws_subnet.my_custom_subnet_public.id
    route_table_id  = aws_route_table.my_custom_route_table.id
  
}