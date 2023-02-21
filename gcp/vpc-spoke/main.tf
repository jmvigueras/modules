#------------------------------------------------------------------------------------------------------------
# Create VPC SPOKE 
# - Create VPC
# - Create Subnet
# - Create Peering to private VPC
#------------------------------------------------------------------------------------------------------------
# Create SPOKE VPC
resource "google_compute_network" "vpc_spoke" {
  count                   = length(var.spoke-subnet_cidrs)
  name                    = "${var.prefix}-vpc-spoke-${count.index + 1}"
  auto_create_subnetworks = false
}

## Spoke Subnet ##
resource "google_compute_subnetwork" "subnet_spoke" {
  count         = length(var.spoke-subnet_cidrs)
  name          = "${google_compute_network.vpc_spoke[count.index].name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc_spoke[count.index].name
  ip_cidr_range = var.spoke-subnet_cidrs[count.index]
}

## Spoke peering to VPC private ##
resource "google_compute_network_peering" "vpc_spoke_peer-to-private_1" {
//  count                = var.fgt_vpc_self_link != null ? length(var.spoke-subnet_cidrs) : 0
  count                = length(var.spoke-subnet_cidrs)
  name                 = "${var.prefix}-peer-spoke-${count.index + 1}-to-private-1"
  network              = var.fgt_vpc_self_link
  peer_network         = google_compute_network.vpc_spoke[count.index].self_link
  export_custom_routes = true
}

resource "google_compute_network_peering" "vpc_spoke_peer-to-private_2" {
//  count                = var.fgt_vpc_self_link != null ? length(var.spoke-subnet_cidrs) : 0
  count                = length(var.spoke-subnet_cidrs)
  name                 = "${var.prefix}-peer-spoke-${count.index + 1}-to-private-2"
  network              = google_compute_network.vpc_spoke[count.index].self_link
  peer_network         = var.fgt_vpc_self_link
  import_custom_routes = true
}

# Firewall Rule Internal Bastion
resource "google_compute_firewall" "vpc_spoke_fw_allow-all" {
  count   = length(var.spoke-subnet_cidrs)
  name    = "${google_compute_network.vpc_spoke[count.index].name}-subnet-fwr-allow-all"
  network = google_compute_network.vpc_spoke[count.index].name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${google_compute_network.vpc_spoke[count.index].name}-subnet-t-fwr"]
}

