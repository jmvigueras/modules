# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "ni_id" {
  type    = string
  default = null
}

variable "vm_size" {
  type    = string
  default = "t2.micro"
}

variable "keypair" {
  type    = string
  default = null
}
