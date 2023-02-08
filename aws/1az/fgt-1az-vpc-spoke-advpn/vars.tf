##############################################################################################################
# - IMPORTANT - 
# - UPDATE - fix variables with you group member and user
##############################################################################################################

// IMPORTANT: UPDATE Owner with your AWS IAM user name
variable "tags" {
  description = "Attribute for tag Enviroment"
  type = map(any)
  default     = {
   Name    = "site"
   Project = "hub-spoke-deploy"
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

// CIDR range for site VPC
variable "vpc-spoke_cidr" {
  default = "10.10.10.0/24"
}

// PSD for HUB ADVPN
variable "hub_advpn_psk" {
  type     = string
  default  = "super-secret-eky"
}

// Details about central HUB (golden VPC)
variable "hub_advpn" {
  type = map(any)
  default = {
    hub_asn       = "65001"          // BGP ASN HUB central (golden VPC)
    spoke_asn     = "65011"          // BGP configured in sites
    advpn_net     = "10.10.20.0/24"  // Internal CIDR range for ADVPN tunnels private
    advpn_e-ip1   = "11.11.11.11"    // Public IP HUB 
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



