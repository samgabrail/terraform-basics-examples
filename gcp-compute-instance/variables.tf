variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for the compute instance"
  type        = string
  default     = "us-central1-a"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "demo"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "machine_type" {
  description = "The machine type for the compute instance"
  type        = string
  default     = "e2-medium"
}

variable "boot_image" {
  description = "The boot image for the compute instance"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of the boot disk"
  type        = string
  default     = "pd-balanced"
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "startup_script" {
  description = "Startup script to run on the instance"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Hello from $(hostname)" > /var/www/html/index.html
  EOF
}
