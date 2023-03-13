output "fmg_id" {
  value = azurerm_virtual_machine.fmg.id
}

output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  value = var.admin_password
}