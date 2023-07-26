output "vcn_id" {
  value = oci_core_virtual_network.vcn.id 
}

output "subnet_ids" {
  value = {
    vm = oci_core_subnet.subnet_vm.id
  }
}

