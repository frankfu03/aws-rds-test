data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config {
    bucket         = "${var.tf_state_bucket}"
    dynamodb_table = "${var.tf_state_table}"
    region         = "${var.region}"
    key            = "${var.application}/${var.environment}/terraform.tfstate"
  }
}

terraform {
  backend "s3" {}
}

data "external" "postgresql_master_password" {
  program = ["./postgresql-master-password.sh"]

  query = {
    password_key = "${var.environment}-${var.rds_master_password_credstash_key}"
  }
}

provider "postgresql" {
  alias    = "application_provider"
  host     = "${module.rds.rds_hostname}"
  port     = "5432"
  database = "postgres"
  username = "postgres"
  password = "${data.external.postgresql_master_password.result["password"]}"
  sslmode  = "require"

  connect_timeout  = 15
  expected_version = "9.6.9"
}

module "vpc" {
  source      = "./modules/support/vpc"
  environment = "${var.environment}"
}

module "rds" {
  source = "./modules/support/rds"

  application = "${var.application}"
  environment = "${var.environment}"
  region      = "${var.region}"

  rds_master_password = "${data.external.postgresql_master_password.result["password"]}"
  rds_instance_class  = "${var.aurora_postgresql_db_instance_class}"
  gnss_vpc_id         = "${module.vpc.gnss_vpc_id}"
}

module "rinex-file-index-projection" {
  source = "./modules/query/rinex-file-index"

  rds_hostname = "${module.rds.rds_hostname}"

  region      = "${var.region}"
  environment = "${var.environment}"
  application = "${var.application}"
}

output "postgresql_master_password" {
  value = "${data.external.postgresql_master_password.result["password"]}"
}

output "rds_hostname" {
  value = "${module.rds.rds_hostname}"
}
