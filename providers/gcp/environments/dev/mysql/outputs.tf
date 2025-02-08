output "mysql_instance_ip" {
  description = "Public IP of MySQL instance"
  value       = module.mysql.instance_ip
}

output "mysql_connection_details" {
  description = "MySQL connection details"
  value       = module.mysql.mysql_connection
  sensitive   = true
}
