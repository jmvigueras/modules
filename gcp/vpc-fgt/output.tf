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
    public  = local.fgt-1_ni_public_ip
    private = local.fgt-1_ni_private_ip
    mgmt    = local.fgt-1_ni_mgmt_ip
  }
}

output "fgt-passive-ni_ips" {
  value = {
    public  = local.fgt-2_ni_public_ip
    private = local.fgt-2_ni_private_ip
    mgmt    = local.fgt-2_ni_mgmt_ip
  }
}

output "ilb_ip" {
  value = local.ilb_ip
}

output "ncc_private_ips" {
  value = local.ncc_private_ips
}

output "ncc_public_ips" {
  value = local.ncc_public_ips
}

output "faz_ni_ips" {
  value = {
    public  = local.faz_ni_public_ip
    private = local.faz_ni_private_ip
  }
}

output "fmg_ni_ips" {
  value = {
    public  = local.fmg_ni_public_ip
    private = local.fmg_ni_private_ip
  }
}