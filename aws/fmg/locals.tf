locals {
  // Create NIC ids for FMG
  ni_ids = {
    public  = aws_network_interface.ni-fmg-public.id
    private = aws_network_interface.ni-fmg-private.id
  }
  // Create private IPs for FMG
  ni_ips = {
    public  = var.fmg_ip_public != null ? var.fmg_ip_public : cidrhost(var.subnet_cidrs["public"], 13)
    private = var.fmg_ip_private != null ? var.fmg_ip_private : cidrhost(var.subnet_cidrs["private"], 13)
  }
}
