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

variable "credentials_file" {
  description = "Path to GCP credentials file"
  type        = string
}
