// Get Ubuntu images
data "oci_core_images" "vm_image" {
  compartment_id           = var.compartment_ocid
  shape                    = var.shape
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
}
// Get AD in compartment region
data "oci_identity_availability_domains" "region_ads" {
  compartment_id = var.compartment_ocid
}
// Create instance
resource "oci_core_instance" "vm" {
  display_name        = "${var.prefix}-vm-${var.sufix}"
  availability_domain = data.oci_identity_availability_domains.region_ads.availability_domains[var.region_ad].name
  compartment_id      = var.compartment_ocid
  shape               = var.shape
  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }
  source_details {
    source_id   = data.oci_core_images.vm_image.images[0].id
    source_type = "image"
  }
  create_vnic_details {
    subnet_id  = var.subnet_id
    // private_ip = var.private_ip
  }
  metadata = {
    ssh_authorized_keys = join("\n", var.authorized_keys)
    user_data           = base64encode(file("${path.module}/templates/user-data.tpl"))
  }
  /*
  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }
  */
}

