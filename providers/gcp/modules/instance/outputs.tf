output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.instance.name
}

output "instance_id" {
  description = "ID of the created instance"
  value       = google_compute_instance.instance.id
}

output "instance_ip" {
  description = "Public IP of the created instance"
  value       = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}
