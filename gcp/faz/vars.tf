# GCP resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}
# GCP region
variable "region" {
  type    = string
  default = "europe-west4" #Default Region
}
# GCP zone
variable "zone" {
  type    = string
  default = "europe-west4-a" #Default Zone
}

# GCP instance machine type
variable "machine" {
  type    = string
  default = "n1-standard-4"
}

# license file for active
variable "license_file" {
  type    = string
  default = "./licenses/licenseFAZ.lic"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}

variable "faz_version" {
  type    = string
  default = "724"
}

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
  type    = string
  default = null
}

// GCP user name launch Terrafrom
variable "gcp-user_name" {
  type    = string
  default = null
}

variable "admin_username" {
  type    = string
  default = "admin"
}

variable "faz_ni_ips" {
  type    = map(string)
  default = null
}

variable "subnet_names" {
  type    = map(string)
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
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

variable "api_key" {
  type    = string
  default = null
}

variable "faz_extra-config" {
  type    = string
  default = ""
}