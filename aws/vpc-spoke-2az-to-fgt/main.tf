##############################################################################################################
# VPC SPOKE
##############################################################################################################
resource "aws_vpc" "vpc-spoke" {
  cidr_block           = var.vpc-spoke_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# IGW
resource "aws_internet_gateway" "igw-vpc-spoke" {
  vpc_id = aws_vpc.vpc-spoke.id
  tags = {
    Name = "${var.prefix}-igw-vpc"
  }
}

# ---------------------------------------------------------------------
# Subnets - Az1
# ---------------------------------------------------------------------
resource "aws_subnet" "subnet-vpc-az1-vm" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 0)
  availability_zone = var.region["az1"]
  tags = {
    Name = "${var.prefix}-subnet-az1-vm"
  }
}

resource "aws_subnet" "subnet-vpc-az1-gwlb" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 1)
  availability_zone = var.region["az1"]
  tags = {
    Name = "${var.prefix}-subnet-az1-gwlb"
  }
}

resource "aws_subnet" "subnet-vpc-az1-tgw" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 2)
  availability_zone = var.region["az1"]
  tags = {
    Name = "${var.prefix}-subnet-vpc-az1-tgw"
  }
}

# ---------------------------------------------------------------------
# Subnets - Az2
# ---------------------------------------------------------------------
resource "aws_subnet" "subnet-vpc-az2-vm" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 4)
  availability_zone = var.region["az2"]
  tags = {
    Name = "${var.prefix}-subnet-az2-vm"
  }
}

resource "aws_subnet" "subnet-vpc-az2-gwlb" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 5)
  availability_zone = var.region["az2"]
  tags = {
    Name = "${var.prefix}-subnet-az2-gwlb"
  }
}

resource "aws_subnet" "subnet-vpc-az2-tgw" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr, 3, 6)
  availability_zone = var.region["az2"]
  tags = {
    Name = "${var.prefix}-subnet-vpc-az2-tgw"
  }
}