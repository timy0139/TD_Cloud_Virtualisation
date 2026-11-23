resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "td2"
  machine_type = "n2-standard-2"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {

    }
  }
}

resource "google_sql_database_instance" "db_instance" {
  name = "td2_BDD"
  database_version = "POSTGRES_15"
  region = "europe-west1"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.vpc_network.id
    }
  }

  deletion_protection = false
}

resource "google_dns_managed_zone" "dns_zone" {
  name        = "td_dns"
  dns_name    = "kiowy.com."
  description = "Zone DNS pour le TD Terraform"
}

resource "google_dns_record_set" "app_dns" {
  name = "app.${google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = google_dns_managed_zone.dns_zone.name
  type = "A"
  ttl = 300

  rrdatas = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]
}