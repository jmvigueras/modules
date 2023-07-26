// Gets a list of Availability Domains
data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.compartment_ocid
  ad_number      = var.region_ad_1
}
data "oci_identity_availability_domain" "ad_2" {
  compartment_id = var.compartment_ocid
  ad_number      = var.region_ad_2
}