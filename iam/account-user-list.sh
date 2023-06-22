#!/bin/bash

source ../local.env

count=0
file=account_users.txt
# Empty file content
cat /dev/null > $file

for i in `ibmcloud account users | awk '{ print $1}' `
do
  # Extract all Account Users
  ALL=$ALL$i,
  ((count=count+1))

  # Extract all IBM Cloud Users
  # if [[ $i == *"ibm"* ]]; then
  #   ALL=$ALL$i,
  #   ((count=count+1))
  # fi

  # Extract only Red Hat users
  # if [[ $i == *"redhat"* ]]; then
  #   # ALL=$ALL$i,
  #   ibmcloud account user-remove $i -f
  #   ((count=count+1))
  # fi
  
done

echo $count 'users extracted to ' $file
echo $ALL >> $file
cat $file

# cat remove_users.sh
# echo "#"
# echo "# You can run bash remove_users.sh if you trust the user list above."
# echo "#"
