# Create pubic IP for instance
resource "google_compute_address" "instance_pip" {
  count        = length(var.subnet_name)
  name         = "${var.subnet_name[count.index]}-instance-pip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create FGTVM compute active instance
resource "google_compute_instance" "instance" {
  count        = length(var.subnet_name)
  name         = "${var.subnet_name[count.index]}-instance"
  machine_type = var.machine_type
  zone         = var.zone

  tags = concat(["${var.subnet_name[count.index]}-t-route"], ["${var.subnet_name[count.index]}-t-fwr"], var.tags)

  boot_disk {
    initialize_params {
      image = var.image-vm
    }
  }
  network_interface {
    subnetwork = var.subnet_name[count.index]
    access_config {
      nat_ip = google_compute_address.instance_pip[count.index].address
    }
  }
  metadata = {
    ssh-keys       = "${var.gcp-user_name}:${var.rsa-public-key}"
    startup-script = file("${path.module}/templates/user-data.tpl")
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}


