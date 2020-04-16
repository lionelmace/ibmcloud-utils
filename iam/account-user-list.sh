#!/bin/bash

source ../local.env

for i in `ibmcloud account users | awk '{ print $1}' `
do
  #echo "ibmcloud account user-remove -f $i" >> remove_users.sh
  ALL=$ALL$i,
done

echo $ALL >> account_users.txt
# cat account_users.txt

# cat remove_users.sh
# echo "#"
# echo "# You can run bash remove_users.sh if you trust the user list above."
# echo "#"
