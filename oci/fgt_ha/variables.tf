variable "compartment_ocid" {}

variable "tenancy_ocid" {
  type    = string
  default = ""
}

# Resources prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "tags" {
  description = "Attribute for tag Enviroment"
  type        = map(any)
  default = {
    project = "terraform"
  }
}

variable "region" {
  type    = string
  default = "eu-frankfurt-1"
}

variable "region_ad_1" {
  type    = string
  default = "1"
}

variable "region_ad_2" {
  type    = string
  default = "2"
}

variable "fgt_passive" {
  type    = bool
  default = false
}

variable "fgt_ha_fgsp" {
  type    = bool
  default = false
}

variable "fgt_config_1" {
  type    = string
  default = ""
}

variable "fgt_config_2" {
  type    = string
  default = ""
}

variable "vm_image_ocid" {
  default = "ocid1.image.oc1..aaaaaaaalj3fxkjxnru4i5725rl45iur3ducp5fy5dmulwzjtepathmtxbta"
}

variable "fgt_image_ids" {
  type = map(string)
  default = {
    byol = "ocid1.image.oc1..aaaaaaaalj3fxkjxnru4i5725rl45iur3ducp5fy5dmulwzjtepathmtxbta"
    payg = "ocid1.image.oc1..aaaaaaaatwwtthsopj6iqfg762xpwnsmsnuzwhpwad7lw6slfjrao2f3bnha"
  }
}

variable "instance_shape" {
  default = "VM.Standard2.4"
  // default = "VM.Standard.E4.Flex"
}

variable "volume_size" {
  default = "50" //GB
}

variable "fgt_ni_0" {
  type    = string
  default = "public"
}
variable "fgt_ni_1" {
  type    = string
  default = "private"
}
variable "fgt_ni_2" {
  type    = string
  default = "mgmt"
}
variable "fgt_ni_3" {
  type    = string
  default = "ha"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

variable "fgt_subnet_ids" {
  type    = map(string)
  default = null
}

variable "fgt_vcn_id" {
  type    = string
  default = null
}

variable "fgt_1_ips" {
  type    = map(string)
  default = null
}

variable "fgt_2_vnic_ips" {
  type    = map(string)
  default = null
}

variable "fgt_1_vnic_ips" {
  type    = map(string)
  default = null
}

variable "fgt_2_ips" {
  type    = map(string)
  default = null
}

variable "public_ip_lifetime" {
  type    = string
  default = "RESERVED"
  //or EPHEMERAL
}

variable "fgt_nsg_ids" {
  type    = map(string)
  default = null
}

variable "ocpus" {
  type    = number
  default = 4
}
variable "memory_in_gbs" {
  type    = number
  default = 16
}
