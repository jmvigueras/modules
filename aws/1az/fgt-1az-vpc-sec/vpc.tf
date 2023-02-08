##############################################################################################################
# - Not change -
# Create VPC HUB Golden
##############################################################################################################
resource "aws_vpc" "vpc-hub" {
  cidr_block           = var.vpc-hub_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.tags
}

# AWS Internet Gateway asssociated with VPC
resource "aws_internet_gateway" "vpc-hub_igw" {
  vpc_id = aws_vpc.vpc-hub.id
  tags = var.tags
}
