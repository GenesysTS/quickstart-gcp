terraform {
      required_providers {
        consul = {
          source = "hashicorp/consul"
          version = "2.15.1"
        }
        mssql = {
          source = "PGSSoft/mssql"
          version = "0.1.1"
        }
      }

  required_version = "= 1.2.5"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
  token      = "INSERT_CONSUL_TOKEN"
}

provider "mssql" {
  hostname = "localhost"
  port     = 1433

  sql_auth = {
    username = "sa"
    password = "INSERT_MSSQLSAPASSWORD"
  }
}