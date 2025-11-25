terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.12.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# -----------------------------------------------------------------------------
# Network Module
# -----------------------------------------------------------------------------
module "network" {
  source = "./modules/network"

  name_prefix              = var.name_prefix
  region                   = var.region
  subnet_cidr              = var.subnet_cidr
  ssh_source_ranges        = var.ssh_source_ranges
  enable_ssh_firewall      = true
  enable_http_firewall     = true
  private_ip_google_access = true
}

# -----------------------------------------------------------------------------
# Service Account (recommended by Google)
# -----------------------------------------------------------------------------
resource "google_service_account" "vm_service_account" {
  account_id   = "${var.name_prefix}-vm-sa"
  display_name = "Service Account for ${var.name_prefix} VM"
}

# -----------------------------------------------------------------------------
# Compute Instance
# -----------------------------------------------------------------------------
resource "google_compute_instance" "main" {
  name         = "${var.name_prefix}-instance"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = module.network.network_id
    subnetwork = module.network.subnet_id

    # Assign an ephemeral public IP
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = var.startup_script

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  # Allow Terraform to stop the instance to update properties
  allow_stopping_for_update = true

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"]
    ]
  }
}
