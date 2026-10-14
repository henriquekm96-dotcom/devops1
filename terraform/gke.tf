resource "google_container_cluster" "primary" {
  name     = "gke-${var.environment}-payment"
  location = var.region

  # Criando um cluster nativo de VPC (VPC-native)
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet_private.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Defina como true se for gerir via bastion host ou VPN
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  deletion_protection = false # Altere para true em ambiente real de produção por segurança
}

# Pool de Nós Isolados
resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-${var.environment}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    machine_type = "e2-medium" # Económico para laboratório/portfólio
    disk_size_gb = 30
    disk_type    = "pd-standard"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}