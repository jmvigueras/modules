output "drg_id" {
  value = oci_core_drg.drg.id
}

output "drg_default_route_table_id_vcn" {
  value = oci_core_drg.drg.default_drg_route_tables[0]["vcn"]
}

output "drg_default_route_table_ids" {
  value = oci_core_drg.drg.default_drg_route_tables
}

output "drg_rt_ids" {
  value = {
    pre  = oci_core_drg_route_table.drg_rt_pre_inspection.id
    post = oci_core_drg_route_table.drg_rt_post_inspection.id
  }
}