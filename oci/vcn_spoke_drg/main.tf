// Create new VCN
resource "oci_core_virtual_network" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-spoke-vcn-${var.sufix}"
  dns_label      = "spokevcn${var.sufix}"
}
// Crate IGW
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}
// Create subnet Public
resource "oci_core_subnet" "subnet_vm" {
  cidr_block        = cidrsubnet(var.vcn_cidr, 1, 0)
  display_name      = "${var.prefix}-vm"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = var.admin_cidr != "0.0.0.0/0" ? element(oci_core_route_table.rt_to_drg_default.*.id, 0) : element(oci_core_route_table.rt_to_drg_rfc1918.*.id, 0)
  security_list_ids = [oci_core_security_list.sl_vm.id]
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label         = "spokesubnetvm${var.sufix}"
}
// Create Spoke VCN attachment
resource "oci_core_drg_attachment" "drg_attach_vcn_spoke" {
    drg_id             = var.drg_id
    display_name       = "${var.prefix}-drg-attach-vcn-spoke-${var.sufix}"
    drg_route_table_id = var.drg_rt_id

    network_details {
        id   = oci_core_virtual_network.vcn.id
        type = "VCN"
    }
}
#------------------------------------------------------------------------------------------------------------
# Create Route Tables to DRG
#------------------------------------------------------------------------------------------------------------
// Create Route Table if admin_cidr is not  0.0.0.0/0
resource "oci_core_route_table" "rt_to_drg_default" {
  count = var.admin_cidr != "0.0.0.0/0" ? 1 : 0

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-rt-to-drg-default"

  route_rules {
    destination       = var.admin_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.drg_id
  }
}
// Create Route Table if admin_cidr is 0.0.0.0/0
resource "oci_core_route_table" "rt_to_drg_rfc1918" {
  count = var.admin_cidr == "0.0.0.0/0" ? 1 : 0

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-rt-to-drg-rfc1918"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
  route_rules {
    destination       = "192.168.0.0/16"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.drg_id
  }
  route_rules {
    destination       = "172.16.0.0/12"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.drg_id
  }
  route_rules {
    destination       = "10.0.0.0/8"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.drg_id
  }
}
#----------------------------------------------------------------------------------------
# VM Security list
#----------------------------------------------------------------------------------------
resource "oci_core_security_list" "sl_vm" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-sl-vm"
  
  // Allow all traffic ingress
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
  // Allow all traffic egress
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}