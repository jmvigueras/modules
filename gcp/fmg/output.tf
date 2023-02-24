output "fmg_id" {
  value = google_compute_instance.fmg.instance_id
}

output "fmg_self_link" {
  value = google_compute_instance.fmg.self_link
}

output "fmg_public-ip" {
  value = google_compute_address.fmg-public-ip.address
}
