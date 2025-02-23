variable "proxmox" {
  description = "Connection details for Proxmox Cluster"
  type = object({
    name         = string
    cluster_name = string
    endpoint     = string
    insecure     = bool
    username     = string
    password     = string
    token        = string
    secret       = string
  })
  sensitive = true
}

variable "nodes" {
  description = "value"
  type = map(object({
    host_node     = string
    machine_type  = string
    datastore_id  = optional(string, "local-zfs")
    ip            = string
    mac_address   = string
    vm_id         = number
    cpu           = number
    ram_dedicated = number
    update        = optional(bool, false)
  }))
}

variable "talos_version" {
  type        = string
  description = "Version of TalosOS to install"
}
