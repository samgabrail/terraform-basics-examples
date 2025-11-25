# -----------------------------------------------------------------------------
# VPC Network
# -----------------------------------------------------------------------------
resource "google_compute_network" "this" {
  name                    = "${var.name_prefix}-network"
  auto_create_subnetworks = false
  mtu                     = var.mtu
}

# -----------------------------------------------------------------------------
# Subnet
# -----------------------------------------------------------------------------
resource "google_compute_subnetwork" "this" {
  name                     = "${var.name_prefix}-subnet"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.this.id
  private_ip_google_access = var.private_ip_google_access
}

# -----------------------------------------------------------------------------
# Firewall Rules
# -----------------------------------------------------------------------------

# Allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  count   = var.enable_ssh_firewall ? 1 : 0
  name    = "${var.name_prefix}-allow-ssh"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["ssh"]
}

# Allow HTTP/HTTPS access
resource "google_compute_firewall" "allow_http" {
  count   = var.enable_http_firewall ? 1 : 0
  name    = "${var.name_prefix}-allow-http"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Allow internal communication within the VPC
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.name_prefix}-allow-internal"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr]
}
