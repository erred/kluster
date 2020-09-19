resource "google_compute_network" "cluster_network" {
  provider = google-beta

  name = "${var.cluster}-network"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cluster_subnet" {
  provider = google-beta

  name          = var.cluster
  network       = google_compute_network.cluster_network.id
  ip_cidr_range = "10.240.0.0/24"

  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_firewall" "cluster_internal" {
  provider = google-beta

  name    = "${var.cluster}-internal"
  network = google_compute_network.cluster_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "cluster_external" {
  provider = google-beta

  name    = "${var.cluster}-external"
  network = google_compute_network.cluster_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "udp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
