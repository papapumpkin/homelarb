output "client_configuration" {
  value     = module.talos.client_configuration
  sensitive = true
}

output "kube_config" {
  value     = module.talos.kube_config
  sensitive = true
}

output "machine_config" {
  value     = module.talos.machine_config
  sensitive = true
}


# resource "local_file" "machine_configs" {
#   for_each        = module.talos.machine_config
#   content         = each.value.machine_configuration
#   filename        = "output/talos-machine-config-${each.key}.yaml"
#   file_permission = "0600"
# }

resource "local_file" "talos_config" {
  content         = module.talos.client_configuration.talos_config
  filename        = "output/talos-config.yaml"
  file_permission = "0600"
}

resource "local_file" "kube_config" {
  content         = module.talos.kube_config.kubeconfig_raw
  filename        = "output/kube-config.yaml"
  file_permission = "0600"
}
