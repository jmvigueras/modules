# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

# AWS resourcers prefix description
variable "tag-env" {
  type    = string
  default = "terraform-deploy"
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

variable "region" {
  type = map(any)
  default = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
}


variable "fgt-active-ni_ids" {
  type = map(string)
  default = null
}

variable "fgt-active-ni_ips" {
  type = map(string)
  default = null
}

variable "fgt-passive-ni_ids" {
  type = map(string)
  default = null
}

variable "fgt-passive-ni_ips" {
  type = map(string)
  default = null
}

variable "subnet_az1_cidrs" {
  type = map(string)
  default = null
}

variable "subnet_az2_cidrs" {
  type = map(string)
  default = null
}

variable "gwlb_ip1" {
  type    = string
  default = "172.30.4.10"
}
variable "gwlb_ip2" {
  type    = string
  default = "172.30.14.10"
}

// AMI
variable "fgt-ami" {
  type    = string
  default = "null"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "payg"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
}

// license file for the passive fgt
variable "license2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "license2.txt"
}

variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  default     = "c5.large"
}

variable "keypair" {
  description = "Provide a keypair for accessing the FortiGate instances"
  default     = "<key pair>"
}

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
  type    = string
  default = null
}

// Fortigate interface probe port
variable "backend-probe_port" {
  type    = string
  default = "8008"
}