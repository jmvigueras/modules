# AWS resourcers prefix description
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
  type = map(any)
  default = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
}

variable "fmg_extra-config" {
  type    = string
  default = ""
}

variable "fmg_ip_public" {
  type    = string
  default = null
}

variable "fmg_ip_private" {
  type    = string
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
}

variable "subnet_ids" {
  type    = map(string)
  default = null
}

variable "nsg_ids" {
  type    = map(list(string))
  default = null
}

// AMI
variable "fmg_ami" {
  type    = string
  default = "ami-0b2d96b7d278c11ee"
}

// AMI
variable "fmg_build" {
  type    = string
  default = "build1334"
}

variable "keypair" {
  type    = string
  default = null
}

variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  type        = string
  default     = "m5.xlarge"
}

variable "fmg_ni_0" {
  type    = string
  default = "public"
}
variable "fmg_ni_1" {
  type    = string
  default = "private"
}

variable "public_port" {
  type    = string
  default = "port1"
}
variable "private_port" {
  type    = string
  default = "port2"
}

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
  type    = string
  default = null
}

variable "api_key" {
  type    = string
  default = null
}

variable "admin_username" {
  type    = string
  default = "admin"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

// license file for the active fgt
variable "license_file" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/licenseFMG.lic"
}