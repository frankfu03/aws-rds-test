#!/usr/bin/env bash

set -e

function usage {
    echo "Usage: ./deploy.sh [-d|--dry-run] <env>
        where
        -d, --dry-run
            do not run \"terraform apply\"
        env
            deployment environment, eg., dev2"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run )
            dryRun=true
            shift
            ;;
        dev2 )
            env=$1
            shift
            ;;
        * )
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [ -z $env ]; then
    echo "Error: deployment environment is empty."
    usage
fi

export TF_VAR_environment=$env

if [[ "$env" == "prod" ]]; then
    export TF_VAR_tf_state_bucket="geodesy-operations-terraform-state-${env}"
    export TF_VAR_tf_state_table="geodesy-operations-terraform-state-${env}"
else
    export TF_VAR_tf_state_bucket="geodesy-operations-terraform-state"
    export TF_VAR_tf_state_table="geodesy-operations-terraform-state"
fi

cd `dirname "$(realpath "$0")"`
cd aws/terraform

# wipe deploy-local.sh state override
rm -f main_override.tf
find . -name terraform.tfstate -exec rm {} \;

cat > main_override.tf << 'EOF'
provider "aws" {
  region = "${var.region}"
  version = "1.26"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  version = "1.26"
}
EOF

terraform init \
    -backend-config "bucket=$TF_VAR_tf_state_bucket" \
    -backend-config "dynamodb_table=$TF_VAR_tf_state_table" \
    -backend-config "region=ap-southeast-2" \
    -backend-config "key=geodesy-archive/$TF_VAR_environment/terraform.tfstate"

terraform get

if [ -z "$dryRun" ]; then
    terraform apply -auto-approve
else
    terraform plan
fi
