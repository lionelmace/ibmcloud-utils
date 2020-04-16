#!/bin/bash
#
# Get the list of users and its associated parent within one account.
# Store the output in .csv.
# 
# ic sl user list
# id        username                                            email                             displayName
# 7042006   IBM1594534                                          lionel.mace@ibm.com               LIONELM
# 8178738   1594534_lionel.mace@company.com_2020-03-25-03.30.16 lionel.mace@company.com           LionelM
#
# ic sl user detail 8178738
#1 name           value
#2 ID             8178738
#3 Username       1594534_lionel.mace@company.com_2020-03-25-03.30.16
#4 Name           Lionel Mace
#5 Email          lionel.mace@company.com
#6 OpenID         lionel.mace@company.com
#7 Address        XX - Paris OT FR
#8 Company        IBM - 082400706
#9 Created        2020-03-25T08:30:17Z
#10 Phone Number   -
#11 Parent User    IBM1594534
#12 Status         Active
#13 PPTP VPN       false
#14 SSL VPN        false

source ../local.env

# Empty content file if already exist
cp /dev/null account-user-parent-list.csv

# Create a header in the file
echo "User email,Parent email" >> account-user-parent-list.csv

# Iterate through the list of users in the account
for i in `ibmcloud sl user list | awk '{ print $1}' `
do
  # Skip the first header row
  if [ $i = "id" ]
  then
    continue
  fi

  # Extract the email from user on the 5th line
  user_email=$(ibmcloud sl user detail $i | sed -n '5 p' | awk '{ print $2}')
  echo "Email User  : "$user_email

  # Extract the parent id from user on the 11th line
  user_parent=$(ibmcloud sl user detail $i | sed -n '11 p' | awk '{ print $3}')
  #echo "User parent : "$user_parent

  # The parent user starts with IBM. The command 'sl user detail' needs a number as input.
  # We need to retrieve the ID of the parent user name.
  user_parent_id=""
  while IFS= read -r line
  do
    # echo "line: $line"
    id=$(echo $line | awk '{ print $1}')
    username=$(echo $line | awk '{ print $2}')
    if [ "$username" == "$user_parent" ]
    then
      user_parent_id=$id
      #echo "user_parent_id: "$user_parent_id
    fi
  done < <(ibmcloud sl user list)
  
  if [ ! -z $user_parent_id ]
  then
    parent_email=$(ibmcloud sl user detail $user_parent_id | sed -n '5 p' | awk '{ print $2}')
  else
    parent_email="Owner"
  fi
  
  echo "Email Parent: "$parent_email 
  echo "----------------------------------------"
  # Add user and its parent in csv file
  echo $user_email","$parent_email >> account-user-parent-list.csv
  
done

# Print csf file
cat account-user-parent-list.csv