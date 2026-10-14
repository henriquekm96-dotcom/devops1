terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  # Backend remoto no Cloud Storage para guardar o state com segurança
  backend "gcs" {
    bucket = "bucket-devops1" # Substituir pelo nome unico do bucket
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}