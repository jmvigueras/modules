locals {
  #-----------------------------------------------------------------------------------------------------
  # FAZ IPs (updated if necessary)
  #-----------------------------------------------------------------------------------------------------
  fmg_ni_public_ip  = var.fmg_ni_ips == null ? cidrhost(var.subnet_cidrs["public"], 13) : var.fmg_ni_ips["public"]
  fmg_ni_private_ip = var.fmg_ni_ips == null ? cidrhost(var.subnet_cidrs["private"], 13) : var.fmg_ni_ips["private"]
  #-----------------------------------------------------------------------------------------------------
  # (Necessary for deployment) 
  #-----------------------------------------------------------------------------------------------------
  fmg_ni_ids = {
    public  = azurerm_network_interface.fmg_ni_public.id
    private = azurerm_network_interface.fmg_ni_private.id
  }
}