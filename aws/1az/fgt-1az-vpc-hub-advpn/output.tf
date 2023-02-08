output "hub-fgt" {
  value     = {
    mgmt_url      = "https://${aws_eip.eip-fgt_mgmt.public_ip}:${var.admin_port}"
    admin_port    = var.admin_port
    api-token     = random_string.api_key.result
    username      = "admin"
    password      = aws_instance.fgt.id
    advpn_psk     = var.hub_advpn_psk
    advpn_pip     = aws_eip.eip-fgt_public.public_ip
  }
}

output "eni-server" {
  value = {
    "id" = aws_network_interface.ni-server-port1.id
    "ip" = aws_network_interface.ni-server-port1.private_ip
  }
}

output "key-pair" {
  value = var.key-pair_name != null ? var.key-pair_name : aws_key_pair.fgt-vpc-hub-kp[0].key_name
}