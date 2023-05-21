##################################################################
# VMs
# (Module will create as many VM as NI defined in vm_nis)
##################################################################
# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.vm_ni_ids == null ? 0 : length(var.vm_ni_ids)
  name                  = "${var.prefix}-vm-${count.index + 1}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [var.vm_ni_ids[count.index]]

  os_disk {
    name                 = "${var.prefix}-disk-vm-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  computer_name                   = "${var.prefix}-vm-${count.index + 1}"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = trimspace(var.rsa-public-key)
  }

  boot_diagnostics {
    storage_account_uri = var.storage-account_endpoint
  }
}

data "template_file" "lnx_custom_data" {
  template = file("${path.module}/templates/user-data.tpl")
}