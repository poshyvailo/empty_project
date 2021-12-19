#!/bin/bash

## set up base path
BASE_PATH="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )")";

## Set up .env file
set -o allexport
[[ -f ${BASE_PATH}/.env ]] && source "${BASE_PATH}"/.env
set +o allexport

docker-compose run \
  -u "$(id -u)" \
  --rm \
  php-cli "$@"
