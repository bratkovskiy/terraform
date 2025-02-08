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
  description = "Name for the GCP instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the GCP instance"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_image" {
  description = "Boot disk image"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
}

variable "ssh_pub_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "tags" {
  description = "Network tags to apply to the instance"
  type        = list(string)
  default     = []
}
