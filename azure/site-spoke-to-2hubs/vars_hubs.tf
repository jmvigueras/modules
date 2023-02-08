// Default parameters for HUB1
variable "hub1" {
  type = map(string)
  default = {
    bgp-asn     = "65001"
    public-ip1  = "11.11.11.11"
    advpn-ip1   = "10.10.10.1"
    hck-srv-ip1 = "172.30.16.10"
    hck-srv-ip2 = "172.30.17.10"
    cidr        = "172.30.0.0/20"
    advpn-psk   = "secret-psk-key"
  }
}

// Default parameters for HUB2
variable "hub2" {
  type = map(string)
  default = {
    bgp-asn     = "65002"
    public-ip1  = "22.22.22.22"
    advpn-ip1   = "10.10.20.1"
    hck-srv-ip1 = "172.31.16.10"
    hck-srv-ip2 = "172.31.17.10"
    cidr        = "172.31.0.0/20"
    advpn-psk   = "secret-psk-key"
  }
}

// Default parameters for Site
variable "site" {
  type = map(string)
  default = {
    site_id   = "1"
    cidr      = "192.168.0.0/20"
    bgp-asn   = "65011"
    advpn-ip1 = "10.10.10.10"
    advpn-ip2 = "10.10.20.10"
  }
}

