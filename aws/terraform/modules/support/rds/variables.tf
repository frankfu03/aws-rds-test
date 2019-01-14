variable "region" {}
variable "application" {}
variable "environment" {}
variable "gnss_vpc_id" {}

variable "cluster_size" {
  description = "Number of instances in the cluster"
  default     = 2
}

variable "db_engine_name" {
  description = "The name of the database engine to be used for the DB cluster"
  default     = "aurora-postgresql"
}

variable "db_engine_version" {
  description = "The database engine version"
  default     = "9.6.9"
}

variable "rds_master_password" {
  description = "The master password for the rds database"
}

variable "rds_instance_class" {
  description = "The database instance type"
}

variable "subnet_cidrs" {
  description = "List of subnet CIDRs"
  type        = "list"
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}
