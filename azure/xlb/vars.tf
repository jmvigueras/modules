// Resource group name
variable "resource_group_name" {
  type    = string
  default = null
}

// Azure resourcers prefix description added in name
variable "prefix" {
  type    = string
  default = "terraform"
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    deploy = "module-xlb"
  }
}

// Region for deployment
variable "location" {
  type    = string
  default = "francecentral"
}

// Map of subnet IDs VNet FGT
variable "subnet_ids" {
  type    = map(any)
  default = null
}

// Map of subnet CIDRS VNet FGT
variable "subnet_cidrs" {
  type    = map(any)
  default = null
}

// VNET ID of FGT VNET for peering
variable "vnet-fgt" {
  type    = map(any)
  default = null
}

// Fortigate IPs
variable "fgt-active-ni_ips" {
  type    = map(string)
  default = null
}
variable "fgt-passive-ni_ips" {
  type    = map(string)
  default = null
}

// Region for deployment
variable "config_gwlb" {
  type    = bool
  default = false
}

variable "gwlb_ip" {
  type    = string
  default = null
}

variable "ilb_ip" {
  type    = string
  default = null
}

// Fortigate vxlan vdi and port config
variable "gwlb_vxlan" {
  type = map(any)
  default = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
  }
}

// Fortigate interface probe port
variable "backend-probe_port" {
  type    = string
  default = "8008"
}