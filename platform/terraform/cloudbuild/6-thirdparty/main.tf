module "jumphost_instance" {
    source                = "../../../tfm/6-third-party/"
    project_id    = "INSERT_VGCPPROJECT"
    cluster_name  = "INSERT_VGKECLUSTER"
    location      = "INSERT_VGCPREGIONPRIMARY"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
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