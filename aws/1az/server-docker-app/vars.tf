##############################################################################################################
# IMPORTANT - Update variables with you group member and user
##############################################################################################################

// UPDATE owner with your AWS IAM user name
variable "tags" {
  description = "Attribute for tag Enviroment"
  type = map(any)
  default     = {
   Name    = "server-test"
   Project = "project"
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

// Server network interface
variable eni-server {
  type = map(any)
  default = {
    "id" = "ni-xxxx"
    "ip" = "x-x-x-x"
  }
}

// APP Docker image
// - default Apache httpd lastest
variable "app_docker_image" {
  type = string
  default = "httpd:latest"
}
 
// APP Git repo url 
variable "app_github_uri" {
  type = string
  default = "uri"
}

// Path to APP in Git repo 
// - parten /folder/ default /
variable "app_github_path" {
  type = string
  default = "/"
}

// PHP APP url 
variable "vm_size" {
  type = string
  default = "t3.small"
}