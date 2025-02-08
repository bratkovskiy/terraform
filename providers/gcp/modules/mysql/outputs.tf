output "instance_name" {
  description = "Name of the created instance"
  value       = module.mysql_instance.instance_name
}

output "instance_ip" {
  description = "Public IP of the created instance"
  value       = module.mysql_instance.instance_ip
}

output "mysql_port" {
  description = "MySQL port"
  value       = var.mysql_port
}

output "mysql_connection" {
  description = "MySQL connection details"
  value = {
    host     = module.mysql_instance.instance_ip
    port     = var.mysql_port
    database = var.mysql_config.database
    user     = var.mysql_config.user
  }
  sensitive = true
}
