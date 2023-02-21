output "vpc_names" {
  value = {
    mgmt    = google_compute_network.vpc_mgmt.name
    public  = google_compute_network.vpc_public.name
    private = google_compute_network.vpc_private.name
  }
}

output "vpc_self_links" {
  value = {
    mgmt    = google_compute_network.vpc_mgmt.self_link
    public  = google_compute_network.vpc_public.self_link
    private = google_compute_network.vpc_private.self_link
  }
}

output "vpc_ids" {
  value = {
    mgmt    = google_compute_network.vpc_mgmt.id
    public  = google_compute_network.vpc_public.id
    private = google_compute_network.vpc_private.id
  }
}

output "subnet_names" {
  value = {
    mgmt    = google_compute_subnetwork.subnet_mgmt.name
    public  = google_compute_subnetwork.subnet_public.name
    private = google_compute_subnetwork.subnet_private.name
    bastion = google_compute_subnetwork.subnet_bastion.name
  }
}

output "subnet_self_links" {
  value = {
    mgmt    = google_compute_subnetwork.subnet_mgmt.self_link
    public  = google_compute_subnetwork.subnet_public.self_link
    private = google_compute_subnetwork.subnet_private.self_link
    bastion = google_compute_subnetwork.subnet_bastion.self_link
  }
}

output "subnet_ids" {
  value = {
    mgmt    = google_compute_subnetwork.subnet_mgmt.id
    public  = google_compute_subnetwork.subnet_public.id
    private = google_compute_subnetwork.subnet_private.id
    bastion = google_compute_subnetwork.subnet_bastion.id
  }
}

output "subnet_cidrs" {
  value = {
    public  = local.subnet_public_cidr
    private = local.subnet_private_cidr
    bastion = local.subnet_bastion_cidr
    mgmt    = local.subnet_mgmt_cidr
  }
}

output "fgt-active-ni_ips" {
  value = {
    public  = cidrhost(local.subnet_public_cidr, 10)
    private = cidrhost(local.subnet_private_cidr, 10)
    mgmt    = cidrhost(local.subnet_mgmt_cidr, 10)
  }
}

output "fgt-passive-ni_ips" {
  value = {
    public  = cidrhost(local.subnet_public_cidr, 11)
    private = cidrhost(local.subnet_private_cidr, 11)
    mgmt    = cidrhost(local.subnet_mgmt_cidr, 11)
  }
}

output "ilb_ip" {
  value = cidrhost(local.subnet_private_cidr, 9)
}

output "ncc_private_ips" {
  value = [
    cidrhost(local.subnet_private_cidr, 5),
    cidrhost(local.subnet_private_cidr, 6)
  ]
}

output "ncc_public_ips" {
  value = [
    cidrhost(local.subnet_public_cidr, 5),
    cidrhost(local.subnet_public_cidr, 6)
  ]
}