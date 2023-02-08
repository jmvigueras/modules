###################################################################################
# - IMPORTANT - Update this variables with outputs from module ../routeserver
###################################################################################

// Update this variable if you have deployed RouteServers
// -> module "github.com/jmvigueras/modules/azure/routeserver`
variable "rs_bgp-asn" {
  type    = list(string)
  default = ["65515"]
}

// Defalut values for Azure Route Server
variable "rs_peers" {
  type = list(list(string))
  default = [
    ["172.30.17.132", "172.30.17.133"],
    ["172.30.19.132", "172.30.19.133"]
  ]
}

// Defualt value for vHUB RouteServer
variable "vhub_peer" {
  type    = list(string)
  default = ["10.0.252.68", "10.0.252.69"]
}