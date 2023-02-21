// Create Network Connectivity Center
resource "google_network_connectivity_hub" "ncc_hub" {
  name = "${var.prefix}-ncc"
  labels = {
    label-one = "${var.prefix}"
  }
}

#------------------------------------------------------------------------------------------------------------
# Create Cloud router in VPC private
#------------------------------------------------------------------------------------------------------------
// Create cloud router
resource "google_compute_router" "ncc_cloud-router" {
  name    = "${var.prefix}-cloud-router"
  network = var.vpc_name
  region  = var.region
  bgp {
    asn = var.ncc_bgp-asn
  }
}

// Create cloud router interfaces (reduntant interfaces)
resource "google_compute_router_interface" "ncc_cloud-router_nic-0" {
  name                = "nic-0"
  region              = var.region
  router              = google_compute_router.ncc_cloud-router.name
  subnetwork          = var.subnet_self_link
  private_ip_address  = var.ncc_ips[0]
  redundant_interface = google_compute_router_interface.ncc_cloud-router_nic-1.name
}
resource "google_compute_router_interface" "ncc_cloud-router_nic-1" {
  name               = "nic-1"
  region             = var.region
  router             = google_compute_router.ncc_cloud-router.name
  subnetwork         = var.subnet_self_link
  private_ip_address = var.ncc_ips[1]
}

#------------------------------------------------------------------------------------------------------------
# - Create Router Appliance - VPC private
# - Create FGT BGP session to Cloud Router - VPC private
#------------------------------------------------------------------------------------------------------------
// Associate Router Applicance to HUB vpc private
resource "google_network_connectivity_spoke" "hub_spoke_fgt" {
  name     = "${var.prefix}-hub-fgt"
  location = var.region

  hub = google_network_connectivity_hub.ncc_hub.id

  linked_router_appliance_instances {
    instances {
      virtual_machine = var.fgt_active_self_link
      ip_address      = var.fgt-active-ni_ip
    }
    instances {
      virtual_machine = var.fgt_passive_self_link
      ip_address      = var.fgt-passive-ni_ip
    }
    site_to_site_data_transfer = false
  }
}
// Create fortigate Active BGP peer to Cloud Router Router Appliance
resource "google_compute_router_peer" "router-private-peer_active_1" {
  depends_on                = [google_network_connectivity_spoke.hub_spoke_fgt]
  name                      = "${var.prefix}-router-private-peer-active-1"
  region                    = var.region
  router                    = google_compute_router.ncc_cloud-router.name
  interface                 = google_compute_router_interface.ncc_cloud-router_nic-0.name
  router_appliance_instance = var.fgt_active_self_link
  peer_asn                  = var.fgt_bgp-asn
  peer_ip_address           = var.fgt-active-ni_ip
}
resource "google_compute_router_peer" "router-private-peer_active_2" {
  depends_on                = [google_network_connectivity_spoke.hub_spoke_fgt]
  name                      = "${var.prefix}-router-private-peer-active-2"
  region                    = var.region
  router                    = google_compute_router.ncc_cloud-router.name
  interface                 = google_compute_router_interface.ncc_cloud-router_nic-1.name
  router_appliance_instance = var.fgt_active_self_link
  peer_asn                  = var.fgt_bgp-asn
  peer_ip_address           = var.fgt-active-ni_ip
}

// Create fortigate passive BGP peer to Cloud Router Router Appliance
resource "google_compute_router_peer" "router-private-peer_passive_1" {
  depends_on                = [google_network_connectivity_spoke.hub_spoke_fgt]
  count                     = var.fgt_passive ? 1 : 0
  
  name                      = "${var.prefix}-router-private-peer-passive-1"
  region                    = var.region
  router                    = google_compute_router.ncc_cloud-router.name
  interface                 = google_compute_router_interface.ncc_cloud-router_nic-0.name
  router_appliance_instance = var.fgt_passive_self_link
  peer_asn                  = var.fgt_bgp-asn
  peer_ip_address           = var.fgt-passive-ni_ip
}
resource "google_compute_router_peer" "router-private-peer_passive_2" {
  depends_on                = [google_network_connectivity_spoke.hub_spoke_fgt]
  count                     = var.fgt_passive ? 1 : 0
  
  name                      = "${var.prefix}-router-private-peer-passive-2"
  region                    = var.region
  router                    = google_compute_router.ncc_cloud-router.name
  interface                 = google_compute_router_interface.ncc_cloud-router_nic-1.name
  router_appliance_instance = var.fgt_passive_self_link
  peer_asn                  = var.fgt_bgp-asn
  peer_ip_address           = var.fgt-passive-ni_ip
}
