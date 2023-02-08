###################################################################################
# - IMPORTANT - Update this variables with outputs from module ../vnet-fgt
###################################################################################

// Update this variable if you have deployed vnet-fgt
// -> module "github.com/jmvigueras/modules/azure/vnet-fgt`
variable "fgt-active-ni_ids" {
  type    = list(string)
  default = null
}
variable "fgt-passive-ni_ids" {
  type    = list(string)
  default = null
}
variable "fgt-active-ni_names" {
  type    = map(string)
  default = null
}
variable "fgt-passive-ni_names" {
  type    = map(string)
  default = null
}

variable "cluster-public-ip_name" {
  type    = string
  default = null
}

variable "vnet-spoke-rt" {
  type    = string
  default = null
}

variable "fgt-subnet_cidrs" {
  type = map(any)
  default = {
    mgmt    = "172.30.1.0/24"
    public  = "172.30.2.0/24"
    private = "172.30.3.0/24"
  }
}

variable "gwlb_ip" {
  default = "172.30.3.15"
}
