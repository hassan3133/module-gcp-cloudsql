terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.35"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.35"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
