#----------------------------------------------------------------------------------------
# ROUTE TABLES
# - MGMT Subnet
# - Public Subnet
# - Private Subnet
# - Bastion Subnet
#----------------------------------------------------------------------------------------
// MGMT Route Table
resource "oci_core_route_table" "rt_mgmt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-rt-mgmt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}
// Public Route Table
resource "oci_core_route_table" "rt_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-rt-public"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}