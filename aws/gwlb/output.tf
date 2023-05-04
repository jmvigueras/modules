# Output
output "lb_target_group_arn" {
  value = aws_lb_target_group.gwlb_target-group.arn
}
output "lb_target_group_id" {
  value = aws_lb_target_group.gwlb_target-group.id
}
output "gwlbe_ips" {
  value = data.aws_network_interface.gwlb_ni.*.private_ip
}
output "gwlbe_ids" {
  value = data.aws_network_interface.gwlb_ni.*.id
}
output "gwlb_service_name" {
  value = aws_vpc_endpoint_service.gwlb_service.service_name
}
output "gwlb_endpoints" {
  value = aws_vpc_endpoint.gwlb_endpoints.*.id
}