##############################################################################################################
# - UPDATE - 
##############################################################################################################

// Tags used in objets
variable "tags" {
  description = "Attribute for tag Enviroment"
  type = map(any)
  default     = {
   Name    = "terraform-deploy"
   Project = "terraform-deploy"
  }
}

// Region and Availability Zone where deploy VPC and Subnets
variable "region" {
  type = map(any)
  default = {
    "region"     = "eu-central-1"
    "region_az1" = "eu-central-1a"
  }
}

// CIDR range VPC HUB
variable "vpc-hub_cidr" {
  default = "10.10.10.0/24"
}

// Details about VPC HUB
variable "vpc-hub_advpn" {
  type = map(any)
  default = {
    "local_bgp-asn"  = "65001"          // BGP ASN HUB 
    "spoke_bgp-asn"  = "65011"          // BGP configured in sites
    "advpn_net"      = "10.10.20.0/24"  // Internal CIDR range for ADVPN tunnels private<
  }
}

// Name of existing key-pair, if null, it will create a new one
variable "key-pair_name" {
   description = "Key-Pair name in region to deploy"
   type     = string
   default  = null
}

// RSA public key in case no key pair is provided to create a new one
variable "key-pair_rsa-public-key" {
   description = "RSA public key for generated new KeyPair name in case provider key pair is null"
   type     = string
   default  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFWseRdS/YTmE0cPqHezW/YtSRjRdz/jXgY4ChaUby++nGRZzn444htTCcMwxnUP63otTR3wBIwhpgckphQaA2CG6Bkp4KeRfbJ3WXoTpQxAC90VqqzPDh8hixLVbMpB9zf5Ox9EGzokZ1UZY8NKPsYMNiS8Q2iXRB5RZRckzEdYft6scl3wQ7cw2um0d9eFW8yJB4YELeQwhWBNbt8RE8H7MPbIHve9TBtzgrWH+1xdRmaQQa32fzC0RcubLUoG0PZzJMJvRHZLZ+WoASOwx6jNY/Uii1NYzjq5BLExCsUKzqTvl8aagNOD73u79cQbomRng87c8rzXMAfYZ4QMmNuBRFqQMa9kLs+FbPePSgYMcJS6OSXHjEby7CsnHpnFsCdApTv2gXexRdbOJsyaxe459rvvYCb0VcHbF8OY1+h5VknKh3HoxWah0b08i3k3G8O12lDxpGqHfejIT21ybqOBps9OBvNU/qAAH2qB3jhrLxDpHKAk62GiqR7Oltjfs= Random RSA key"
}

##############################################################################################################
# This variables can remain by default

variable "admin_cidr" {
  default = "0.0.0.0/0"
}

variable "admin_port" {
  default = "8443"
}



