variable "region" {
  default = "ap-southeast-2"
}

variable "tf_state_bucket" {
  description = "Name of terraform state S3 bucket."
  default     = "geodesy-operations-terraform-state"
}

variable "tf_state_table" {
  description = "Name of terraform state lock DDB table."
  default     = "geodesy-operations-terraform-state"
}

variable "environment" {
  description = "Deployment environment. Suffixes most created objects."
  default     = "dev2"
}

variable "application" {
  description = "Application name. Used as webapp S3 bucket name, suffixed by the deployment environment name."
  default     = "geodesy-archive"
}

variable "aurora_postgresql_db_instance_class" {
  description = "DB instance class for aurora postgresql."
  default     = "db.r4.large"
}

variable "rds_master_password_credstash_key" {
  description = "The credstash key for the password of the master DB user"
  default     = "gnssRdsAdminPassword"
}
