##############################################################################################################
# Create VPC spoke
##############################################################################################################
resource "aws_vpc" "vpc-spoke" {
  cidr_block           = var.vpc-spoke_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.tags
}

# AWS Internet Gateway asssociated with VPC
resource "aws_internet_gateway" "vpc-spoke_igw" {
  vpc_id = aws_vpc.vpc-spoke.id
  tags = var.tags
}
