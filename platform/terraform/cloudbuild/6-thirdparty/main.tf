module "third-party" {
    source  = "../../../tfm/6-third-party/"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
      helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
  }

  required_version = "= 1.2.5"
}

terraform {
    backend "gcs" {
        bucket = "INSERT_VSTORAGEBUCKET"
        prefix = "thirdparty-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
    }
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}