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

  tags = ["${var.subnet_name[count.index]}-t-route", "${var.subnet_name[count.index]}-t-fwr"]

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
    startup-script = <<-EOF
      #! /bin/bash /
      sudo apt-get update
      sudo apt-get install apache2 -y
      sudo a2ensite default-ssl
      sudo a2enmod ssl
      sudo vm_hostname="$(curl -H "Metadata-Flavor:Google" \
      http://169.254.169.254/computeMetadata/v1/instance/name)"
      sudo echo "Page served from: $vm_hostname" | \
      tee /var/www/html/index.html
      sudo systemctl restart apache2"
      EOF
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}





