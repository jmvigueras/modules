# Output
output "rt_default_id" {
  value = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}
output "rt_vpc-spoke_id" {
  value = aws_ec2_transit_gateway_route_table.rt-vpc-spoke.id
}
output "rt-vpc-sec-N-S_id" {
  value = aws_ec2_transit_gateway_route_table.rt-vpc-sec-N-S.id
}
output "rt-vpc-sec-E-W_id" {
  value = aws_ec2_transit_gateway_route_table.rt-vpc-sec-E-W.id
}
output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}
