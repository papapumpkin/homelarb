locals {
  proxmox_api_token = "${var.proxmox.token}=${var.proxmox.secret}"
}

module "talos" {
  source = "./talos"

  talos_image = {
    version = var.talos_version
  }

  cilium = {
    install = file("${path.module}/talos/inline_manifests/cilium_install.yaml")
    values  = file("${path.module}/../../k8s/infra/network/cilium/values.yaml")
  }

  k8s_cluster = {
    name            = "homelarb"
    proxmox_cluster = "proxcluster"
    endpoint        = "10.27.27.50"
    gateway         = "10.27.27.1"
    talos_version   = var.talos_version
  }

  proxmox_nodes = var.nodes
}

module "sealed_secrets" {
  depends_on = [module.talos]
  source     = "./bootstrap/sealed_secrets"

  providers = {
    kubernetes = kubernetes
    doppler    = doppler
    tls        = tls
  }
}

module "proxmox_csi_plugin" {
  depends_on = [module.talos]
  source     = "./bootstrap/proxmox_csi_plugin"

  providers = {
    proxmox    = proxmox
    kubernetes = kubernetes
  }

  proxmox = var.proxmox
}
