terraform {
  required_version = ">= 1.0"
    required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=3.47, <=3.61.0 "
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.3"
    }
  }
}
