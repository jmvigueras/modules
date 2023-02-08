##############################################################################################################
# - NOT CHANGE - Create Subnets in Securtiy VPC AZ1 (Availability Zone 1)
##############################################################################################################

// Subnet for management and HA interface -> example cidr used range: 10.1.1.0/26
resource "aws_subnet" "subnet-az1-mgmt-ha" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr,2,0)
  availability_zone = var.region["region_az1"]
  tags = var.tags
}

// Subnet for public interface -> example cidr used range: 10.1.1.64/26
resource "aws_subnet" "subnet-az1-public" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr,2,1)
  availability_zone = var.region["region_az1"]
  tags = var.tags
}

// Subnet for private interface -> example cidr used range: 10.1.1.128/26
resource "aws_subnet" "subnet-az1-private" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr,2,2)
  availability_zone = var.region["region_az1"]
  tags = var.tags
}

// Subnet for servers
resource "aws_subnet" "subnet-az1-servers" {
  vpc_id            = aws_vpc.vpc-spoke.id
  cidr_block        = cidrsubnet(var.vpc-spoke_cidr,3,7)
  availability_zone = var.region["region_az1"]
  tags = var.tags
}
