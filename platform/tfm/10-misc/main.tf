# Provider needs to be declared because it is non-hashicorp
terraform {
  required_providers {
    mssql = {
      source = "PGSSoft/mssql"
      version = "0.1.1"
    }
  }
}

### Create consul intentation to allow all-to-all connectivity
resource "consul_config_entry" "service_intentions" {
      name = "*"
      kind = "service-intentions"
      config_json = jsonencode({
        Sources = [
          {
            Name: "*",
            Action: "allow",
            Precedence: 5,
            Type: "consul"
          }
        ]
      })
    }

### Create MSSQL gvp-rs DB and users/logins
resource "mssql_database" "gvp-rs" {
  name      = "gvp_rs"
}

resource "mssql_sql_login" "gkeadmin" {
  name                      = "gkeadmin"
  password                  = "Genesys@123"
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_login" "mssqlreader" {
  name                      = "mssqlreader"
  password                  = "Genesys@123"
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_user" "gkeadmin" {
  name        = "gkeadmin"
  database_id = mssql_database.gvp-rs.id
  login_id    = mssql_sql_login.gkeadmin.id
  depends_on = [mssql_database.gvp-rs,mssql_sql_login.gkeadmin]
}

resource "mssql_sql_user" "mssqlreader" {
  name        = "mssqlreader"
  database_id = mssql_database.gvp-rs.id
  login_id    = mssql_sql_login.mssqlreader.id
  depends_on = [mssql_database.gvp-rs,mssql_sql_login.mssqlreader]
}

resource "mssql_database_role" "db_owner" {
  name        = "db_owner"
  database_id = mssql_database.gvp-rs.id
  #owner_id    = data.mssql_sql_user.owner.id
  depends_on = [mssql_database.gvp-rs]
}

resource "mssql_database_role" "db_datareader" {
  name        = "db_datareader"
  database_id = mssql_database.gvp-rs.id
  #owner_id    = data.mssql_sql_user.owner.id
  depends_on = [mssql_database.gvp-rs]
}

resource "mssql_database_role_member" "db_owner" {
  #name        = "db_owner"
  database_id = mssql_database.gvp-rs.id
  owner_id    = mssql_sql_user.gkeadmin.id
  depends_on = [mssql_database_role.db_owner,mssql_sql_user.gkeadmin]
}

resource "mssql_database_role_member" "db_datareader" {
  #name        = "db_datareader"
  database_id = mssql_database.gvp-rs.id
  owner_id    = mssql_sql_user.mssqlreader.id
  depends_on = [mssql_database_role.db_datareader,mssql_sql_user.gkeadmin]
}