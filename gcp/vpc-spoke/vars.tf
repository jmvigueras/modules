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
# list of subnets
variable "spoke-subnet_cidrs" {
  type    = list(string)
  default = null
}
# VPC SEC FGT self link
variable "fgt_vpc_self_link" {
  type    = string
  default = null
}
