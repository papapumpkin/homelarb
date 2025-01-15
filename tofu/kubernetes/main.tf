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

  proxmox_nodes = {
    "cp-01" = {
      host_node     = "pve1"
      machine_type  = "controlplane"
      ip            = "10.27.27.50"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 800
      cpu           = 4
      ram_dedicated = 4096
    }
    "cp-02" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.27.27.51"
      mac_address   = "10:e7:c6:00:6d:32"
      vm_id         = 801
      cpu           = 4
      ram_dedicated = 4096

    }
    "cp-03" = {
      host_node     = "pve3"
      machine_type  = "controlplane"
      ip            = "10.27.27.52"
      mac_address   = "10:62:e5:00:2e:3b"
      vm_id         = 802
      cpu           = 4
      ram_dedicated = 4096

    }
    "worker-01" = {
      host_node     = "pve1"
      machine_type  = "worker"
      ip            = "10.27.27.60"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 820
      cpu           = 4
      ram_dedicated = 4096
    }
    "worker-02" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.27.27.61"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 821
      cpu           = 4
      ram_dedicated = 4096
    }
    "worker-03" = {
      host_node     = "pve3"
      machine_type  = "worker"
      ip            = "10.27.27.62"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 822
      cpu           = 4
      ram_dedicated = 4096
    }
  }
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
