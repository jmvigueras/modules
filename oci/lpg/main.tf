#------------------------------------------------------------------------------------------------------------
# Create LPG FGT VCN
#------------------------------------------------------------------------------------------------------------
// Create Local Peering Gateway
resource "oci_core_local_peering_gateway" "fgt_vcn_lpg" {
    compartment_id = var.compartment_ocid
    display_name   = "${var.prefix}-fgt-lpg"
    vcn_id         = var.fgt_vcn_id

    route_table_id = var.fgt_vcn_rt_to_fgt_id
}
// Create Route Table Private in FGT VCN (private subnet)
resource "oci_core_route_table" "fgt_rt_private" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.fgt_vcn_id
  display_name   = "${var.prefix}-rt-private-lpd"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.fgt_vcn_lpg.id
  }
}
// Assign Route Table to private subnet
resource "oci_core_route_table_attachment" "fgt_rt_private_attachment" {   
  subnet_id      = var.fgt_subnet_ids["private"]
  route_table_id = oci_core_route_table.fgt_rt_private.id
}