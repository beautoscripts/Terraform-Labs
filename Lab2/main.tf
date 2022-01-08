# Configure AWS Providers
terraform {
  required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "~> 3.0"
      }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create custom VPC
resource "aws_vpc" "my_custom_vpc" {
  cidr_block = var.var_custom_vpc
  instance_tenancy = "default"
  tags = {
    "Name" = "my_custom_vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "my_public_subnet" {
  vpc_id = aws_vpc.my_custom_vpc.id
  cidr_block = var.var_public_subnet_cidr
  tags = {
    "Name" = "public_subnet"
  }
}

# Create Public Subnet
resource "aws_subnet" "my_private_subnet" {
  vpc_id = aws_vpc.my_custom_vpc.id
  cidr_block = var.var_private_subnet_cidr
  tags = {
    "Name" = "private_subnet"
  }
}

# Create Internet Gateway (IGW)
resource "aws_internet_gateway" "my_custom_igw" {
  vpc_id = aws_vpc.my_custom_vpc.id
  tags = {
    "Name" = "my_custom_igw"
  }
}

# Create Public Route table
resource "aws_route_table" "my_custom_public_routetable" {
  vpc_id = aws_vpc.my_custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.my_custom_igw.id
  }
  tags = {
      "Name" = "public_routetable"
  }
}

# Associate Public Subnet with Public Route table
resource "aws_route_table_association" "public_subnet_associate" {
    subnet_id       = aws_subnet.my_public_subnet.id
    route_table_id  = aws_route_table.my_custom_public_routetable.id
}

# Create Elastic IP
resource "aws_eip" "elasticip" {
  vpc = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     =  aws_subnet.my_public_subnet.id
}

# Create Private Route table
resource "aws_route_table" "my_custom_private_routetable" {
  vpc_id = aws_vpc.my_custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.natgateway.id
  }
  tags = {
      "Name" = "private_routetable"
  }
}

# Associate Private Subnet with Private Route table
resource "aws_route_table_association" "private_subnet_associate" {
    subnet_id       = aws_subnet.my_private_subnet.id 
    route_table_id  = aws_route_table.my_custom_private_routetable.id
}