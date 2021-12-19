#!/bin/bash

## Output formats
NORMAL=$(tput sgr0)
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
B_GREEN=${BOLD}${GREEN}

## Set up base path
BASE_PATH="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )")";

echo "${B_GREEN}Initialization App${NORMAL}"

## Define .env file path
ENV_FILE="${BASE_PATH}"/.env
IS_INSTALL=false
if [[ ! -f "${ENV_FILE}" ]] ; then
    ## Copy .env from .env.example, if not exists
    $(cp ${ENV_FILE}.example ${ENV_FILE})
    IS_INSTALL=true
fi

if [[ ${IS_INSTALL} == true ]]; then
  ## Define empty port for nginx. Start from port number 8000.
  NGINX_PORT=8000
  while true
  do
      printf "${NGINX_PORT}\n"
      STATUS="$(nc -z 127.0.0.1 ${NGINX_PORT} < /dev/null &>/dev/null; echo $?)"
      if [ "${STATUS}" != "0" ]; then
            break;
      fi
      ((NGINX_PORT=NGINX_PORT+1))
  done
  sed -i -E "s/^(APP_NAME=).*/\1app_${NGINX_PORT}/" "${ENV_FILE}"
  sed -i -E "s/^(NGINX_PORT=).*/\1${NGINX_PORT}/" "${ENV_FILE}"
fi

## Function for change value
function change_value() {
    VAL_NAME=$1
    VAL=$(grep -oP "(?<=${VAL_NAME}=).*" "${ENV_FILE}");
    read -p "Change ${VAL_NAME}? Current - ${BOLD}${VAL}${NORMAL} [yN] " -n 1
    if [[ ! -z $REPLY ]]; then printf "\n"; fi
    if [[ $REPLY =~ ^[Yy]$ ]]; then read -p "Enter new value for ${VAL_NAME}: " VAL; fi
    sed -i -E "s/^(${VAL_NAME}=).*/\1${VAL}/" "${ENV_FILE}"
}

## Environment versions
change_value APP_NAME
change_value NGINX_HOST
change_value NGINX_PORT
change_value NGINX_VERSION
change_value PHP_VERSION
change_value MYSQL_VERSION
change_value XDEBUG_VERSION
change_value COMPOSER_VERSION

## Xdebug
change_value XDEBUG_IDE_SERVER_NAME

## MySql
change_value MYSQL_ROOT_PASSWORD
change_value MYSQL_USER
change_value MYSQL_PASSWORD
change_value MYSQL_DATABASE

MAKEFILE=${BASE_PATH}/Makefile
make -f ${MAKEFILE} build-all
make -f ${MAKEFILE} up
