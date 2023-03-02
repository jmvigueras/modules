#-----------------------------------------------------------------------------------
# Predefined variables for HA
# - config_fgcp   = true (default)
# - confgi_fgsp   = false (default)
#-----------------------------------------------------------------------------------
variable "config_fgcp" {
  type    = bool
  default = false
}
variable "config_fgsp" {
  type    = bool
  default = false
}

variable "config_ha_port" {
  type    = bool
  default = false
}

#-----------------------------------------------------------------------------------
# Default BGP configuration
#-----------------------------------------------------------------------------------
variable "bgp-asn_default" {
  type    = string
  default = "65000"
}

#-----------------------------------------------------------------------------------
# Predefined variables for spoke config
# - config_spoke   = true (default) 
#-----------------------------------------------------------------------------------
variable "config_spoke" {
  type    = bool
  default = false
}
// Default parameters to configure a site
variable "spoke" {
  type = map(any)
  default = {
    id      = "spoke"
    cidr    = "192.168.0.0/24"
    bgp-asn = "65011"
  }
}
// Details to crate VPN connections
variable "hubs" {
  type = list(map(string))
  default = [
    {
      id                = "HUB"
      bgp-asn           = "65000"
      public-ip         = "11.11.11.11"
      hub-ip            = "172.20.30.1"
      site-ip           = "172.20.30.10" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = "172.20.30.1"
      vpn_psk           = "secret"
      cidr              = "172.20.30.0/24"
      ike-version       = "2"
      network_id        = "1"
      dpd-retryinterval = "5"
    }
  ]
}

