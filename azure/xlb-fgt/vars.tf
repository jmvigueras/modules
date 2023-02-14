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

// Subnet private details
// - Subnet private interfaces of FGT
variable "subnet_private" {
  type = map(any)
  default = {
    cidr    = "172.31.3.0/24"
    id      = ""
    vnet_id = ""
  }
}

// Fortigate cluster interface ids
variable "fgt-ni_ids" {
  type = map(any)
  default = {
    fgt1_private = "ni-xx"
    fgt2_private = "ni-xx"
    fgt1_public  = "ni-xx"
    fgt2_public  = "ni-xx"
  }
}

// Fortigate cluster interface ips
variable "fgt-ni_ips" {
  type = map(any)
  default = {
    fgt1_private = "172.31.3.10"
    fgt2_private = "172.31.3.11"
  }
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