output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  value = var.admin_password
}

output "fgt_id" {
  value = azurerm_virtual_machine.fgt.id
}
