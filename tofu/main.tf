// Load secrets from Doppler for use in the stack
module "doppler_secrets" {
  source = "./doppler_secrets"

  doppler_token = var.doppler_token
  secrets = [
    "PROXMOX_API_TOKEN_ID",
    "PROXMOX_API_TOKEN_SECRET",
    "PROXMOX_ROOT_PASSWORD",
  ]
}

module "kubernetes" {
  source = "./kubernetes"

  talos_version = "v1.8.3"

  proxmox = {
    name         = "homelarb"
    cluster_name = "proxcluster"
    endpoint     = "https://10.27.27.107:8006/"
    insecure     = true
    username     = "root"
    password     = module.doppler_secrets.secrets["PROXMOX_ROOT_PASSWORD"]
    token        = module.doppler_secrets.secrets["PROXMOX_API_TOKEN_ID"]
    secret       = module.doppler_secrets.secrets["PROXMOX_API_TOKEN_SECRET"]
  }

  nodes = {
    "cp-01" = {
      host_node     = "pve1"
      machine_type  = "controlplane"
      ip            = "10.27.27.107"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 800
      cpu           = 8
      ram_dedicated = 4096
    }
    "cp-02" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.27.27.106"
      mac_address   = "10:e7:c6:00:6d:32"
      vm_id         = 800
      cpu           = 8
      ram_dedicated = 4096

    }
    "cp-03" = {
      host_node     = "pve3"
      machine_type  = "controlplane"
      ip            = "10.27.27.13"
      mac_address   = "10:62:e5:00:2e:3b"
      vm_id         = 800
      cpu           = 8
      ram_dedicated = 4096

    }
    "worker-01" = {
      host_node     = "pve1"
      machine_type  = "worker"
      ip            = "10.27.27.107"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 800
      cpu           = 8
      ram_dedicated = 4096
    }
  }
}
