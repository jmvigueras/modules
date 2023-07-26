// Create DRG
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-drg"
}
// Create Route Tables
resource "oci_core_drg_route_table" "drg_rt_pre_inspection" {
    drg_id       = oci_core_drg.drg.id
    display_name = "${var.prefix}-drg-pre-inspection"
}
resource "oci_core_drg_route_table" "drg_rt_post_inspection" {
    drg_id       = oci_core_drg.drg.id
    display_name = "${var.prefix}-drg-post-inspection"

    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg_route_distribution.id
}
// Create Route Distribution
resource "oci_core_drg_route_distribution" "drg_route_distribution" {
    drg_id            = oci_core_drg.drg.id
    display_name      = "${var.prefix}-drg-import-all"
    distribution_type = "IMPORT"
}
// Create Route Distribution Statement
resource "oci_core_drg_route_distribution_statement" "drg_route_distribution_statement" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg_route_distribution.id
    action = "ACCEPT"
    match_criteria {
      match_type = "MATCH_ALL"
    }
    priority = "1"
}
#------------------------------------------------------------------------------------------------------------
# Create attachments to DRG FGT VCN
#------------------------------------------------------------------------------------------------------------
// Create FGT VCN attachment
resource "oci_core_drg_attachment" "drg_attach_vcn_fgt" {
    drg_id             = oci_core_drg.drg.id
    display_name       = "${var.prefix}-drg-attach-vcn-fgt"
    drg_route_table_id = oci_core_drg_route_table.drg_rt_post_inspection.id

    network_details {
        id = var.fgt_vcn_id
        type = "VCN"
        route_table_id = var.fgt_vcn_rt_drg_id
    }
}
// Create static route in pre-inspection route table (if FGT VCN id is provided)
resource "oci_core_drg_route_table_route_rule" "drg_rt_pre_inspection_rule" {
    drg_route_table_id = oci_core_drg_route_table.drg_rt_pre_inspection.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.drg_attach_vcn_fgt.id
}
// Create Route Table Private in FGT VCN (private subnet)
resource "oci_core_route_table" "fgt_rt_private" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.fgt_vcn_id
  display_name   = "${var.prefix}-rt-private-drg"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.drg.id
  }
}
// Assign Route Table to private subnet
resource "oci_core_route_table_attachment" "fgt_rt_private_attachment" {   
  subnet_id      = var.fgt_subnet_ids["private"]
  route_table_id = oci_core_route_table.fgt_rt_private.id
}
