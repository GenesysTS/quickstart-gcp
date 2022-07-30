module "third-party" {
    source  = "../../../tfm/6-third-party/"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "INSERT_VGKECLUSTER" {
  name     = "INSERT_VGKECLUSTER"
  location = "INSERT_VGCPREGIONPRIMARY"
  project  = "INSERT_VGCPPROJECT"
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
    host  = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
    config_path = "~/.kube/config"
  }
}