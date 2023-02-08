output "hub-fgt" {
  value     = {
    "url"           = "https://${aws_eip.eip-fgt_mgmt.public_ip}:${var.admin_port}"
    "ip"            = aws_eip.eip-fgt_mgmt.public_ip
    "admin_port"    = var.admin_port
    "api-token"     = random_string.api_key.result
    "username"      = "admin"
    "password"      = aws_instance.fgt.id
  }
}