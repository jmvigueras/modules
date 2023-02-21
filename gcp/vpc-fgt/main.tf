#------------------------------------------------------------------------------------------------------------
# Create VPCs Fortigate
# - VPC for MGMT and HA interface
# - VPC for Public interface
# - VPC for Private interface  
#------------------------------------------------------------------------------------------------------------
# Create MGMT-HA VPC
resource "google_compute_network" "vpc_mgmt" {
  name                    = "${var.prefix}-vpc-mgmt"
  auto_create_subnetworks = false
}
# Create public VPC
resource "google_compute_network" "vpc_public" {
  name                    = "${var.prefix}-vpc-public"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create private VPC
resource "google_compute_network" "vpc_private" {
  name                    = "${var.prefix}-vpc-private"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}

#------------------------------------------------------------------------------------------------------------
# Create subnets
# - VPC public: subnet_public, subnet_proxy
# - VPC private: subnet_private, subnet_bastion
# - VPC mgmt: subnet_mgmt
#------------------------------------------------------------------------------------------------------------
locals {
  subnet_public_cidr  = cidrsubnet(var.vpc-sec_cidr, 3, 0)
  subnet_proxy_cidr   = cidrsubnet(var.vpc-sec_cidr, 3, 1)
  subnet_private_cidr = cidrsubnet(var.vpc-sec_cidr, 3, 2)
  subnet_bastion_cidr = cidrsubnet(var.vpc-sec_cidr, 3, 3)
  subnet_mgmt_cidr    = cidrsubnet(var.vpc-sec_cidr, 3, 4)
}

### Public Subnet ###
resource "google_compute_subnetwork" "subnet_public" {
  name          = "${var.prefix}-subnet-public"
  region        = var.region
  network       = google_compute_network.vpc_public.name
  ip_cidr_range = local.subnet_public_cidr
}
### Proxy Subnet ###
resource "google_compute_subnetwork" "subnet_proxy" {
  name          = "${var.prefix}-subnet-proxy"
  region        = var.region
  network       = google_compute_network.vpc_public.name
  ip_cidr_range = local.subnet_proxy_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}
### Private Subnet ###
resource "google_compute_subnetwork" "subnet_private" {
  name          = "${var.prefix}-subnet-private"
  region        = var.region
  network       = google_compute_network.vpc_private.name
  ip_cidr_range = local.subnet_private_cidr
}
### Bastion Subnet ###
resource "google_compute_subnetwork" "subnet_bastion" {
  name          = "${var.prefix}-subnet-bastion"
  region        = var.region
  network       = google_compute_network.vpc_private.name
  ip_cidr_range = local.subnet_bastion_cidr
}
### HA MGMT SYNC Subnet ###
resource "google_compute_subnetwork" "subnet_mgmt" {
  name                     = "${var.prefix}-subnet-mgmt"
  region                   = var.region
  network                  = google_compute_network.vpc_mgmt.name
  ip_cidr_range            = local.subnet_mgmt_cidr
  private_ip_google_access = true
}

#------------------------------------------------------------------------------------------------------------
# Create firewalls rules
#------------------------------------------------------------------------------------------------------------
# Firewall Rule External MGMT
resource "google_compute_firewall" "allow-mgmt-fgt" {
  name    = "${var.prefix}-allow-mgmt-fgt"
  network = google_compute_network.vpc_mgmt.name

  allow {
    protocol = "all"
  }

  source_ranges = [var.admin_cidr]
  target_tags   = ["${var.prefix}-t-fwr-fgt-mgmt"]
}

# Firewall Rule External PUBLIC
resource "google_compute_firewall" "allow-public-fgt" {
  name    = "${var.prefix}-allow-public-fgt"
  network = google_compute_network.vpc_public.name

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
  network = google_compute_network.vpc_private.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-fgt-private"]
}

# Firewall Rule Internal Bastion
resource "google_compute_firewall" "allow-bastion-vm" {
  name    = "${var.prefix}-allow-bastion-vm"
  network = google_compute_network.vpc_private.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-bastion"]
}
