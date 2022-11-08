#!/bin/sh
# Uncommment to verbose
# set -x 

export RG_NAME="mytodo"

ibmcloud target -g $RG_NAME

for rr in $(ibmcloud resource reclamations | awk '{print $1}')
do
  #echo $rr
  ibmcloud resource reclamation-delete $rr -f
done