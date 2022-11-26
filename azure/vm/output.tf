output "vm_username" {
  value = var.adminusername
}

output "vm_password" {
  value = var.adminpassword
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.*.name
}

