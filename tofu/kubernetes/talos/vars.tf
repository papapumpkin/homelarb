variable "cilium" {
  description = "Cilium configuration"
  type = object({
    values  = string
    install = string
  })
}

variable "k8s_cluster" {
  type = object({
    name            = string
    endpoint        = string
    gateway         = string
    talos_version   = string
    proxmox_cluster = string
  })
  description = "K8s Cluster details"
}

variable "proxmox_nodes" {
  description = "value"
  type = map(object({
    host_node     = string
    machine_type  = string
    datastore_id  = optional(string, "proxmoxpool01")
    ip            = string
    mac_address   = string
    vm_id         = number
    cpu           = number
    ram_dedicated = number
    update        = optional(bool, false)
  }))
}

variable "talos_image" {
  description = "Talos image configuration"
  type = object({
    version           = string
    arch              = optional(string, "amd64")
    platform          = optional(string, "nocloud")
    proxmox_datastore = optional(string, "local")
  })
}
