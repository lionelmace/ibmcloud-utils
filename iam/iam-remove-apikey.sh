#!/bin/bash

# Remove the API Key created when provisioning clusters
# but don't get removed when deleting clusters!!

source ../local.env

count=0

for i in `ibmcloud iam api-keys | grep containers-kubernetes-key | awk '{ print $NF}' `
do
  # Delete API Key
  ibmcloud iam api-key-delete $i -f
  count=count+1
  
done

echo $count 'api keys deleted'
