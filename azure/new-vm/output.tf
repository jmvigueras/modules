output "vm_username" {
  value = var.admin_username
}

output "vm_password" {
  value = var.admin_password
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.*.name
}

output "vm" {
  value = {
    vm_name    = azurerm_linux_virtual_machine.vm.*.name
    username   = var.admin_username
    password   = var.admin_password
  }
}