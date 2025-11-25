variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "region" {
  description = "The GCP region for the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "mtu" {
  description = "Maximum Transmission Unit in bytes"
  type        = number
  default     = 1460
}

variable "private_ip_google_access" {
  description = "Enable Private Google Access on the subnet"
  type        = bool
  default     = true
}

variable "enable_ssh_firewall" {
  description = "Enable SSH firewall rule"
  type        = bool
  default     = true
}

variable "enable_http_firewall" {
  description = "Enable HTTP/HTTPS firewall rule"
  type        = bool
  default     = true
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
