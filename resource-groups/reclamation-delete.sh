#!/bin/sh
# Uncommment to verbose
# set -x 

export RG_NAME="mytodo"

ibmcloud target -g $RG_NAME

# Start reading at 4th line
for rr in $(ibmcloud resource reclamations | awk '(NR>4) {print $1}')
do
  #echo $rr
  ibmcloud resource reclamation-delete $rr -f
done