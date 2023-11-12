#---------------------------------------------------------------------------------------------------
# FGT-1 INSTANCE
# - FGT-1
# - Public VNIC
# - Private VNIC
#---------------------------------------------------------------------------------------------------
// Create FGT-1 instance
resource "oci_core_instance" "fgt_1" {
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-fgt-1"
  shape               = var.instance_shape

  /*  // Use shape for Flex VM instances
  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }
  */
  create_vnic_details {
    subnet_id        = var.fgt_subnet_ids["mgmt"]
    display_name     = "fgt-1-mgmt"
    assign_public_ip = true
    hostname_label   = "fgt-1"
    private_ip       = var.fgt_1_vnic_ips["mgmt"]
    nsg_ids          = [var.fgt_nsg_ids["mgmt"]]
  }
  source_details {
    source_type = "image"
    source_id   = local.fgt_image_id
  }
  metadata = {
    // ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(var.fgt_config_1)
  }
  timeouts {
    create = "60m"
  }
}
#---------------------------------------------------------------------------------------------------
# - FGT-1 Public VNIC
#---------------------------------------------------------------------------------------------------
// FGT-1 public VNIC: create VNIC
resource "oci_core_vnic_attachment" "fgt_1_vnic_public" {
  depends_on   = [oci_core_instance.fgt_1]
  instance_id  = oci_core_instance.fgt_1.id
  display_name = "fgt-1-public"

  create_vnic_details {
    subnet_id              = var.fgt_subnet_ids["public"]
    display_name           = "fgt-1-public"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.fgt_1_vnic_ips["public"]
    nsg_ids                = [var.fgt_nsg_ids["public"]]
  }
}
// FGT-1 public VNIC: create secondary private IP
resource "oci_core_private_ip" "fgt_1_vnic_public_ip_sec" {
  vnic_id        = element(oci_core_vnic_attachment.fgt_1_vnic_public.*.vnic_id, 0)
  display_name   = "fgt-1-public-sec"
  hostname_label = "fgt-1-public"
  ip_address     = var.fgt_1_ips["public"]
}
// FGT-1 public VNIC: create public IP attached to secondary IP
resource "oci_core_public_ip" "fgt_1_vnic_public_ip_sec" {
  compartment_id = var.compartment_ocid
  lifetime       = var.public_ip_lifetime
  display_name   = "fgt-1-public-sec"
  private_ip_id  = oci_core_private_ip.fgt_1_vnic_public_ip_sec.id
}
#---------------------------------------------------------------------------------------------------
# - FGT-1 Private VNIC
#---------------------------------------------------------------------------------------------------
// FGT-1 private VNIC: create VNIC
resource "oci_core_vnic_attachment" "fgt_1_vnic_private" {
  depends_on   = [oci_core_instance.fgt_1, oci_core_vnic_attachment.fgt_1_vnic_public]
  instance_id  = oci_core_instance.fgt_1.id
  display_name = "fgt-1-private"

  create_vnic_details {
    subnet_id              = var.fgt_subnet_ids["private"]
    display_name           = "fgt-1-private"
    assign_public_ip       = false
    skip_source_dest_check = true
    private_ip             = var.fgt_1_vnic_ips["private"]
    nsg_ids                = [var.fgt_nsg_ids["private"]]
  }
}
// FGT-1 public VNIC: create secondary IP
resource "oci_core_private_ip" "fgt_1_vnic_private_ip_sec" {
  vnic_id        = element(oci_core_vnic_attachment.fgt_1_vnic_private.*.vnic_id, 0)
  display_name   = "fgt-1-private-sec"
  hostname_label = "fgt-1-private"
  ip_address     = var.fgt_1_ips["private"]
}
#---------------------------------------------------------------------------------------------------
# - FGT-1 Data Volume
#---------------------------------------------------------------------------------------------------
// Create volume
resource "oci_core_volume" "fgt_1_vol_a" {
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  compartment_id      = var.compartment_ocid
  display_name        = "fgt-1-vol-a"
  size_in_gbs         = var.volume_size
}
// Attach volume
resource "oci_core_volume_attachment" "fgt_1_vol_a_attach" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.fgt_1.id
  volume_id       = oci_core_volume.fgt_1_vol_a.id
}
#---------------------------------------------------------------------------------------------------
# FGT-2 INSTANCE
# - FGT-2
# - Public VNIC
# - Private VNIC
#---------------------------------------------------------------------------------------------------
// Create FGT-2 instance
resource "oci_core_instance" "fgt_2" {
  availability_domain = data.oci_identity_availability_domain.ad_2.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-fgt-2"
  shape               = var.instance_shape

  /*  // Use shape for Flex VM instances
  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }
  */
  create_vnic_details {
    subnet_id        = var.fgt_subnet_ids["mgmt"]
    display_name     = "fgt-2-mgmt"
    assign_public_ip = true
    hostname_label   = "fgt-2"
    private_ip       = var.fgt_2_vnic_ips["mgmt"]
    nsg_ids          = [var.fgt_nsg_ids["mgmt"]]
  }
  source_details {
    source_type = "image"
    source_id   = local.fgt_image_id
  }
  metadata = {
    // ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(var.fgt_config_2)
  }
  timeouts {
    create = "60m"
  }
}
#---------------------------------------------------------------------------------------------------
# - FGT-2 Public VNIC
#---------------------------------------------------------------------------------------------------
// FGT-2 public VNIC: create VNIC
resource "oci_core_vnic_attachment" "fgt_2_vnic_public" {
  depends_on   = [oci_core_instance.fgt_2]
  instance_id  = oci_core_instance.fgt_2.id
  display_name = "fgt-2-public"

  create_vnic_details {
    subnet_id              = var.fgt_subnet_ids["public"]
    display_name           = "fgt-2-public"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.fgt_2_vnic_ips["public"]
    nsg_ids                = [var.fgt_nsg_ids["public"]]
  }
}
#---------------------------------------------------------------------------------------------------
# - FGT-2 Private VNIC
#---------------------------------------------------------------------------------------------------
// FGT-2 private VNIC: create VNIC
resource "oci_core_vnic_attachment" "fgt_2_vnic_private" {
  depends_on   = [oci_core_instance.fgt_2, oci_core_vnic_attachment.fgt_2_vnic_public]
  instance_id  = oci_core_instance.fgt_2.id
  display_name = "fgt-2-private"

  create_vnic_details {
    subnet_id              = var.fgt_subnet_ids["private"]
    display_name           = "fgt-2-private"
    assign_public_ip       = false
    skip_source_dest_check = true
    private_ip             = var.fgt_2_vnic_ips["private"]
    nsg_ids                = [var.fgt_nsg_ids["private"]]
  }
}
#---------------------------------------------------------------------------------------------------
# - FGT-2 Data Volume
#---------------------------------------------------------------------------------------------------
// Create volume
resource "oci_core_volume" "fgt_2_vol_a" {
  availability_domain = data.oci_identity_availability_domain.ad_2.name
  compartment_id      = var.compartment_ocid
  display_name        = "fgt-2-vol-a"
  size_in_gbs         = var.volume_size
}
// Attach volume
resource "oci_core_volume_attachment" "fgt_2_vol_a_attach" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.fgt_2.id
  volume_id       = oci_core_volume.fgt_2_vol_a.id
}