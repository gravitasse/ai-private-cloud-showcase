terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

# secondary cluster
resource "google_container_cluster" "secondary" {
  name                     = "ai-secondary-gke"
  location                 = var.gcp_region
  remove_default_node_pool = true
  initial_node_count       = 1
}

# GPU pool (A2 or L4)
resource "google_container_node_pool" "gpu_pool" {
  name       = "gpu-pool"
  location   = var.gcp_region
  cluster    = google_container_cluster.secondary.name
  node_count = 2

  node_config {
    machine_type = "a2-highgpu-1g"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

output "secondary_api_endpoint" {
  value = google_container_cluster.secondary.endpoint
}
