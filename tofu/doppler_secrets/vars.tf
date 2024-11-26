variable "doppler_token" {
  type = string
  description = "API token to authenticate with Doppler"
  sensitive = true
}

variable "secrets" {
  type    = list(string)
  description = "List of secret names to load from doppler"

  validation {
    condition = alltrue([
      for secret in var.secrets :
      secret == upper(secret) || can(regex("^[A-Z]+(_[A-Z]+)*$", secret))
    ])
    error_message = "Each secret must be uppercase and follow the format: either TWO_WORDS (with underscores) or ONEWORD (no underscores)."
  }
}
