variable "instances" {
  description = "List of instances to create"
  default     = [
    {
      vm_name = "main"
      cpu     = 2
      ram     = 2
      disk    = 10
    },
    {
      vm_name = "replica"
      cpu     = 2
      ram     = 4
      disk    = 20
    }
  ]
}

resource "yandex_compute_instance" "for_each_vm" {
  for_each = { for i in var.instances : i.vm_name => i }

  name = each.value.vm_name

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_family
      size     = each.value.disk
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.public_key}"
  }

  depends_on = [yandex_compute_instance.web]
}
