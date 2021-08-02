// Create a network for GKE
resource "google_compute_network" "network" {
  name                    = format("%s-network", var.name)
  project                 = var.project_id
  auto_create_subnetworks = false

  lifecycle {
    create_before_destroy = true
  }
}

// Create subnets
resource "google_compute_subnetwork" "subnetwork" {
  name          = format("%s-subnet", var.name)
  project       = var.project_id
  network       = google_compute_network.network.self_link
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = format("%s-pod-range", var.name)
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = format("%s-svc-range", var.name)
    ip_cidr_range = "10.2.0.0/20"
  }
}

// Create an external NAT IP
resource "google_compute_address" "nat" {
  count   = local.outbound_access ? 1 : 0
  name    = format("%s-nat-ip", var.name)
  project = var.project_id
  region  = var.region

}

// Create a cloud router for use by the Cloud NAT
resource "google_compute_router" "router" {
  count   = local.outbound_access ? 1 : 0
  name    = format("%s-cloud-router", var.name)
  project = var.project_id
  region  = var.region
  network = google_compute_network.network.self_link

  bgp {
    asn = 64514
  }
}

// Create a NAT router so the nodes can reach DockerHub, etc
resource "google_compute_router_nat" "nat" {
  count   = local.outbound_access ? 1 : 0
  name    = format("%s-cloud-nat", var.name)
  project = var.project_id
  router  = google_compute_router.router[0].name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [google_compute_address.nat[0].self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnetwork.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name,
      google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name,
    ]
  }
}

resource "google_compute_firewall" "ingress-nginx" {
  count = var.ingress_nginx_enabled && var.private ? 1 : 0
  project = var.project_id
  name    = format("%s-ingress-nginx", var.name)
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  source_ranges = [var.master_ipv4_block]

  target_tags   = ["gke-${var.name}"]
}