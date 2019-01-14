resource "aws_vpc" "gnss_vpc" {
  cidr_block           = "10.2.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = "true"

  tags = {
    Name = "gnss-vpc-${var.environment}"
  }
}

# Internet Gateway to be attached to the VPC
resource "aws_internet_gateway" "rds-internet-gateway" {
  vpc_id = "${aws_vpc.gnss_vpc.id}"

  tags {
    Name = "gnss-rds-internet-gateway-${var.environment}"
  }
}

resource "aws_route" "gnss_route" {
  route_table_id         = "${aws_vpc.gnss_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.rds-internet-gateway.id}"
}

output "gnss_vpc_id" {
  value = "${aws_vpc.gnss_vpc.id}"
}
