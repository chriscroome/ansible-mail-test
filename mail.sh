#!/usr/bin/env bash

if [[ -z "${1}" ]]; then
  echo "Please supply a servername as the first argument"
  exit 1
fi

ansible-playbook mail.yml -i "${1}," -e "hostname=${1}" -v
