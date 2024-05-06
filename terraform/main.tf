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
  host = google_container_cluster.default.endpoint
  token = data.google_client_config.current.access_token
  client_certificate = base64decode(google_container_cluster.default.master_auth[0].client_certificate)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

data "google_container_engine_versions" "default" {
  location = "europe-west9-c"
}  
data "google_client_config" "current" {

}
resource "google_container_cluster" "default" {
  name = "my-first-cluster"
  location = "europe-west9-c"
  initial_node_count = 3
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  node_config {
    machine_type = "e2-small"
	disk_size_gb = 32
  }

  provisioner "local-exec" {
    when = destroy
    command = "sleep 90"
  }
}
resource "kubernetes_deployment" "name" {
  metadata {
    name = "nodedeployment"
	labels = {
	  "type" = "backend"
	  "app" = "nodeapp"
	}
  }
  spec {
    replicas = 1
	selector {
	  match_labels = {
	    "type" = "backend"
	    "app" = "nodeapp"	  
	  }
	}
	template {
	  metadata {
	    name = "nodeapppod"
		labels = {
	      "type" = "backend"
	      "app" = "nodeapp"		
		}
	  }
	  spec {
	    container {
		  name = "nodeappcontainer"
		  image = var.container_image
		  port {
		    container_port = 80
		  }
		}
	  }
	}
  }
}
resource "google_compute_address" "default" {
  name = "ipforservice"
  region = var.region
}
resource "kubernetes_service" "appservice" {
  metadata {
    name = "nodeapp-lb-service"
  }
  spec {
    type = "LoadBalancer"
	load_balancer_ip = google_compute_address.default.address
	port {
	  port = 80
	  target_port = 80
	}
	selector = {
	  "type" = "backend"
	  "app" = "nodeapp"	
	}
  }
}