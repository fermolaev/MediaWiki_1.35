#----------| Random pass for VM user |------------

resource "random_password" "vm_user" {
  length           = var.pass_length
  special          = true
  override_special = var.pass_strong
}

#----------| Yandex Data Info|------------

data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

data "yandex_vpc_subnet" "net" {
  name = "default-${var.zone}"
}

#----------| Yandex VM|------------

resource "yandex_compute_instance" "goweb" {
  name = var.name
  zone = var.zone
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = 10
    }
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.net.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
  labels = {
    task_name : var.task
    user_email : var.email
  }

  connection {
    type        = var.connect_type
    host        = self.network_interface[0].nat_ip_address
    user        = "test"
    private_key = file(var.ssh_privat)
    agent       = false
  }

  provisioner "file" {
    source      = "${path.module}/commands.sh"
    destination = "/home/test/commands.sh"
  }

  provisioner "file" {
    source      = "${path.module}/default"
    destination = "/home/test/default"
  }

  provisioner "file" {
    source      = "${path.module}/fermolaev.devops.rebrain.srwx.net.key"
    destination = "/home/test/fermolaev.devops.rebrain.srwx.net.key"
  }

  provisioner "file" {
    source      = "${path.module}/fullchain_fermolaev.devops.rebrain.srwx.net"
    destination = "/home/test/fullchain_fermolaev.devops.rebrain.srwx.net"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
      "echo test:${random_password.vm_user.result} | sudo chpasswd",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -x commands.sh",
      "sudo sh commands.sh",
    ]
  }
}

locals {
  ip_vm = yandex_compute_instance.goweb.network_interface[0].nat_ip_address
}

#----------| AWS 53 DNS |------------

data "aws_route53_zone" "rebrain" {
  name = var.zone_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.rebrain.zone_id
  name    = var.name
  type    = var.dns_type
  ttl     = var.ttl
  records = [local.ip_vm]
}
