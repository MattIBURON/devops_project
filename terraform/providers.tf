terraform {
  required_version = ">= 0.12"
  backend "gcs" {
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  token                  = data.google_client_config.current.access_token
  client_certificate     = base64decode(google_container_cluster.default.master_auth[0].client_certificate)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

module "kubernetes_resources" {
  source          = "./module"
  container_image = "us.gcr.io/cicd-terraform-422508/nodeappimage:${github.sha}"
  region          = var.region
  project_id      = var.project_id
}
