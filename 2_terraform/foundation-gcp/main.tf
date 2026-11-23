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