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
  provider = mssql
  name      = "gvp_rs"
}

resource "mssql_sql_login" "gkeadmin" {
  provider = mssql
  name                      = "gkeadmin"
  password                  = "Genesys@123"
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_login" "mssqlreader" {
  provider = mssql
  name                      = "mssqlreader"
  password                  = "Genesys@123"
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_user" "gkeadmin" {
  provider = mssql
  name        = "example"
  database_id = data.mssql_database.gvp-rs.id
  login_id    = mssql_sql_login.gkeadmin.id
  depends_on = [mssql_sql_login.gkeadmin]
}

resource "mssql_sql_user" "mssqlreader" {
  provider = mssql
  name        = "example"
  database_id = data.mssql_database.gvp-rs.id
  login_id    = mssql_sql_login.mssqlreader.id
  depends_on = [mssql_sql_login.mssqlreader]
}

resource "mssql_database_role" "gkeadmin" {
  provider = mssql
  name        = "db_owner"
  database_id = data.mssql_database.gkeadmin.id
  owner_id    = data.mssql_sql_user.gkeadmin.id
  depends_on = [mssql_sql_user.gkeadmin]
}

resource "mssql_database_role" "mssqlreader" {
  provider = mssql
  name        = "db_datareader"
  database_id = data.mssql_database.gkeadmin.id
  owner_id    = data.mssql_sql_user.mssqlreader.id
  depends_on = [mssql_sql_user.gkeadmin]
}