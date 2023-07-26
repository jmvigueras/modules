// Create new VCN
resource "oci_core_virtual_network" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-fgt-vcn"
  dns_label      = "fgtvcn"
}
// Crate IGW
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}
// Create subnet MGMT
resource "oci_core_subnet" "subnet_mgmt" {
  cidr_block        = local.subnet_mgmt_cidr
  display_name      = "${var.prefix}-mgmt"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = oci_core_route_table.rt_mgmt.id
  security_list_ids = [oci_core_security_list.sl_mgmt.id]
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label         = "fgtmgmt"
}
// Create subnet Public
resource "oci_core_subnet" "subnet_public" {
  cidr_block        = local.subnet_public_cidr
  display_name      = "${var.prefix}-public"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = oci_core_route_table.rt_public.id
  security_list_ids = [oci_core_security_list.sl_public.id]
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label         = "fgtpublic"
}
// Create subnet Private
resource "oci_core_subnet" "subnet_private" {
  cidr_block        = local.subnet_private_cidr
  display_name      = "${var.prefix}-private"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  security_list_ids = [oci_core_security_list.sl_private.id]
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label         = "fgtprivate"
}
// Create subnet Bastion
resource "oci_core_subnet" "subnet_bastion" {
  cidr_block        = local.subnet_bastion_cidr
  display_name      = "${var.prefix}-bastion"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = oci_core_route_table.rt_public.id
  security_list_ids = [oci_core_security_list.sl_public.id]
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label         = "fgtbastion"
}

