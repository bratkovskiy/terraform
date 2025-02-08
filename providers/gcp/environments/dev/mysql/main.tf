provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file(var.credentials_file)
}

module "mysql" {
  source = "../../../modules/mysql"

  project_id       = var.project_id
  region          = var.region
  zone            = var.zone
  instance_name   = "mysql-dev"
  machine_type    = "e2-medium"
  mysql_config    = var.mysql_config
  ssh_username    = var.ssh_username
  ssh_pub_key_path = var.ssh_pub_key_path
  source_ranges   = var.source_ranges
}
