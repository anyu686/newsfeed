resource "google_compute_instance" "newsfeed" {
  name         = "newsfeed-instance-1"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"

  # boot disk specifications
  boot_disk {
    initialize_params {
      image = "news-feed-image" // use image built with Packer
    }
  }

  # networks to attach to the VM
  network_interface {
    network = "default"
    access_config {} // use ephemaral public IP
  }
}
resource "google_compute_project_metadata" "newsfeed" {
  metadata {
    ssh-keys = "developer:${file("~/.ssh/developer.pub")}" // path to ssh key file
  }
}

resource "google_compute_firewall" "newsfeed" {
  name    = "allow-tcp-9292"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
}
output "newsfeed_public_ip" {
  value = "${google_compute_instance.newsfeed.network_interface.0.access_config.0.assigned_nat_ip}"
}
