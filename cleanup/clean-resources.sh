#!/bin/bash

# Delete all the remaining instances in a Resource Group

count=0

for i in `ibmcloud resource service-instances --type all | awk 'NR>3 {print $1}' `
do
  # Delete the instance
  ibmcloud resource service-instance-delete $i -f
  count=count+1
  
done

echo $count 'instances deleted'
