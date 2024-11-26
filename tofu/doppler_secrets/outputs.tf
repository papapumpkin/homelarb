data "doppler_secrets" "this" {}

output "secrets" {
  value = {
    for secret in var.secrets : secret => data.doppler_secrets.this.map[secret]
  }
  sensitive = true
}
