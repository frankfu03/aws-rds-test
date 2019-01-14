resource "postgresql_role" "rinex_file_index_role" {
  provider         = "postgresql.application_provider"
  name             = "${var.index_username}"
  password         = "${var.index_password}"
  create_role      = true
  login            = true
  skip_drop_role   = true
  connection_limit = 5
}

resource "postgresql_database" "rinex_file_index_db" {
  provider = "postgresql.application_provider"
  name     = "${var.index_db_name}"
  owner    = "${postgresql_role.rinex_file_index_role.name}"
}

provider "postgresql" {
  alias    = "rinex_file_index_provider"
  host     = "${var.rds_hostname}"
  port     = "5432"
  database = "${var.index_db_name}"
  username = "${var.index_username}"
  password = "${var.index_password}"
  sslmode  = "require"

  connect_timeout  = 15
  expected_version = "9.6.9"
}

resource "postgresql_schema" "rinex_file_index_schema" {
  provider = "postgresql.rinex_file_index_provider"
  name     = "${var.index_db_name}"
  owner    = "${postgresql_role.rinex_file_index_role.name}"

  depends_on = ["postgresql_database.rinex_file_index_db"]
}
