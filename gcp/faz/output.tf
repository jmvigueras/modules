output "faz_id" {
  value = google_compute_instance.faz.instance_id
}

output "faz_self_link" {
  value = google_compute_instance.faz.self_link
}

output "faz_public-ip" {
  value = google_compute_address.faz-public-ip.address
}
