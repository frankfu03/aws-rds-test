provider "aws" {
  region = "${var.region}"
  version = "1.26"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  version = "1.26"
}

