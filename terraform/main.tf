data "google_container_engine_version" "default" {
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
    machine_type = "g1-small"
	disk_size_gb = 32
  }
  provisionner "local-exec" {
    when = destroy
    command = "sleep 90"
  }
}