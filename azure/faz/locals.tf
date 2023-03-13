locals {
  #-----------------------------------------------------------------------------------------------------
  # FAZ IPs (updated if necessary)
  #-----------------------------------------------------------------------------------------------------
  faz_ni_public_ip  = var.faz_ni_ips == null ? cidrhost(var.subnet_cidrs["public"], 12) : var.faz_ni_ips["public"]
  faz_ni_private_ip = var.faz_ni_ips == null ? cidrhost(var.subnet_cidrs["private"], 12) : var.faz_ni_ips["private"]
  #-----------------------------------------------------------------------------------------------------
  # (Necessary for deployment) 
  #-----------------------------------------------------------------------------------------------------
  faz_ni_ids = {
    public  = azurerm_network_interface.faz_ni_public.id
    private = azurerm_network_interface.faz_ni_private.id
  }
}