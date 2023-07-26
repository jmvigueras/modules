variable "compartment_ocid" {}

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

# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "tags" {
  description = "Resouce Tags"
  type        = map(string)
  default = {
    owner   = "terraform"
    project = "terraform-deploy"
  }
}

## VCN and SUBNET ADDRESSESS
variable "vcn_cidr" {
  default = "172.20.0.0/24"
}

variable "untrust_public_ip_lifetime" {
  default = "RESERVED"
}

variable "vm_image_ocid" {
  default = "ocid1.image.oc1..aaaaaaaabu6hszx2yexxqddvekarvsmpdltvp6sqqmrmlgqilpxuxjtqvyla"
}

variable "instance_shape" {
  default = "VM.Standard2.4"
}

# Choose an Availability Domain (1,2,3)
variable "availability_domain-a" {
  default = "1"
}

variable "availability_domain-b" {
  default = "2"
}

variable "volume_size" {
  default = "50" //GB
}

variable "bootstrap_vm-a" {
  default = "./userdata/bootstrap_vm-a.tpl"
}

variable "license_vm-a" {
  default = "./license/FGT-A-license-filename.lic"
}

variable "bootstrap_vm-b" {
  default = "./userdata/bootstrap_vm-b.tpl"
}

variable "license_vm-b" {
  default = "./license/FGT-B-license-filename.lic"
}

variable "admin_port" {
  type    = string
  default = "8443"
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
