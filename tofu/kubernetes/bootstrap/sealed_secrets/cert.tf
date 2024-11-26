resource "tls_private_key" "sealed_secrets" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "sealed_secrets" {
  key_algorithm         = tls_private_key.sealed_secrets.algorithm
  private_key_pem       = tls_private_key.sealed_secrets.private_key_pem
  validity_period_hours = 8760 # 1 year
  early_renewal_hours   = 168  # 1 week before expiration
  subject = [
    {
      common_name  = "sealed-secret"
      organization = "sealed-secret"
    }
  ]
  allowed_uses = ["key_encipherment", "digital_signature", "server_auth"]
}

resource "doppler_secret" "sealed_secrets" {
  project = "homelarb"
  config  = "dev_personal"

  secrets = {
    "K8S_SEALED_SECRETS_CERT" = tls_self_signed_cert.sealed_secrets.cert_pem
    "K8S_SEALED_SECRETS_KEY"  = tls_private_key.sealed_secrets.private_key_pem
  }
}
