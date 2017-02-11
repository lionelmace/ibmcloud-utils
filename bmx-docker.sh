#!/bin/bash
echo "Please choose an option:"
select target in "Option 1: cf ic" "Option 1: cf ic" "Exit"; do
  case $target in
  "Option 1: cf ic" )
    export DOCKER_HOST=
    export DOCKER_CERT_PATH=
    export DOCKER_TLS_VERIFY=
    break;;
  "Option 1: cf ic" )
    export DOCKER_HOST=tcp://containers-api.eu-gb.bluemix.net:8443
    export DOCKER_CERT_PATH=/Users/mace/.ice/certs/containers-api.eu-gb.bluemix.net/5c704be5-e47f-4842-9fb1-f3f412ca54a3
    export DOCKER_TLS_VERIFY=1
    exit;;
  esac
done