#!/bin/sh

ACCESS_GROUP_NAME="workshop"

for email in $EMAIL

do
  # Invite user to the Account
  printf "\n## Inviting user \"$email\" to the account id \"$ACCOUNT_ID\".\n"
  ibmcloud account user-invite $email

  # Invite user to the IAM Access Group
  printf "\n## Inviting user \"$email\" to the Acces Group \"$ACCESS_GROUP_NAME\".\n"
  ibmcloud iam access-group-user-add $ACCESS_GROUP_NAME $email

done
