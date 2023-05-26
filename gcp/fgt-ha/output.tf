output "fgt_active_id" {
  value = google_compute_instance.fgt-active.instance_id
}

output "fgt_passive_id" {
  value = var.config_fgsp ? google_compute_instance.fgt-passive_fgsp.*.instance_id : google_compute_instance.fgt-passive_fgcp.*.instance_id
}

output "fgt_active_self_link" {
  value = google_compute_instance.fgt-active.self_link
}

output "fgt_passive_self_link" {
  value = var.config_fgsp ? google_compute_instance.fgt-passive_fgsp.*.self_link : google_compute_instance.fgt-passive_fgcp.*.self_link
}

output "fgt_active_eip_mgmt" {
  value = google_compute_address.active-mgmt-public-ip.address
}

output "fgt_passive_eip_mgmt" {
  value = google_compute_address.passive-mgmt-public-ip.*.address
}

output "fgt_active_eip_public" {
  value = google_compute_address.active-public-ip.address
}

output "fgt_passive_eip_public" {
  value = google_compute_address.passive-public-ip.*.address
}