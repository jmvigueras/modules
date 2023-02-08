###################################################################################
# - IMPORATANT - Update this variables with your wished scenario
###################################################################################
// FGT data for configure ADVPN
variable "hub" {
  type = map(any)
  default = {
    "id"        = "HubAazure"
    "bgp-asn"   = "65001"
    "advpn-net" = "10.10.10.0/24"
  }
}

// Details for vxlan connection to hub (simulated L2/MPLS)
variable "hub-peer_vxlan" {
  type = map(any)
  default = {
    "bgp-asn"    = "65002"  
    "public-ip1" = "11.11.11.11"
    "remote-ip1"  = "10.10.30.1"
    "local-ip1"  = "10.10.30.2"
  }
}

// BGP ASN for site FGT
variable "spoke_bgp-asn" {
  type    = string
  default = "65011"
}