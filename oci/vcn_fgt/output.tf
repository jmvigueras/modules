output "fgt_1_ips" {
  value = {
    mgmt    = local.fgt_1_ni_mgmt_ip
    public  = local.fgt_ni_public_ip_float
    private = local.fgt_ni_private_ip_float
  }
}

output "fgt_2_ips" {
  value = {
    mgmt    = local.fgt_2_ni_mgmt_ip
    public  = local.fgt_ni_public_ip_float
    private = local.fgt_ni_private_ip_float
  }
}

output "fgt_1_vnic_ips" {
  value = {
    mgmt    = local.fgt_1_ni_mgmt_ip
    public  = local.fgt_1_ni_public_ip
    private = local.fgt_1_ni_private_ip
  }
}

output "fgt_2_vnic_ips" {
  value = {
    mgmt    = local.fgt_2_ni_mgmt_ip
    public  = local.fgt_2_ni_public_ip
    private = local.fgt_2_ni_private_ip
  }
}

output "fgt_vcn_id" {
  value = oci_core_virtual_network.vcn.id 
}

output "fgt_subnet_ids" {
  value = {
    mgmt    = oci_core_subnet.subnet_mgmt.id
    public  = oci_core_subnet.subnet_public.id
    private = oci_core_subnet.subnet_private.id
    bastion = oci_core_subnet.subnet_bastion.id
  }
}

output "fgt_subnet_cidrs" {
  value = {
    mgmt    = local.subnet_mgmt_cidr
    public  = local.subnet_public_cidr
    private = local.subnet_private_cidr
    bastion = local.subnet_bastion_cidr
  }
}

output "fgt_nsg_ids" {
  value = {
    mgmt    = oci_core_network_security_group.nsg_mgmt.id
    public  = oci_core_network_security_group.nsg_public.id
    private = oci_core_network_security_group.nsg_private.id
    bastion = oci_core_network_security_group.nsg_bastion.id
  }
}