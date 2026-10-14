resource "google_compute_network" "vpc" {
  name                    = "vpc-${var.environment}-payment"
  auto_create_subnetworks = false
}

# Sub-rede Pública (para Load Balancers e Gateways)
resource "google_compute_subnetwork" "subnet_public" {
  name          = "subnet-${var.environment}-public"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Sub-rede Privada (para os nós do Kubernetes / GKE)
resource "google_compute_subnetwork" "subnet_private" {
  name          = "subnet-${var.environment}-private"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Cloud Router e Cloud NAT para permitir saída segura à internet dos nós privados (updates/patches)
resource "google_compute_router" "router" {
  name    = "router-${var.environment}"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-${var.environment}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}