// Create Route Tables to FGT private IP
// (Used to direct traffic to FGT private IP - DRG, LPG or Bastion subnet)
resource "oci_core_route_table" "rt_to_fgt" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.fgt_vcn_id
  display_name   = "${var.prefix}-rt-to-fgt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_private_ip.fgt_1_vnic_private_ip_sec.id
  }
}
// Create Route Table attachment for subnet bastion
resource "oci_core_route_table_attachment" "rt_to_fgt_attach_bastion" {   
  subnet_id      = var.fgt_subnet_ids["bastion"]
  route_table_id = oci_core_route_table.rt_to_fgt.id
}
