# -----------------------------------------------------------------------------
# Network Outputs (from module)
# -----------------------------------------------------------------------------
output "network_name" {
  description = "The name of the VPC network"
  value       = module.network.network_name
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = module.network.network_self_link
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.network.subnet_name
}

output "subnet_self_link" {
  description = "The self link of the subnet"
  value       = module.network.subnet_self_link
}

# -----------------------------------------------------------------------------
# Compute Instance Outputs
# -----------------------------------------------------------------------------
output "instance_name" {
  description = "The name of the compute instance"
  value       = google_compute_instance.main.name
}

output "instance_id" {
  description = "The instance ID"
  value       = google_compute_instance.main.instance_id
}

output "instance_self_link" {
  description = "The self link of the instance"
  value       = google_compute_instance.main.self_link
}

output "internal_ip" {
  description = "The internal IP address of the instance"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "external_ip" {
  description = "The external IP address of the instance"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "service_account_email" {
  description = "The email of the service account attached to the instance"
  value       = google_service_account.vm_service_account.email
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "gcloud compute ssh ${google_compute_instance.main.name} --zone=${var.zone} --project=${var.project_id}"
}
