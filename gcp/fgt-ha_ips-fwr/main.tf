#------------------------------------------------------------------------------------------------------------
# Create firewalls rules
#------------------------------------------------------------------------------------------------------------
# Firewall Rule External MGMT
resource "google_compute_firewall" "allow-mgmt-fgt" {
  name    = "${var.prefix}-allow-mgmt-fgt"
  network = var.vpc_names["mgmt"]

  allow {
    protocol = "all"
  }

  source_ranges = [var.admin_cidr]
  target_tags   = ["${var.prefix}-t-fwr-fgt-mgmt"]
}

# Firewall Rule External PUBLIC
resource "google_compute_firewall" "allow-public-fgt" {
  name    = "${var.prefix}-allow-public-fgt"
  network = var.vpc_names["public"]

  allow {
    protocol = "udp"
    ports    = ["500", "4500", "4789", "${var.backend-probe_port}"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8000", "${var.backend-probe_port}"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-fgt-public"]
}

# Firewall Rule Internal FGT PRIVATE
resource "google_compute_firewall" "allow-private-fgt" {
  name    = "${var.prefix}-allow-private-fgt"
  network = var.vpc_names["private"]

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-fgt-private"]
}

# Firewall Rule Internal Bastion
resource "google_compute_firewall" "allow-bastion-vm" {
  name    = "${var.prefix}-allow-bastion-vm"
  network = var.vpc_names["private"]

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-bastion"]
}
