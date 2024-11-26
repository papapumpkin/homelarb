terraform {
  required_providers {
    doppler = {
      source = "DopplerHQ/doppler"  // my secrets manager
    }
  }
}

provider "doppler" {
  doppler_token = var.doppler_token
}
