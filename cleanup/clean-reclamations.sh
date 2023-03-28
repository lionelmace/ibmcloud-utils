#!/bin/bash

# Remove the service reclamations

count=0

for i in `ibmcloud resource reclamations | awk 'NR>4 {print $1}' `
do
  # Delete reclamation Key
  ibmcloud resource reclamation-delete $i -f
  count=count+1
  
done

echo $count 'reclamations deleted'
