# Configure AWS Provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.var_vpc_cidr
  instance_tenancy = "default"
  tags = {
      "Name" = "my_vpc-1"
  }
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = var.var_private_subnet_cidr
  tags = {
    "Name" = "private_subnet"
  }

}

# Create Private Route table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      "Name" = "private_subnet"
  }
}

# Associate Private Subnet to Private Route table
resource "aws_route_table_association" "private_sub_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

# Create Gateway Endpoint
resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
      "Name" = "S3-Gateway-Endpoint"
  }
}

# Associate VPC Endpoint (Gateway) with Private Route table
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_association" {
  route_table_id = aws_route_table.private_route.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_gateway_endpoint.id
}