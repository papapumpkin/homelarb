output "client_configuration" {
  value     = module.kubernetes.client_configuration
  sensitive = true
}

output "kube_config" {
  value     = module.kubernetes.kube_config
  sensitive = true
}

output "machine_config" {
  value     = module.kubernetes.machine_config
  sensitive = true
}
