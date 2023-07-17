data "template_file" "inventory" {
  template = file("${path.module}/ansible-inventory.tmpl")

  vars = {
    webservers = jsonencode([
      for i in yandex_compute_instance.web : {
        name = i.name
        network_interface = i.network_interface[0].nat_ip_address
      }
    ])

    databases = jsonencode([
      for i in yandex_compute_instance.for_each_vm : {
        name = i.name
        network_interface = i.network_interface[0].nat_ip_address
      }
    ])

    storage = jsonencode([
      {
        name = yandex_compute_instance.storage.name
        network_interface = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      }
    ])
  }
}

resource "local_file" "ansible_inventory" {
  content  = data.template_file.inventory.rendered
  filename = "${path.module}/inventory.ini"
}




