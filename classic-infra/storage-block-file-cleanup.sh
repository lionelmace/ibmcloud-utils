#!/bin/sh
#
# Loop to delete file and block storage

source ../local.env

IAM_TOKEN=$(ibmcloud iam oauth-tokens | grep IAM | awk '{print $4}')

#for i in `ic sl block volume-list | awk '{ print $1}' `
for i in `ic sl file volume-list | awk '{ print $1}' `
do
  #ic sl block volume-cancel $i -f
  ic sl file volume-cancel $i -f
done