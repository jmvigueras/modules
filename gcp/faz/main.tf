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
# Create log disk for faz
resource "google_compute_disk" "faz-logdisk" {
  name = "${var.prefix}-faz-log-disk-${random_string.randon_str.result}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

# Create static cluster ip
resource "google_compute_address" "faz-public-ip" {
  name         = "${var.prefix}-faz-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create FGTVM compute faz instance
resource "google_compute_instance" "faz" {
  name         = "${var.prefix}-faz"
  machine_type = var.machine
  zone         = var.zone

  tags = ["${var.prefix}-t-fwr-fgt-mgmt", "${var.prefix}-t-fwr-fgt-public", "${var.prefix}-t-fwr-bastion", "${var.subnet_names["private"]}-t-route", "${var.subnet_names["private"]}-t-fwr"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.faz_image_byol.self_link
    }
  }
  attached_disk {
    source = google_compute_disk.faz-logdisk.name
  }
  network_interface {
    subnetwork = var.subnet_names["public"]
    network_ip = var.faz_ni_ips["public"]
    access_config {
      nat_ip = google_compute_address.faz-public-ip.address
    }
  }
  network_interface {
    subnetwork = var.subnet_names["private"]
    network_ip = var.faz_ni_ips["private"]
  }
  metadata = {
    ssh-keys  = trimspace("${var.gcp-user_name}:${var.rsa-public-key}")
    user-data = data.template_file.faz_config.rendered
    license   = fileexists("${var.license_file}") ? "${file(var.license_file)}" : null
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
  scheduling {
    preemptible       = false
    automatic_restart = false
  }
}

#------------------------------------------------------------------------------------------------------------
# user-date template
#------------------------------------------------------------------------------------------------------------
data "template_file" "faz_config" {
  template = file("${path.module}/templates/faz.conf")
  vars = {
    faz_id           = "${var.prefix}-faz"
    type             = var.license_type
    license_file     = var.license_file
    admin_username   = var.admin_username
    rsa-public-key   = trimspace(var.rsa-public-key)
    public_port      = var.public_port
    public_ip        = var.faz_ni_ips["public"]
    public_mask      = cidrnetmask(var.subnet_cidrs["public"])
    public_gw        = cidrhost(var.subnet_cidrs["public"], 1)
    private_port     = var.private_port
    private_ip       = var.faz_ni_ips["private"]
    private_mask     = cidrnetmask(var.subnet_cidrs["private"])
    private_gw       = cidrhost(var.subnet_cidrs["private"], 1)
    faz_extra-config = var.faz_extra-config
  }
}

#------------------------------------------------------------------------------------------------------------
# Images
#------------------------------------------------------------------------------------------------------------
data "google_compute_image" "faz_image_byol" {
  project = "fortigcp-project-001"
  filter  = "name=fortinet-faz-${var.faz_version}*"
}