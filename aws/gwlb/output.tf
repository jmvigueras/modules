# Output
output "lb_target_group_arn" {
  value = aws_lb_target_group.gwlb_target-group.arn
}
output "lb_target_group_id" {
  value = aws_lb_target_group.gwlb_target-group.ud
}
output "gwlbe_ip" {
  value = aws_network_interface.gwlb_ni.*.private_ip
}
output "gwlbe_id" {
  value = aws_network_interface.gwlb_ni.*.id
}
output "gwlb_service-name" {
  value = aws_vpc_endpoint_service.gwlb_service.service_name
}