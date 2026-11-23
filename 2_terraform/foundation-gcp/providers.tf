terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  project = "polytech-dijon"
  region  = "europe-west1"
  access_token = "toto"
}