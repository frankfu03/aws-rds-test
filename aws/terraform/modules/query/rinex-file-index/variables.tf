variable "region" {
  default = "ap-southeast-2"
}

variable "application" {}
variable "environment" {}

variable "rds_hostname" {}

variable "index_db_name" {
  default = "rinex-file-index"
}

variable "index_username" {
  default = "indexadmin"
}

variable "index_password" {
  default = "index"
}
