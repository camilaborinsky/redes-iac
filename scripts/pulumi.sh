#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "$SCRIPT_DIR/../pulumi"

export $(cat .env | xargs)

pulumi login --local
pulumi stack init dev
pulumi up --non-interactive --yes