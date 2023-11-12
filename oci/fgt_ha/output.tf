output "fgt_1_id" {
  value = oci_core_instance.fgt_1.id
}

output "fgt_2_id" {
  value = oci_core_instance.fgt_2.id
}

output "fgt_1_public_ip_mgmt" {
  value = oci_core_instance.fgt_1.public_ip
}

output "fgt_2_public_ip_mgmt" {
  value = oci_core_instance.fgt_2.public_ip
}

output "fgt_1_public_ip_public" {
  value = oci_core_public_ip.fgt_1_vnic_public_ip_sec.ip_address
}

output "fgt_vcn_rt_to_fgt_id" {
  value = oci_core_route_table.rt_to_fgt.id
}