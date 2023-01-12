terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.35"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.37"
    }
    curl = {
      source  = "anschoewe/curl"
      version = "0.1.3"
    }
  }
}
