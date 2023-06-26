#!/bin/bash

# Remove the Block Storage volumes after ODF de-installation

count=0

for v in `ibmcloud is vols | grep odf | awk 'NR>1 {print $1}' `
do
  # Delete VPC Block Storage Volume
  ibmcloud is vold $v -f
  ((count=count+1))
  
done

echo $count 'volumes deleted'
