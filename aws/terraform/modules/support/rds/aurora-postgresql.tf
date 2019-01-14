locals {
  environment_suffix     = "${var.environment == "prod" ? "" : format("-%s", var.environment)}"
  rds_cluster_identifier = "${var.application}-${var.db_engine_name}${local.environment_suffix}"
}

resource "aws_rds_cluster" "db_cluster" {
  count                   = "${var.environment == "dev2" ? 1 : 0}"
  cluster_identifier      = "${local.rds_cluster_identifier}"
  master_password         = "${var.rds_master_password}"
  master_username         = "postgres"
  vpc_security_group_ids  = ["${aws_security_group.rds_security_group.id}"]
  engine                  = "${var.db_engine_name}"
  engine_version          = "${var.db_engine_version}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds-subnet-group.name}"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  count                        = "${var.environment == "dev2" ? var.cluster_size : 0}"
  identifier                   = "${local.rds_cluster_identifier}-instance-${count.index}"
  cluster_identifier           = "${aws_rds_cluster.db_cluster.id}"
  instance_class               = "${var.rds_instance_class}"
  engine                       = "${var.db_engine_name}"
  engine_version               = "${var.db_engine_version}"
  db_subnet_group_name         = "${aws_db_subnet_group.rds-subnet-group.name}"
  performance_insights_enabled = true
  publicly_accessible          = true
}

resource "aws_security_group" "rds_security_group" {
  count  = "${var.environment == "dev2" ? 1 : 0}"
  name   = "${var.application}-rds-security-group${local.environment_suffix}"
  vpc_id = "${var.gnss_vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["34.232.25.90/32", "34.236.25.177/32", "52.203.14.55/32", "192.104.44.129/32"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  count      = "${var.environment == "dev2" ? 1 : 0}"
  name       = "${var.application}-rds-subnet-group${local.environment_suffix}"
  subnet_ids = ["${aws_subnet.subnets.*.id}"]
}

resource "aws_subnet" "subnets" {
  count             = "${var.environment == "dev2" ? length(var.subnet_cidrs) : 0}"
  vpc_id            = "${var.gnss_vpc_id}"
  cidr_block        = "${element(var.subnet_cidrs, count.index)}"
  availability_zone = "${data.aws_availability_zones.main.names[count.index]}"

  tags = {
    Name = "gnss-subnet-${count.index}-${var.environment}"
  }
}

/*
  availability zones data template
*/
data "aws_availability_zones" "main" {}

output "rds_hostname" {
  value = "${aws_rds_cluster.db_cluster.0.endpoint}"
}
