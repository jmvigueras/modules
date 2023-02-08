#------------------------------------------------------------------------------------------------------------
# TRANSIT GATEWAY
# - Create TGW
# - Create RouteTables
#------------------------------------------------------------------------------------------------------------
# Create TGW
resource "aws_ec2_transit_gateway" "tgw" {
  description                 = "${var.prefix} TGW"
  transit_gateway_cidr_blocks = var.tgw_cidr
  amazon_side_asn             = var.tgw_bgp-asn
  tags = {
    Name = "${var.prefix}-tgw"
  }
}
# Create Route Tables
# - Spoke Route Table 
# - N-S Route Table (FGT cluster VPC)
# - E-W Route Table (FGT cluster VPC)
resource "aws_ec2_transit_gateway_route_table" "rt-vpc-spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.prefix}-rt-vpc-spoke"
  }
}
resource "aws_ec2_transit_gateway_route_table" "rt-vpc-sec-N-S" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.prefix}-rt-vpc-sec-N-S"
  }
}
resource "aws_ec2_transit_gateway_route_table" "rt-vpc-sec-E-W" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.prefix}-rt-vpc-sec-E-W"
  }
}


