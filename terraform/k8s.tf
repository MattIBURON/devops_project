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