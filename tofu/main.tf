// Load secrets from Doppler for use in the stack
module "doppler_secrets" {
  source = "./doppler_secrets"

  doppler_token = var.doppler_token
  secrets = [
    "PROXMOX_API_TOKEN_ID",
    "PROXMOX_API_TOKEN_SECRET",
    "PROXMOX_ROOT_PASSWORD",
  ]
  providers = {
    doppler = doppler
  }
}

module "kubernetes" {
  source = "./kubernetes"

  talos_version = "v1.9.2"

  providers = {
    doppler = doppler
    tls     = tls
  }

  proxmox = {
    name         = "homelarb"
    cluster_name = "proxcluster1"
    endpoint     = "https://10.27.27.12:8006/"
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
      ip            = "10.27.27.50"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 800
      cpu           = 4
      ram_dedicated = 8192
    }
    "cp-02" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.27.27.51"
      mac_address   = "10:e7:c6:00:6d:32"
      vm_id         = 801
      cpu           = 4
      ram_dedicated = 8192
    }
    "cp-03" = {
      host_node     = "pve3"
      machine_type  = "controlplane"
      ip            = "10.27.27.52"
      mac_address   = "10:62:e5:00:2e:3b"
      vm_id         = 802
      cpu           = 4
      ram_dedicated = 8192
    }
    "worker-01" = {
      host_node     = "pve1"
      machine_type  = "worker"
      ip            = "10.27.27.60"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 820
      cpu           = 2
      ram_dedicated = 4096
    }
    "worker-02" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.27.27.61"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 821
      cpu           = 2
      ram_dedicated = 4096
    }
    "worker-03" = {
      host_node     = "pve3"
      machine_type  = "worker"
      ip            = "10.27.27.62"
      mac_address   = "ac:e2:d3:0b:da:0b"
      vm_id         = 822
      cpu           = 2
      ram_dedicated = 4096
    }
  }
}
