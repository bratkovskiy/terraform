module "mysql_instance" {
  source = "../instance"

  project_id       = var.project_id
  region          = var.region
  zone            = var.zone
  instance_name   = var.instance_name
  machine_type    = var.machine_type
  ssh_username    = var.ssh_username
  ssh_pub_key_path = var.ssh_pub_key_path
  tags            = ["mysql-server"]
  boot_disk_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250130"
}

# Firewall rule для MySQL
resource "google_compute_firewall" "mysql" {
  name    = "allow-mysql-${var.instance_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.mysql_port]
  }

  source_ranges = var.source_ranges
  target_tags   = ["mysql-server"]
}

# Копируем конфигурацию MySQL и скрипт установки
resource "null_resource" "mysql_setup" {
  triggers = {
    instance_id = module.mysql_instance.instance_id
  }

  provisioner "file" {
    content     = templatefile("${path.module}/../../../../configs/mysql/my.cnf.tpl", { mysql_port = var.mysql_port })
    destination = "/tmp/my.cnf"

    connection {
      type        = "ssh"
      user        = var.ssh_username
      host        = module.mysql_instance.instance_ip
      private_key = file(replace(var.ssh_pub_key_path, ".pub", ""))
      agent       = false
      timeout     = "2m"
    }
  }

  provisioner "file" {
    source      = "${path.module}/../../../../scripts/mysql/setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_username
      host        = module.mysql_instance.instance_ip
      private_key = file(replace(var.ssh_pub_key_path, ".pub", ""))
      agent       = false
      timeout     = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo ROOT_PASSWORD='${var.mysql_config.root_password}' DATABASE='${var.mysql_config.database}' USER='${var.mysql_config.user}' PASSWORD='${var.mysql_config.password}' /tmp/setup.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_username
      host        = module.mysql_instance.instance_ip
      private_key = file(replace(var.ssh_pub_key_path, ".pub", ""))
      agent       = false
      timeout     = "2m"
    }
  }
}
