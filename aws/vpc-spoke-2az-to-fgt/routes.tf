#-------------------------------------------------------------------------------------------------------------
# VPC SPOKE Routes
# - Routes to VPC SEC if profided
# - GWLB endpoint creation
#-------------------------------------------------------------------------------------------------------------
# VPC peering to VPC-SEC
# - Create VPC peering with VPC-SEC if vpc-sec_id provided
resource "aws_vpc_peering_connection" "to-vpc-sec-1" {
  count       = var.vpc-sec_id != null ? length(var.vpc-spoke_cidr) : 0
  peer_vpc_id = var.vpc-sec_id
  vpc_id      = aws_vpc.vpc-spoke.id
  auto_accept = true

  tags = {
    Name = "${var.prefix}-sec-to-spoke"
  }
}
resource "aws_vpc_peering_connection" "to-vpc-sec-2" {
  count       = var.vpc-sec_id != null ? length(var.vpc-spoke_cidr) : 0
  peer_vpc_id = aws_vpc.vpc-spoke.id
  vpc_id      = var.vpc-sec_id
  auto_accept = true

  tags = {
    Name = "${var.prefix}-spoke-to-sec"
  }
}

# TableRoute to FGW
resource "aws_route_table" "rt-fgt" {
  count  = var.fgt-active-ni_id != null ? length(var.vpc-spoke_cidr) : 0
  vpc_id = aws_vpc.vpc-spoke.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.fgt-active-ni_id
  }
  route {
    cidr_block = var.admin_cidr
    gateway_id = aws_internet_gateway.igw-vpc-spoke.id
  }
  tags = {
    Name = "${var.prefix}-rt-fgt"
  }
}

# Route tables associations
# - Associate RT to FGT if provided
resource "aws_route_table_association" "ra-subnet-az1-vm-fgt" {
  count          = var.vpc-sec_id != null && var.fgt-active-ni_id != null ? length(var.vpc-spoke_cidr) : 0
  subnet_id      = aws_subnet.subnet-vpc-az1-vm.id
  route_table_id = aws_route_table.rt-fgt.id
}
resource "aws_route_table_association" "ra-subnet-az2-vm-fgt" {
  count          = var.vpc-sec_id != null && var.fgt-active-ni_id != null ? length(var.vpc-spoke_cidr) : 0
  subnet_id      = aws_subnet.subnet-vpc-az2-vm.id
  route_table_id = aws_route_table.rt-fgt.id
}
/*
# Create VPC endpoint GWLB
# - Create GWLB if GWLB service name provided
resource "aws_vpc_endpoint" "gwlbe" {
  count             = var.gwlb_service-name != null ? length(var.vpc-spoke_cidr) : 0
  service_name      = var.gwlb_service-name
  subnet_ids        = [aws_subnet.subnet-vpc-az1-gwlb.id, aws_subnet.subnet-vpc-az2-gwlb.id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpc-spoke.id
}
*/
