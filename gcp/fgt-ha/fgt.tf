#------------------------------------------------------------------------------------------------------------
# FGT ACTIVE VM
#------------------------------------------------------------------------------------------------------------
# Create new random str
resource "random_string" "randon_str" {
  length  = 5
  special = false
  numeric = true
  upper   = false
}
# Create log disk for active
resource "google_compute_disk" "active-logdisk" {
  name = "${var.prefix}-fgt-1-log-disk-${random_string.randon_str.result}"
  size = 30
  type = "pd-standard"
  zone = var.zone1
}

# Create static active instance management ip
resource "google_compute_address" "active-mgmt-public-ip" {
  name         = "${var.prefix}-active-mgmt-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create static passive instance management ip
resource "google_compute_address" "active-public-ip" {
  name         = "${var.prefix}-active-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create FGTVM compute active instance
resource "google_compute_instance" "fgt-active" {
  name           = var.fgt_ha_fgsp ? "${var.prefix}-fgt-1" : "${var.prefix}-fgt-active"
  machine_type   = var.machine
  zone           = var.zone1
  can_ip_forward = "true"

  tags = ["${var.subnet_names["mgmt"]}-t-fwr", "${var.subnet_names["public"]}-t-fwr", "${var.subnet_names["private"]}-t-fwr"]

  boot_disk {
    initialize_params {
      image = var.license_type == "byol" ? data.google_compute_image.fgt_image_byol.self_link : data.google_compute_image.fgt_image_payg.self_link
    }
  }
  attached_disk {
    source = google_compute_disk.active-logdisk.name
  }
  network_interface {
    subnetwork = var.subnet_names["public"]
    network_ip = var.fgt-active-ni_ips["public"]
    access_config {
      nat_ip = google_compute_address.active-public-ip.address
    }
  }
  network_interface {
    subnetwork = var.subnet_names["private"]
    network_ip = var.fgt-active-ni_ips["private"]
  }
  network_interface {
    subnetwork = var.subnet_names["mgmt"]
    network_ip = var.fgt-active-ni_ips["mgmt"]
    access_config {
      nat_ip = google_compute_address.active-mgmt-public-ip.address
    }
  }
  metadata = {
    ssh-keys  = trimspace("${var.gcp-user_name}:${var.rsa-public-key}")
    user-data = var.fgt_config_1
    license   = fileexists("${var.license_file_1}") ? "${file(var.license_file_1)}" : null
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
  scheduling {
    preemptible       = false
    automatic_restart = true
  }
}

#------------------------------------------------------------------------------------------------------------
# FGT PASSIVE VM
#------------------------------------------------------------------------------------------------------------
locals {
  fgt-2_logdisk_name   = "${var.prefix}-fgt-2-disk-${random_string.randon_str.result}"
  fgt-2_mgmt_public_ip = var.fgt-passive-ni_ips != null && var.fgt_passive ? google_compute_address.passive-mgmt-public-ip.0.address : null
  fgt-2_public_ip      = var.fgt-passive-ni_ips != null && var.fgt_passive && var.config_fgsp ? google_compute_address.passive-public-ip.0.address : null
}

# Create log disk for passive
resource "google_compute_disk" "passive-logdisk" {
  count = var.fgt-passive-ni_ips != null && var.fgt_passive ? 1 : 0
  name  = "${var.prefix}-fgt-2-disk-${random_string.randon_str.result}"
  size  = 30
  type  = "pd-standard"
  zone  = var.zone2
}
# Create static passive instance management ip
resource "google_compute_address" "passive-mgmt-public-ip" {
  count        = var.fgt-passive-ni_ips != null && var.fgt_passive ? 1 : 0
  name         = "${var.prefix}-passive-mgmt-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}
# Create static passive instance public ip
resource "google_compute_address" "passive-public-ip" {
  count        = var.fgt-passive-ni_ips != null && var.fgt_passive && var.config_fgsp ? 1 : 0
  name         = "${var.prefix}-passive-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create FGT passive instance (FGCP cluster)
resource "google_compute_instance" "fgt-passive_fgcp" {
  count          = var.fgt-passive-ni_ips != null && var.fgt_passive && !var.config_fgsp ? 1 : 0
  name           = var.fgt_ha_fgsp ? "${var.prefix}-fgt-2" : "${var.prefix}-fgt-passive"
  machine_type   = var.machine
  zone           = var.zone2
  can_ip_forward = "true"

  tags = ["${var.subnet_names["mgmt"]}-t-fwr", "${var.subnet_names["public"]}-t-fwr", "${var.subnet_names["private"]}-t-fwr"]

  boot_disk {
    initialize_params {
      image = var.license_type == "byol" ? data.google_compute_image.fgt_image_byol.self_link : data.google_compute_image.fgt_image_payg.self_link
    }
  }
  attached_disk {
    source = local.fgt-2_logdisk_name
  }
  network_interface {
    subnetwork = var.subnet_names["public"]
    network_ip = var.fgt-passive-ni_ips["public"]
  }
  network_interface {
    subnetwork = var.subnet_names["private"]
    network_ip = var.fgt-passive-ni_ips["private"]
  }
  network_interface {
    subnetwork = var.subnet_names["mgmt"]
    network_ip = var.fgt-passive-ni_ips["mgmt"]
    access_config {
      nat_ip = local.fgt-2_mgmt_public_ip
    }
  }

  metadata = {
    user-data = var.fgt_config_2
    license   = fileexists("${var.license_file_2}") ? "${file(var.license_file_2)}" : null
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }
}

# Create FGT passive instance (FGCP cluster)
resource "google_compute_instance" "fgt-passive_fgsp" {
  count          = var.fgt-passive-ni_ips != null && var.fgt_passive && var.config_fgsp ? 1 : 0
  name           = var.fgt_ha_fgsp ? "${var.prefix}-fgt-2" : "${var.prefix}-fgt-passive"
  machine_type   = var.machine
  zone           = var.zone2
  can_ip_forward = "true"

  tags = ["${var.subnet_names["mgmt"]}-t-fwr", "${var.subnet_names["public"]}-t-fwr", "${var.subnet_names["private"]}-t-fwr"]

  boot_disk {
    initialize_params {
      image = var.license_type == "byol" ? data.google_compute_image.fgt_image_byol.self_link : data.google_compute_image.fgt_image_payg.self_link
    }
  }
  attached_disk {
    source = local.fgt-2_logdisk_name
  }
  network_interface {
    subnetwork = var.subnet_names["public"]
    network_ip = var.fgt-passive-ni_ips["public"]
    access_config {
      nat_ip = local.fgt-2_public_ip
    }
  }
  network_interface {
    subnetwork = var.subnet_names["private"]
    network_ip = var.fgt-passive-ni_ips["private"]
  }
  network_interface {
    subnetwork = var.subnet_names["mgmt"]
    network_ip = var.fgt-passive-ni_ips["mgmt"]
    access_config {
      nat_ip = local.fgt-2_mgmt_public_ip
    }
  }

  metadata = {
    user-data = var.fgt_config_2
    license   = fileexists("${var.license_file_2}") ? "${file(var.license_file_2)}" : null
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }
}


#------------------------------------------------------------------------------------------------------------
# Images
#------------------------------------------------------------------------------------------------------------
data "google_compute_image" "fgt_image_payg" {
  project = "fortigcp-project-001"
  filter  = "name=fortinet-fgtondemand-${var.fgt_version}*"
  //filter = "name=fortinet-fgtondemand-724-20230310*"
}

data "google_compute_image" "fgt_image_byol" {
  project = "fortigcp-project-001"
  filter  = "name=fortinet-fgt-${var.fgt_version}*"
  //filter = "name=fortinet-fgt-724-20230310*"
}