output "Username" {
  value = var.adminusername
}

output "Password" {
  value = var.adminpassword
}

output "api_key" {
  value = random_string.api_key.result
}

output "advpn-ipsec-psk" {
  value = random_string.advpn-ipsec-psk.result
}