#-----------------------------------------------------------------------------------
# Predefined variables for HUB
# - config_hub   = false (default) 
# - config_vxlan = false (default)
#-----------------------------------------------------------------------------------
variable "config_hub_public" {
  type    = bool
  default = false
}
variable "config_hub_private" {
  type    = bool
  default = false
}
variable "config_hub" {
  type    = bool
  default = false
}
// Variable to create a a VPN HUB public interface
variable "hub" {
  type = list(map(string))
  default = [
    {
      id                = "HUB"
      bgp-asn_hub       = "65000"
      bgp-asn_spoke     = "65000"
      vpn_cidr          = "10.1.1.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike-version       = "2"
      network_id        = "1"
      dpd-retryinterval = "5"
      mode-cfg          = true
      vpn_port          = "public"
    },
    {
      id                = "HUB"
      bgp-asn_hub       = "65000"
      bgp-asn_spoke     = "65000"
      vpn_cidr          = "10.1.10.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike-version       = "2"
      network_id        = "1"
      dpd-retryinterval = "5"
      mode-cfg          = true
      vpn_port          = "private"
    }
  ]
}
// Variable to create a a VPN HUB public interface
variable "hub_public" {
  type = map(any)
  default = {
    id                = "HUB"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.1.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.30.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
}
// Variable to create a a VPN HUB
variable "hub_private" {
  type = map(any)
  default = {
    id                = "HUB"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.30.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
}

variable "vpn_public_name" {
  type    = string
  default = "vpn-port1"
}

variable "vpn_private_name" {
  type    = string
  default = "vpn-port2"
}

variable "config_vxlan" {
  type    = bool
  default = false
}
variable "hub_peer_vxlan_name" {
  type    = string
  default = "vxlan" //must be less than 9 caracters
}
variable "hub_peer_vxlan" {
  type = list(map(string))
  default = [
    {
      bgp-asn     = "65000"
      external-ip = "20.216.155.67"
      remote-ip   = "10.0.3.2"
      local-ip    = "10.0.3.1"
      vni         = "1100"
      vxlan_port  = "public"
    },
    {
      bgp-asn     = "65000"
      external-ip = "172.30.0.106"
      remote-ip   = "10.0.30.2"
      local-ip    = "10.0.30.1"
      vni         = "1100"
      vxlan_port  = "private"
    }
  ]
}


#-----------------------------------------------------------------------------------
# Predefined variables to vHUB connection
# - config_vhub   = false (default) 
#-----------------------------------------------------------------------------------
variable "config_vhub" {
  type    = bool
  default = false
}
variable "vhub_bgp-asn" {
  type    = list(string)
  default = ["65515"]
}
// Defualt value for vHUB RouteServer
variable "vhub_peer" {
  type    = list(string)
  default = ["10.0.252.68", "10.0.252.69"]
}

#-----------------------------------------------------------------------------------
# Predefined variables to Azure Route Server
# - config_ars   = false (default) 
#-----------------------------------------------------------------------------------
variable "config_ars" {
  type    = bool
  default = false
}
variable "rs_bgp-asn" {
  type    = list(string)
  default = ["65515"]
}
// Defalut values for Azure Route Server
variable "rs_peer" {
  type = list(list(string))
  default = [
    ["172.30.100.132", "172.30.100.133"],
    ["172.30.101.132", "172.30.101.133"]
  ]
}

#-----------------------------------------------------------------------------------
# Predefined variables for GWLB (VXLAN Azure)
# - config_gwlb-vxlan = false (default) 
#-----------------------------------------------------------------------------------
variable "config_gwlb-vxlan" {
  type    = bool
  default = false
}
variable "gwlb_vxlan" {
  type = map(string)
  default = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
  }
}
variable "gwlb_ip" {
  type    = string
  default = "172.30.3.15"
}


#-----------------------------------------------------------------------------------
# Predefined variables for FMG 
# - config_fmg = false (default) 
#-----------------------------------------------------------------------------------
variable "config_fmg" {
  type    = bool
  default = false
}

variable "fmg_ip" {
  type    = string
  default = ""
}

variable "fmg_sn" {
  type    = string
  default = ""
}

variable "fmg_interface-select-method" {
  type    = string
  default = ""
}

variable "fmg_fgt-1_source-ip" {
  type    = string
  default = ""
}

variable "fmg_fgt-2_source-ip" {
  type    = string
  default = ""
}

#-----------------------------------------------------------------------------------
# Predefined variables for FAZ 
# - config_faz = false (default) 
#-----------------------------------------------------------------------------------
variable "config_faz" {
  type    = bool
  default = false
}

variable "faz_ip" {
  type    = string
  default = ""
}

variable "faz_sn" {
  type    = string
  default = ""
}

variable "faz_interface-select-method" {
  type    = string
  default = ""
}

variable "faz_fgt-1_source-ip" {
  type    = string
  default = ""
}

variable "faz_fgt-2_source-ip" {
  type    = string
  default = ""
}


#-----------------------------------------------------------------------------------
variable "subscription_id" {
  type    = string
  default = ""
}
variable "client_id" {
  type    = string
  default = ""
}
variable "client_secret" {
  type    = string
  default = ""
}
variable "tenant_id" {
  type    = string
  default = ""
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "admin_port" {
  type    = string
  default = "8443"
}

variable "api_key" {
  type    = string
  default = null
}

variable "fgt_passive" {
  type    = bool
  default = false
}

variable "fgt_passive_extra-config" {
  type    = string
  default = ""
}

variable "fgt_active_extra-config" {
  type    = string
  default = ""
}

variable "vpc-spoke_cidr" {
  type    = list(string)
  default = null
}

variable "fgt-active-ni_ips" {
  type    = map(string)
  default = null
}

variable "fgt-passive-ni_ips" {
  type    = map(string)
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
}

variable "ports" {
  type = map(string)
  default = {
    public  = "port1"
    private = "port2"
    mgtm    = "port3"
    ha_port = "port3"
  }
}

variable "public_port" {
  type    = string
  default = "port1"
}
variable "private_port" {
  type    = string
  default = "port2"
}
variable "mgmt_port" {
  type    = string
  default = "port3"
}
variable "ha_port" {
  type    = string
  default = "port3"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

// license file for the active fgt
variable "license_file_1" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license1.lic"
}

// license file for the passive fgt
variable "license_file_2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "./licenses/license2.lic"
}

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
  type    = string
  default = null
}