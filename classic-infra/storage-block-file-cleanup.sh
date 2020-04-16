#!/bin/sh
#
# Loop to delete file and block storage

for i in `ic sl file volume-list | awk '{ print $1 }' `
do
  ic sl file volume-cancel $i -f
done

for i in `ic sl block volume-list | awk '{ print $1 }' `
do
  ic sl block volume-cancel $i -f
done