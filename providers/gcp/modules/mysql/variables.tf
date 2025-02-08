variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name for the MySQL instance"
  type        = string
  default     = "mysql-instance"
}

variable "machine_type" {
  description = "Machine type for the GCP instance"
  type        = string
  default     = "e2-medium"
}

variable "mysql_port" {
  description = "Port for MySQL"
  type        = number
  default     = 3306
}

variable "mysql_config" {
  description = "MySQL configuration"
  type = object({
    root_password = string
    database      = string
    user          = string
    password      = string
  })
}

variable "source_ranges" {
  description = "Source IP ranges for firewall rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
}

variable "ssh_pub_key_path" {
  description = "Path to SSH public key"
  type        = string
}
