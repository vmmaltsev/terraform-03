variable "disk_count" {
  description = "Number of disks to create"
  default     = 3
}

resource "yandex_compute_disk" "extra" {
  count = var.disk_count

  name = "extra-disk-${count.index + 1}"
  type = "network-hdd"
  size = 1
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_family
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra

    content {
      disk_id = secondary_disk.value.id
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
