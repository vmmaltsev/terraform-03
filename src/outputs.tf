output "vm_info" {
  description = "Information about the created virtual machines"
  value = [
    for i in concat(yandex_compute_instance.web, values(yandex_compute_instance.for_each_vm), [yandex_compute_instance.storage]) : {
      name = i.name
      id = i.id
      fqdn = i.fqdn
    }
  ]
}

