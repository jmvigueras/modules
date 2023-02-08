variable "hub" {
  type = map(any)
  default = {
    bgp-asn    = "65001"
    public-ip1 = "11.11.11.11"
    advpn-ip1  = "10.10.10.1"
    cidr       = "172.30.0.0/20"
    advpn-psk  = "secret-psk-key"
    advpn-net  = "10.10.10.0/24"
  }
}

variable "site" {
  type = map(any)
  default = {
    cidr      = "192.168.0.0/24"
    bgp-asn   = "65011"
    advpn-ip1 = "10.10.10.10"
  }
}

