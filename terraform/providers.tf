terraform {
  required_version = ">= 0.12"
  backend "gcs" {
  }
}
   
provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_container_cluster" "default" {
  name     = "example-cluster"
  location = var.region
  # Add your other cluster configurations here

  node_pool {
    name           = "default-pool"
    initial_node_count = 1
    # You can add more configurations for the node pool here if needed
  }
}

provider "kubernetes" {
  host = google_container_cluster.default.endpoint
  token = data.google_client_config.current.access_token
  client_certificate = base64decode(google_container_cluster.default.master_auth[0].client_certificate)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}