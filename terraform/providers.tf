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
  config_context_cluster = google_container_cluster.default.name
  load_config_file       = false
  host = google_container_cluster.default.endpoint
  token = data.google_client_config.current.access_token
  client_certificate = base64decode(google_container_cluster.default.master_auth[0].client_certificate)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}