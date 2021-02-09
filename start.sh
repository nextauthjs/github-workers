#!/bin/bash

ACCESS_TOKEN=$ACCESS_TOKEN

REG_TOKEN="$(
  curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${ACCESS_TOKEN}" \
  https://api.github.com/repos/nextauthjs/next-auth/actions/runners/registration-token | \
  jq .token --raw-output
)"

cd /home/docker/actions-runner || exit


./config.sh --url https://github.com/nextauthjs/next-auth --token "${REG_TOKEN}"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!