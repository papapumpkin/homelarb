terraform {
  required_providers {
    doppler = {
      source = "DopplerHQ/doppler" // my secrets manager
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "doppler" {
  doppler_token = var.doppler_token
}
