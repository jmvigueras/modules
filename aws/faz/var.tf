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

variable "faz_extra-config" {
  type    = string
  default = ""
}

variable "faz_ni_ids" {
  type    = map(string)
  default = null
}

variable "faz_ni_ips" {
  type    = map(string)
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
}

// AMI
variable "faz_ami" {
  type    = string
  default = "ami-08eff5da31cd4af10"
}

// AMI
variable "faz_build" {
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

variable "faz_ni_0" {
  type    = string
  default = "public"
}
variable "faz_ni_1" {
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
  default = "./licenses/licenseFAZ.lic"
}