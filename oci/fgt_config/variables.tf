#-----------------------------------------------------------------------------------
# Predefined variables for HA
# - config_fgcp   = false (default)
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
#-----------------------------------------------------------------------------------
# Default BGP configuration
#-----------------------------------------------------------------------------------
variable "bgp_asn_default" {
  type    = string
  default = "65000"
}
#-----------------------------------------------------------------------------------
# Predefined variables for spoke config
# - config_spoke   = false (default) 
#-----------------------------------------------------------------------------------
variable "config_spoke" {
  type    = bool
  default = false
}
// Default parameters to configure a site
variable "spoke" {
  type = map(any)
  default = {
    id      = "fgt"
    cidr    = "192.168.0.0/24"
    bgp_asn = "65000"
  }
}
// Details to crate VPN connections
variable "hubs" {
  type = list(map(string))
  default = [
    {
      id                = "HUB"
      bgp_asn           = "65000"
      external_ip       = "11.11.11.11"
      hub_ip            = "172.20.30.1"
      site_ip           = "172.20.30.10" // set to "" if VPN mode_cfg is enable
      hck_ip            = "172.20.30.1"
      vpn_psk           = "secret"
      cidr              = "172.20.30.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      sdwan_port        = "public"
    }
  ]
}
#-----------------------------------------------------------------------------------
# Predefined variables for HUB
# - config_hub   = false (default) 
# - config_vxlan = false (default)
#-----------------------------------------------------------------------------------
variable "config_hub" {
  type    = bool
  default = false
}
// Variable to create VPN HUB
variable "hub" {
  type = list(map(string))
  default = [
    {
      id                = "HUB"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.1.1.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    },
    {
      id                = "HUB"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.1.10.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "private"
    }
  ]
}
// Boolean to configure vxlan
variable "config_vxlan" {
  type    = bool
  default = false
}
// Details for vxlan connection to hub (simulated L2/MPLS)
variable "hub-peer_vxlan" {
  type = map(string)
  default = {
    bgp-asn   = "65000"
    public-ip = "" // leave in blank if you don't know public IP jet
    remote-ip = "10.10.30.1"
    local-ip  = "10.10.30.2"
    vni       = "1100"
  }
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
variable "fmg_interface_select_method" {
  type    = string
  default = ""
}
variable "fmg_source_ip_fgt_1" {
  type    = string
  default = ""
}
variable "fmg_source_ip_fgt_2" {
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
variable "faz_interface_select_method" {
  type    = string
  default = ""
}
variable "faz_source_ip_fgt_1" {
  type    = string
  default = ""
}
variable "faz_source_ip_fgt_2" {
  type    = string
  default = ""
}
#-----------------------------------------------------------------------------------
# SDN connector
#-----------------------------------------------------------------------------------
variable "tenancy_ocid" {
  type    = string
  default = ""
}
variable "compartment_ocid" {
  type    = string
  default = ""
}
#-----------------------------------------------------------------------------------
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
variable "config_extra_fgt_1" {
  type    = string
  default = ""
}
variable "config_extra_fgt_2" {
  type    = string
  default = ""
}
variable "vcn_spoke_cidrs" {
  type    = list(string)
  default = null
}
variable "fgt_1_ips" {
  type    = map(string)
  default = null
}
variable "fgt_2_ips" {
  type    = map(string)
  default = null
}
variable "fgt_subnet_cidrs" {
  type    = map(string)
  default = null
}
variable "ports" {
  type = map(string)
  default = {
    mgmt    = "port1"
    public  = "port2"
    private = "port3"
    ha_port = "port1"
  }
}
variable "public_port" {
  type    = string
  default = "port2"
}
variable "private_port" {
  type    = string
  default = "port3"
}
variable "mgmt_port" {
  type    = string
  default = "port1"
}
variable "ha_port" {
  type    = string
  default = "port1"
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
variable "rsa_public_key" {
  type    = string
  default = null
}

