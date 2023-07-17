variable "instance_count" {
  description = "Number of instances to create"
  default     = 2
}

resource "yandex_compute_instance" "web" {
  count = var.instance_count

  name = "web-${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_family
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.public_key}"
  }
}


