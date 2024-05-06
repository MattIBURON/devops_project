terraform {
  required_version = ">= 0.12"
  backend "gcs" {
  }
}
   
provider "google" {
  project = var.project_id
  region = var.region
}

provider "kubernetes" {
  config_context = google_container_cluster.default.name
}