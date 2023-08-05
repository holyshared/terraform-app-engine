terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.39"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.39"
    }
  }
  required_version = "~> 1.2.8"
}
