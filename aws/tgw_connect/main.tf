# Create TGW connect attachnment
# - Create attachement to vpc FGT
# - Create peer to FGT active
# - Create peer to FGT passive
resource "aws_ec2_transit_gateway_connect" "tgw-connect-att-vpc-fgt" {
  transport_attachment_id = var.vpc_tgw-att_id
  transit_gateway_id      = var.tgw_id
  tags = {
    Name = "${var.prefix}-tgw-att-connect"
  }
}
# Create TGW connect peer active
resource "aws_ec2_transit_gateway_connect_peer" "tgw-connect-att-vpc-fgt_peer" {
  count                         = length(var.peer_ip)
  bgp_asn                       = var.peer_bgp-asn
  peer_address                  = var.peer_ip[count.index]
  transit_gateway_address       = cidrhost(var.tgw_cidr[0], 10 + count.index)
  inside_cidr_blocks            = [var.tgw_inside_cidr[count.index]]
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.tgw-connect-att-vpc-fgt.id
}

# Create route propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-connect-att-vpc-fgt_propagation" {
  count                          = length(var.rt_propagation_id)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.tgw-connect-att-vpc-fgt.id
  transit_gateway_route_table_id = var.rt_propagation_id[count.index]
}