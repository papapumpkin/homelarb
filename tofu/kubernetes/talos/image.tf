resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = [
            "siderolabs/qemu-guest-agent",
            "siderolabs/util-linux-tools",
            "siderolabs/iscsi-tools"
          ]
        }
      }
    }
  )
}

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  for_each = var.proxmox_nodes # Loop through all Proxmox nodes

  node_name    = each.value.host_node
  content_type = "iso"
  datastore_id = var.talos_image.proxmox_datastore

  file_name               = "talos-${each.key}-${var.talos_image.platform}-${var.talos_image.arch}.img"
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_image.version}/${var.talos_image.platform}-${var.talos_image.arch}.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
  verify                  = true
}
