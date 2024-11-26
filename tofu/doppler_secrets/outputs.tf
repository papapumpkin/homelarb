data "doppler_secrets" "this" {}

output "secrets" {
  value = {
    for secret in var.secrets : secret => data.doppler_secrets.this.map[secret]
  }
  // sensitive = true
}

output "api" {
  value     = data.doppler_secrets.this.map.PROXMOX_API_TOKEN_ID
  sensitive = true
}

output "secret" {
  value     = data.doppler_secrets.this.map.PROXMOX_API_TOKEN_SECRET
  sensitive = true
}
