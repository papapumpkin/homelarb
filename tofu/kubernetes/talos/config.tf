resource "talos_machine_secrets" "this" {
  talos_version = var.k8s_cluster.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.k8s_cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.proxmox_nodes : v.ip]
  endpoints            = [for k, v in var.proxmox_nodes : v.ip if v.machine_type == "controlplane"]
}

data "talos_machine_configuration" "this" {
  for_each         = var.proxmox_nodes
  cluster_name     = var.k8s_cluster.name
  cluster_endpoint = "https://${var.k8s_cluster.endpoint}:6443"
  talos_version    = var.k8s_cluster.talos_version
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = each.value.machine_type == "controlplane" ? [
    templatefile("${path.module}/machine_config/control_plane.yaml.tftpl", {
      hostname       = each.key
      node_name      = each.value.host_node
      cluster_name   = var.k8s_cluster.proxmox_cluster
      ip             = each.value.ip
      cilium_values  = var.cilium.values
      cilium_install = var.cilium.install
    })
    ] : [
    templatefile("${path.module}/machine_config/worker.yaml.tftpl", {
      hostname     = each.key
      node_name    = each.value.host_node
      ip           = each.value.ip
      cluster_name = var.k8s_cluster.proxmox_cluster
    })
  ]
}

resource "talos_machine_configuration_apply" "this" {
  depends_on                  = [proxmox_virtual_environment_vm.this]
  for_each                    = var.proxmox_nodes
  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  lifecycle {
    # re-run config apply if vm changes
    replace_triggered_by = [proxmox_virtual_environment_vm.this[each.key]]
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.this]
  //for_each             = var.nodes
  //node                 = each.value.ip
  node                 = [for k, v in var.proxmox_nodes : v.ip if v.machine_type == "controlplane"][0]
  endpoint             = var.k8s_cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this
  ]
  skip_kubernetes_checks = false
  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = [for k, v in var.proxmox_nodes : v.ip if v.machine_type == "controlplane"]
  worker_nodes           = [for k, v in var.proxmox_nodes : v.ip if v.machine_type == "worker"]
  endpoints              = data.talos_client_configuration.this.endpoints
  timeouts = {
    read = "20m"
  }
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this,
    data.talos_cluster_health.this
  ]
  node                 = [for k, v in var.proxmox_nodes : v.ip if v.machine_type == "controlplane"][0]
  endpoint             = var.k8s_cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
  timeouts = {
    read = "1m"
  }
}
