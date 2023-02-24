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
 //   private = local.faz_ni_private_ip
  }
}

output "fmg_ni_ips" {
  value = {
    public  = local.fmg_ni_public_ip
 //   private = local.fmg_ni_private_ip
  }
}