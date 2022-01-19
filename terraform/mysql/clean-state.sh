#!/bin/bash

rm -rf .terraform
rm .terraform.lock.hcl
rm terraform.tfstate*

echo 'All terraform states have been removed'
