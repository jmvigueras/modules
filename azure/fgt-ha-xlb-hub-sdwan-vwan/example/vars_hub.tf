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

// BGP ASN for site FGT
variable "spoke_bgp-asn" {
  type    = string
  default = "65011"
}