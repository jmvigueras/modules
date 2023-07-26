output "vm" {
  value = {
    id        = oci_core_instance.vm.id
    public_ip = oci_core_instance.vm.public_ip
  }
}


