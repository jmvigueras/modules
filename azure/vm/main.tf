##################################################################
# VMs
# (Module will create as many VM as NI defined in vm_nis)
##################################################################
resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_ni_ids == null ? 0 : length(var.vm_ni_ids)
  name                  = "${var.prefix}-vm-${count.index + 1}"
  resource_group_name   = var.resourcegroup_name
  location              = var.location
  vm_size               = var.vm_size
  network_interface_ids = [var.vm_ni_ids[count.index]]

  storage_os_disk {
    name              = "${var.prefix}-disk-vm-${count.index + 1}"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-${count.index + 1}"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.lnx_custom_data.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage-account_endpoint
  }
}

data "template_file" "lnx_custom_data" {
  template = file("${path.module}/templates/customdata-lnx.tpl")

  vars = {
  }
}