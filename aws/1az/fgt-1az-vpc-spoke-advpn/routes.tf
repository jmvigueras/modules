##############################################################################################################
# - NOT CHANGE - Create routes for each subnet in Security VPC 
##############################################################################################################

# Create route for mgmt-ha subnet: 
#  default -> Internet Gateway
resource "aws_route_table" "rt-mgmt-ha" {
  vpc_id = aws_vpc.vpc-spoke.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-spoke_igw.id
  }
  tags = var.tags
}

# Create route for public subnet:
#   default to Internet Gateway
#   vpc-golden_cidr to Port3
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc-spoke.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-spoke_igw.id
  }
  tags = var.tags
}

# Create route for Transit Gateway subnet:
#   default to Fortigate port3
resource "aws_route_table" "rt-servers" {
  vpc_id = aws_vpc.vpc-spoke.id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id  = aws_network_interface.ni-fgt-port3.id
  }
  tags = var.tags
}

##############################################################################################################
# Associate routes with Subnets

# Route table association subnet MGMT-HA
resource "aws_route_table_association" "ra-subnet-az1-mgmt-ha" {
  subnet_id      = aws_subnet.subnet-az1-mgmt-ha.id
  route_table_id = aws_route_table.rt-mgmt-ha.id
}

# Route table association subnet PUBLIC
resource "aws_route_table_association" "ra-subnet-az1-public" {
  subnet_id      = aws_subnet.subnet-az1-public.id
  route_table_id = aws_route_table.rt-public.id
}

# Route table association subnet SERVERS
resource "aws_route_table_association" "ra-subnet-az1-servers" {
  subnet_id      = aws_subnet.subnet-az1-servers.id
  route_table_id = aws_route_table.rt-servers.id
}

