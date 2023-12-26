#!/bin/sh
#
# Loop to delete file and block storage

for i in `ibmcloud sl file volume-list | awk '{ print $1 }' `
do
  ibmcloud sl file volume-cancel $i -f
done

for i in `ibmcloud sl block volume-list | awk '{ print $1 }' `
do
  ibmcloud sl block volume-cancel $i -f
done