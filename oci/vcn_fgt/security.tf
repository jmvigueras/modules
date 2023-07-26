#----------------------------------------------------------------------------------------
# NSG
# - MGMT 
# - Public 
# - Private
# - Bastion
#----------------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------------
# - MGTM NSG
#----------------------------------------------------------------------------------------
// Network Security Group
resource "oci_core_network_security_group" "nsg_mgmt" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = "${var.prefix}-nsg-mgmt"
}
// Security list
resource "oci_core_network_security_group_security_rule" "nsg_sl_mgmt_ha_1" {
  network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
  
  description = "Allow all traffic from FGT subnet"
  direction   = "INGRESS"
  source_type = "NETWORK_SECURITY_GROUP"
  protocol    = "all"
  source      = oci_core_network_security_group.nsg_mgmt.id
}
resource "oci_core_network_security_group_security_rule" "nsg_sl_mgmt_admin_1" {
  network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
  
  description = "Allow https (custom port) from admin cidr"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "6" // tcp
  source      = var.admin_cidr
  tcp_options {
    destination_port_range {
      max = var.admin_port
      min = var.admin_port
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_sl_mgmt_admin_2" {
  network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
  
  description = "Allow SSH from admin cidr"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "6" // tcp
  source      = var.admin_cidr
  tcp_options {
    destination_port_range {
      max = "22"
      min = "22"
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_sl_mgmt_admin_3" {
  network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
  
  description = "Allow HTTPs from admin cidr"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "6" // tcp
  source      = var.admin_cidr
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_sl_mgmt_admin_4" {
  network_security_group_id = oci_core_network_security_group.nsg_mgmt.id
  
  description = "Allow ICMP"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "1"
  source      = "0.0.0.0/0"
}
#----------------------------------------------------------------------------------------
# - Public NSG
#----------------------------------------------------------------------------------------
// Network Security Group
resource "oci_core_network_security_group" "nsg_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-nsg-public"
}
// Security list
resource "oci_core_network_security_group_security_rule" "nsg_sl_public_1" {
  network_security_group_id = oci_core_network_security_group.nsg_public.id
  
  description = "Allow all"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "all"
  source      = "0.0.0.0/0"
}
#----------------------------------------------------------------------------------------
# - Private Security list
#----------------------------------------------------------------------------------------
// Network Security Group
resource "oci_core_network_security_group" "nsg_private" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = "${var.prefix}-nsg-private"
}
// Security list
resource "oci_core_network_security_group_security_rule" "nsg_sl_private_1" {
  network_security_group_id = oci_core_network_security_group.nsg_private.id
  
  description = "Allow all"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "all"
  source      = "0.0.0.0/0"
}
#----------------------------------------------------------------------------------------
# - Bastion NSG
#----------------------------------------------------------------------------------------
// Network Security Group
resource "oci_core_network_security_group" "nsg_bastion" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = "${var.prefix}-nsg-bastion"
}
// Security list
resource "oci_core_network_security_group_security_rule" "nsg_bastion_1" {
  network_security_group_id = oci_core_network_security_group.nsg_bastion.id
  
  description = "Allow all"
  direction   = "INGRESS"
  source_type = "CIDR_BLOCK"
  protocol    = "all"
  source      = "0.0.0.0/0"
}

#----------------------------------------------------------------------------------------
# Security List
# - MGMT 
# - Public 
# - Private
# - Bastion
#----------------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------------
# - MGTM Security List
#----------------------------------------------------------------------------------------
resource "oci_core_security_list" "sl_mgmt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-sl-mgmt"

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
#----------------------------------------------------------------------------------------
# - Public Security list
#----------------------------------------------------------------------------------------
resource "oci_core_security_list" "sl_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-sl-public"

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
#----------------------------------------------------------------------------------------
# - Private Security list
#----------------------------------------------------------------------------------------
resource "oci_core_security_list" "sl_private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.prefix}-sl-private"

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
#----------------------------------------------------------------------------------------
# - Bastion Security List
#----------------------------------------------------------------------------------------
resource "oci_core_security_list" "sl_bastion" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = "${var.prefix}-sl-bastion"

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