locals {
  // Create NIC ids for faz
  ni_ids = {
    public  = aws_network_interface.ni-faz-public.id
    private = aws_network_interface.ni-faz-private.id
  }
  // Create private IPs for faz
  ni_ips = {
    public  = var.faz_ip_public != null ? var.faz_ip_public : cidrhost(var.subnet_cidrs["public"], 12)
    private = var.faz_ip_private != null ? var.faz_ip_private : cidrhost(var.subnet_cidrs["private"], 12)
  }
}
