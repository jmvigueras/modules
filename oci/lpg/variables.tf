variable "compartment_ocid" {}

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

variable "fgt_vcn_id" {
  type = string
  default = null
}

variable "fgt_subnet_ids" {
  type = map(string)
  default = null
}

variable "fgt_vcn_rt_to_fgt_id" {
  type = string
  default = null
}