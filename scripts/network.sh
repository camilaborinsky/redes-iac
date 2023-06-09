#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "$SCRIPT_DIR/../terraform"

export $(cat .env | xargs)

terraform -chdir=./api init
terraform -chdir=./api apply -auto-approve
