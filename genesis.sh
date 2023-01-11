#!/usr/bin/env bash

set -eu

[ -n "${1:-}" ] || { echo "First parameter needs to be all, apply, plan, destroy"; exit 1; }

PROJECT_REGION="${PROJECT_REGION:-$(aws configure get region || echo "")}"
[ -n "${PROJECT_REGION:-}" ] || { echo "Env variable PROJECT_REGION not set"; exit 1; }

TMPDIR_BASE=$(dirname $(mktemp -u))

if [ "$1" = "destroy" ]; then
    terraform destroy -auto-approve -var "project_region=$PROJECT_REGION"
    exit 0
fi

[ -n "${DISCORD_BOT_BJ_CLIENT_ID:-}" ] || { echo "Env variable DISCORD_BOT_BJ_CLIENT_ID not set"; exit 1; }
[ -n "${DISCORD_BOT_BJ_TOKEN:-}" ] || { echo "Env variable DISCORD_BOT_BJ_TOKEN not set"; exit 1; }

if [ "$1" = "all" ]; then
    terraform init
fi

terraform validate
terraform plan \
    -var "project_region=$PROJECT_REGION" \
    -var "clientId=$DISCORD_BOT_BJ_CLIENT_ID" \
    -var "token=$DISCORD_BOT_BJ_TOKEN" \
    -out $TMPDIR_BASE/terraform-plan.tf

if [ "$1" = "apply" ] || [ "$1" = "all" ]; then
    terraform apply $TMPDIR_BASE/terraform-plan.tf
fi
